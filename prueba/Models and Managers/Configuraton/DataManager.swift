//
//  DataManager.swift
//  prueba
//
//  Created by Adrian on 19/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics
import SwiftyJSON
enum RequestAddresses: String {
   
    case getUsers = "/api/User"
    
   
    
    init() {
        self = .getUsers
    }
    
    func Description() -> String{
        
        
        // Begin the return string with "/ES", "/EN", etc. depending on the user's device language
        var returnString: String
        
        
            returnString = self.rawValue
        
        print(returnString)
        return returnString
    }
}



class DataManager {
    class func getWithAlamofire(_ authorization: Bool, params : Parameters, requestAddress: RequestAddresses, timeoutInterval: TimeInterval = 20, success: @escaping ((_ ResponseData: Data?,_ msg: String?) -> Void)) {
        
        let url = Foundation.URL(string: ConfigurationManager.shared.serverURL + requestAddress.Description())!
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = timeoutInterval
        var remainingRetries = 3
        
        
        // MARK: Workaround to transform boolean values to string values and fix the problem of booleans becoming 1 or 0
        let convertedParams = Utils.convertBoolToString(params)
        
        let encodedURLRequest = try! URLEncoding.queryString.encode(urlRequest, with: convertedParams)
        
        //print("Params: \(params)")
        
        
        //let sessionManager = Alamofire.SessionManager.default
        
        print("GET Request: \(encodedURLRequest)")
        
        Alamofire.request(encodedURLRequest)
            //.validate(statusCode: 200..<300)
            //.validate(contentType: ["application/json"])
            .responseData { response in
                
                switch response.result {
                    
                // Server responded
                case .success:
                    print("REQUEST SUCCESS with statusCode: \(response.response?.statusCode.description ?? "nil")")
                    // Status 200 -> Call success closure
                    if  response.response?.statusCode == 200 {
                        success(response.data! as Data, "200")
                    }else if response.response?.statusCode == 401 && remainingRetries > 0 {
                        remainingRetries -= 1
                    }else {
                        success(response.data! as Data, "\(response.response?.statusCode ?? 418)") // Return 418 (I'm a teapot!) status code if the response is nil
                    }
                    
                case .failure(let error):
                    
                    print("REQUEST FAILURE")
                    print(error)
                    if error._code == NSURLErrorTimedOut {
                        success(nil, "TIMEOUT")
                    }
                    else {
                        success(nil, error.localizedDescription)
                    }
                }
        }
        
    }
    
    class func getWithAlamofireDetail(_ authorization: Bool,idDetail:Int, params : Parameters, requestAddress: RequestAddresses, timeoutInterval: TimeInterval = 20, success: @escaping ((_ ResponseData: Data?,_ msg: String?) -> Void)) {
        
        let url = Foundation.URL(string: ConfigurationManager.shared.serverURL + requestAddress.Description() + "/\(idDetail)")!
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = timeoutInterval
        var remainingRetries = 3
        
        
        // MARK: Workaround to transform boolean values to string values and fix the problem of booleans becoming 1 or 0
        let convertedParams = Utils.convertBoolToString(params)
        
        let encodedURLRequest = try! URLEncoding.queryString.encode(urlRequest, with: convertedParams)
        
        //print("Params: \(params)")
        
        
        //let sessionManager = Alamofire.SessionManager.default
        
        print("GET Request: \(encodedURLRequest)")
        
        Alamofire.request(encodedURLRequest)
            //.validate(statusCode: 200..<300)
            //.validate(contentType: ["application/json"])
            .responseData { response in
                
                switch response.result {
                    
                // Server responded
                case .success:
                    print("REQUEST SUCCESS with statusCode: \(response.response?.statusCode.description ?? "nil")")
                    // Status 200 -> Call success closure
                    if  response.response?.statusCode == 200 {
                        success(response.data! as Data, "200")
                    }else if response.response?.statusCode == 401 && remainingRetries > 0 {
                        remainingRetries -= 1
                    }else {
                        success(response.data! as Data, "\(response.response?.statusCode ?? 418)") // Return 418 (I'm a teapot!) status code if the response is nil
                    }
                    
                case .failure(let error):
                    
                    print("REQUEST FAILURE")
                    print(error)
                    if error._code == NSURLErrorTimedOut {
                        success(nil, "TIMEOUT")
                    }
                    else {
                        success(nil, error.localizedDescription)
                    }
                }
        }
        
    }
    
