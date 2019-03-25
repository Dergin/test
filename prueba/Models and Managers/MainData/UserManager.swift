//
//  UserManager.swift
//  prueba
//
//  Created by Adrian on 19/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Crashlytics

typealias UserCompletionClosure = (_ result: Bool?, _ errorMessage: String?) -> Void


private let _shared = UserManager()

class UserManager {
    
    class var shared: UserManager {
        return _shared
    }
    
    enum UserManagerError: Error {
        case modelNotFound(String)
    }
    
    var users = SynchronizedArray<User>(queueLabel: "users")
    var userDetail = SynchronizedElement<User>(queueLabel: "userDetail")
    var idSelected:Int = -1
    var userCreateUpdate: User = User()
    var userFilter: User = User()
    var indUpdate = false
    var indFilter = false

    func getUsers(completion: UserCompletionClosure?) {
        indUpdate = false
        let downloadGroup = DispatchGroup()
    
        let params = [:] as Parameters
        var resultOperation : Bool = false
        
        var errorDescription: String!
        
        downloadGroup.enter()
        
        DataManager.getWithAlamofire(true, params: params, requestAddress: .getUsers) { (ReceivedData, msg) -> Void in
            
            let data = ReceivedData ?? Data()
            do{
                let json = try JSON(data: data)
                print("json: \(json)")
                
                let message: String = msg!
                
                switch message {
                case "200":
                    
                    do {
                        let userArray = try JSONDecoder().decode([User].self, from: data)
                        
                        self.users.removeAll()
                        self.users.append(userArray)
                        
                        resultOperation = true
                        
                    } catch {
                        print("ERROR: \(error)")
                        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                        resultOperation = false
                    }
                    
                default:
                    let data: String = String(data: data, encoding: .utf8)!
                    errorDescription = data
                    
                    resultOperation = false
                }
            }catch{
                print("ERROR: \(error)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                resultOperation = false
            }
            downloadGroup.leave()
        }
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, errorDescription)
            }
        }
        
    }
    
    func getUserDetail(id:Int,completion: UserCompletionClosure?) {
        
        let downloadGroup = DispatchGroup()
        
        let params = [:] as Parameters
        var resultOperation : Bool = false
        
        var errorDescription: String!
        
        downloadGroup.enter()
        
        DataManager.getWithAlamofireDetail(true, idDetail: id, params: params, requestAddress: .getUsers) { (ReceivedData, msg) -> Void in
            
            let data = ReceivedData ?? Data()
            do{
                let json = try JSON(data: data)
                print("json: \(json)")
                
                let message: String = msg!
                
                switch message {
                case "200":
                    
                    do {
                        let userReceived = try JSONDecoder().decode(User.self, from: data)
                        
                        self.userDetail.element = userReceived
                        
                        resultOperation = true
                        
                    } catch {
                        print("ERROR: \(error)")
                        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                        resultOperation = false
                    }
                    
                default:
                    let data: String = String(data: data, encoding: .utf8)!
                    errorDescription = data
                    
                    resultOperation = false
                }
            }catch{
                print("ERROR: \(error)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                resultOperation = false
            }
            downloadGroup.leave()
        }
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, errorDescription)
            }
        }
        
    }
    
    func deleteUserDetail(id:Int,completion: UserCompletionClosure?) {
        
        let downloadGroup = DispatchGroup()
        
        let params = [:] as Parameters
        var resultOperation : Bool = false
        
        var errorDescription: String!
        
        downloadGroup.enter()
        
        DataManager.deleteWithAlamofire(true, idDetail: id, params: params, requestAddress: .getUsers) { (ReceivedData, msg) -> Void in
            
            let data = ReceivedData ?? Data()
            do{
                let json = try JSON(data: data)
                print("json: \(json)")
                
                let message: String = msg!
                
                switch message {
                case "200":
                    resultOperation = true
                default:
                    let data: String = String(data: data, encoding: .utf8)!
                    errorDescription = data
                    
                    resultOperation = false
                }
            }catch{
                print("ERROR: \(error)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                resultOperation = false
            }
            downloadGroup.leave()
        }
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, errorDescription)
            }
        }
        
    }
    
    func createUser(_ r: User, completion: UserCompletionClosure?) {
        
        let downloadGroup = DispatchGroup()
        var resultOperation : Bool = false
        var errorDescription: String!
        
        downloadGroup.enter()
        DataManager.postRequest(.getUsers, encodableData: r) { (ReceivedData, httpHeaders, msg) -> Void in
            
            let data = ReceivedData ?? Data()
            print("Response Code: \(String(describing: msg))")
            let message: String = msg!
            
            switch message {
            case "200":
                
                resultOperation = true
                
            case "TIMEOUT":
                resultOperation = false
                errorDescription = "timeout_message".localized()
                
            default:
                let data: String = String(data: data, encoding: .utf8)!
                errorDescription = data
                
                resultOperation = false
            }
            
            downloadGroup.leave()
            
        }
        
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, errorDescription)
            }
        }
        
    }
    
    func updateUser(_ r: User, completion: UserCompletionClosure?) {
        
        let downloadGroup = DispatchGroup()
        var resultOperation : Bool = false
        var errorDescription: String!
        
        downloadGroup.enter()
        DataManager.putWithAlamofire(.getUsers, encodableData: r) { (ReceivedData, httpHeaders, msg) -> Void in
            
            let data = ReceivedData ?? Data()
            print("Response Code: \(String(describing: msg))")
            let message: String = msg!
            
            switch message {
            case "200":
                
                resultOperation = true
                
            case "TIMEOUT":
                resultOperation = false
                errorDescription = "timeout_message".localized()
                
            default:
                let data: String = String(data: data, encoding: .utf8)!
                errorDescription = data
                
                resultOperation = false
            }
            
            downloadGroup.leave()
            
        }
        
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, errorDescription)
            }
        }
        
    }
    
    func getUsersForLocal(completion: UserCompletionClosure?) {
        
        let downloadGroup = DispatchGroup()
        
        var resultOperation : Bool = false
        downloadGroup.enter()
        let location = "exaple"
        let fileType = "json"
        if let path = Bundle.main.path(forResource: location, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                if jsonObj != JSON.null {
        
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let userArray = try decoder.decode([User].self, from: data)
                        
                        self.users.removeAll()
                        self.users.append(userArray)
                        
                        resultOperation = true
                        
                    } catch {
                        print("ERROR: \(error)")
                        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                        resultOperation = false
                    }
                }
            } catch let error {
                print("ERROR: \(error)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                resultOperation = false
            }

        }else{
            
           // Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
            //Crashlytics.sharedInstance().recordError("error", withAdditionalUserInfo: ["ErrorDescription":"error"])
            resultOperation = false
        }
            downloadGroup.leave()
        
        downloadGroup.notify(queue: GlobalMainQueue) {
            if let completion = completion {
                completion(resultOperation, "")
            }
        }
    }
    
    
}