    class func postRequest<T: Encodable>(_ requestAddress: RequestAddresses, queryStringParameters: Parameters? = nil, encodableData: T?, addFirebaseToken: Bool = false, timeoutInterval: TimeInterval = 40, success: @escaping ((_ ResponseData: Data?, _ httpHeaders: [AnyHashable: Any], _ msg: String?) -> Void)) {
        
        let url = Foundation.URL(string: ConfigurationManager.shared.serverURL + requestAddress.Description())!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = timeoutInterval
        var remainingRetries = 3
        
        
        
        // Add queryStringParameters to the URL
        if let params = queryStringParameters {
            var queryString = String()
            
            // Convert the Dictionary into a string
            for(key,value) in params { queryString = queryString + "\(key)=\(value)&" }
            
            // Add string to URL
            urlRequest.url = Foundation.URL(string: "\(url)?\(queryString)")
            debugPrint("request URL: \(urlRequest.url?.description ?? "nil")")
        }
        if let unwrappedEncodableData = encodableData {
            do {
                let jsonEncodedData = try JSONEncoder().encode(unwrappedEncodableData)
                urlRequest.httpBody = jsonEncodedData
                urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
            }
            catch {
                print("ERROR: \(error.localizedDescription)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                success(nil, [:], error.localizedDescription)
                return
            }
        }
        
        
        print(urlRequest)
        Alamofire.request(urlRequest)

            .responseData {
                response in
                
                switch response.result {
                    
                // Server responded
                case .success:
                    print("REQUEST SUCCESS")
                    
                    // DEBUG
                    print("request: \(request)")
                    print("REQUEST SUCCESS with statusCode: \(response.response?.statusCode.description ?? "nil")")
                    
                    // Status 200 -> Call success closure
                    if response.response?.statusCode == 200 {
                        success(response.data! as Data, response.response!.allHeaderFields, "200")
                    }
                        
                        // Status 401 -> Unauthorized. Try to renew access_token
                    else if response.response?.statusCode == 401 && remainingRetries > 0 {
                        
                        remainingRetries -= 1
                        
                            postRequest(requestAddress, queryStringParameters: queryStringParameters, encodableData: encodableData, addFirebaseToken: addFirebaseToken, timeoutInterval: timeoutInterval, success: success)
                       
                        
                        //success(response.data! as Data, "401")
                    }
                        
                        // Other status codes -> Call closure with ERROR
                    else {
                        success(response.data! as Data, [:], "\(response.response?.statusCode ?? 418)") // Return 418 (I'm a teapot!) status code if the response is nil
                    }
                    
                    
                // Server didn't respond
                case .failure(let error):
                    print("REQUEST FAILURE")
                    print(error)
                    if error._code == NSURLErrorTimedOut {
                        success(nil, [:], "TIMEOUT")
                    }
                    else {
                        success(nil, [:], error.localizedDescription)
                    }
                }
        }
        
    }
    
    class func putWithAlamofire<T: Encodable>(_ requestAddress: RequestAddresses, queryStringParameters: Parameters? = nil, encodableData: T?, addFirebaseToken: Bool = false, timeoutInterval: TimeInterval = 40, success: @escaping ((_ ResponseData: Data?, _ httpHeaders: [AnyHashable: Any], _ msg: String?) -> Void)) {
        
        let url = Foundation.URL(string: ConfigurationManager.shared.serverURL + requestAddress.Description())!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = timeoutInterval
        var remainingRetries = 3
        
        
        
        // Add queryStringParameters to the URL
        if let params = queryStringParameters {
            var queryString = String()
            
            // Convert the Dictionary into a string
            for(key,value) in params { queryString = queryString + "\(key)=\(value)&" }
            
            // Add string to URL
            urlRequest.url = Foundation.URL(string: "\(url)?\(queryString)")
            debugPrint("request URL: \(urlRequest.url?.description ?? "nil")")
        }
        if let unwrappedEncodableData = encodableData {
            do {
                let jsonEncodedData = try JSONEncoder().encode(unwrappedEncodableData)
                urlRequest.httpBody = jsonEncodedData
                urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
            }
            catch {
                print("ERROR: \(error.localizedDescription)")
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["ErrorDescription":"\(error)"])
                success(nil, [:], error.localizedDescription)
                return
            }
        }
        
        
        print(urlRequest)
        Alamofire.request(urlRequest)
            
            .responseData {
                response in
                
                switch response.result {
                    
                // Server responded
                case .success:
                    print("REQUEST SUCCESS")
                    
                    // DEBUG
                    print("request: \(request)")
                    print("REQUEST SUCCESS with statusCode: \(response.response?.statusCode.description ?? "nil")")
                    
                    // Status 200 -> Call success closure
                    if response.response?.statusCode == 200 {
                        success(response.data! as Data, response.response!.allHeaderFields, "200")
                    }
                        
                        // Status 401 -> Unauthorized. Try to renew access_token
                    else if response.response?.statusCode == 401 && remainingRetries > 0 {
                        
                        remainingRetries -= 1
                        
                        postRequest(requestAddress, queryStringParameters: queryStringParameters, encodableData: encodableData, addFirebaseToken: addFirebaseToken, timeoutInterval: timeoutInterval, success: success)
                        
                        
                        //success(response.data! as Data, "401")
                    }
                        
                        // Other status codes -> Call closure with ERROR
                    else {
                        success(response.data! as Data, [:], "\(response.response?.statusCode ?? 418)") // Return 418 (I'm a teapot!) status code if the response is nil
                    }
                    
                    
                // Server didn't respond
                case .failure(let error):
                    print("REQUEST FAILURE")
                    print(error)
                    if error._code == NSURLErrorTimedOut {
                        success(nil, [:], "TIMEOUT")
                    }
                    else {
                        success(nil, [:], error.localizedDescription)
                    }
                }
        }
        
    }
    
    class func deleteWithAlamofire(_ authorization: Bool,idDetail:Int, params : Parameters, requestAddress: RequestAddresses, timeoutInterval: TimeInterval = 20, success: @escaping ((_ ResponseData: Data?,_ msg: String?) -> Void)) {
        
        let url = Foundation.URL(string: ConfigurationManager.shared.serverURL + requestAddress.Description() + "/\(idDetail)")!
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.timeoutInterval = timeoutInterval
        var remainingRetries = 3
        
        
        // MARK: Workaround to transform boolean values to string values and fix the problem of booleans becoming 1 or 0
        let convertedParams = Utils.convertBoolToString(params)
        
        let encodedURLRequest = try! URLEncoding.queryString.encode(urlRequest, with: convertedParams)
        
        //print("Params: \(params)")
        
        
        //let sessionManager = Alamofire.SessionManager.default
        
        print("DELETE Request: \(encodedURLRequest)")
        
        Alamofire.request(encodedURLRequest)
            //.validate(statusCode: 200..<300)
            //.validate(contentType: ["application/json"])
            .responseData { response in
                
                switch response.result {
                    
                // Server responded
                case .success:
                    print("REQUEST SUCCESS with statusCode: \(response.response?.statusCode.description ?? "nil")")
                    // Status 200 -> Call success closure
                    if  response.response?.statusCode == 200 {
                        success(response.data! as Data, "200")
                    }else if response.response?.statusCode == 401 && remainingRetries > 0 {
                        remainingRetries -= 1
                    }else {
                        success(response.data! as Data, "\(response.response?.statusCode ?? 418)") // Return 418 (I'm a teapot!) status code if the response is nil
                    }
                    
                case .failure(let error):
                    
                    print("REQUEST FAILURE")
                    print(error)
                    if error._code == NSURLErrorTimedOut {
                        success(nil, "TIMEOUT")
                    }
                    else {
                        success(nil, error.localizedDescription)
                    }
                }
        }
        
    }
}
