//
//  UsersViewController.swift
//  prueba
//
//  Created by Adrian on 20/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit
import Localize_Swift

class UsersViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListUsers()
    }
    func filter(){
        if UserManager.shared.indFilter{
            let filter = UserManager.shared.userFilter
            for x in  (0 ..< UserManager.shared.users.count).reversed() {
                let user = UserManager.shared.users[x]
                if filter.id != nil && !Utils.compareInt(value: (user?.id)!, valueFind: filter.id!){
                    UserManager.shared.users.remove(at: x)
                }else if filter.name != nil && !Utils.containString(value: (user?.name)!, valueFind: filter.name!){
                    UserManager.shared.users.remove(at: x)
                }else if filter.birthdate != nil && !Utils.findDateInString(value: (user?.birthdate)!, valueFind: filter.birthdate!){
                    UserManager.shared.users.remove(at: x)
                }
            }
        }
    }
    
    func getListUsers(){
        UserManager.shared.getUsers(completion: { [weak self]
            result, errorMessage in
            
            if result == true{
                self!.filter()
                self!.tableVIew.reloadData()
            }else{
                print("Not possible get users to the server")
                let alertView = UIAlertController(title: "msg_error".localized(), message: errorMessage, preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "msg_btn_ok".localized(), style: .default) { (action) -> Void in
                    self!.getLocalUsers()
                }
                
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                
                // Add Actions
                alertView.addAction(yesAction)
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
    }
    func getLocalUsers(){
        UserManager.shared.getUsersForLocal(completion: { [weak self]
            result, errorMessage in
            
            if result == true{
                self!.tableVIew.reloadData()
            }else{
                print("Error to load local file")
                let alertView = UIAlertController(title: "msg_error_local".localized(), message: errorMessage, preferredStyle: .alert)
                
               
                
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                
                // Add Actions
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
    }
    func navegateToDetail(id: Int){
        UserManager.shared.idSelected = id
         parent?.performSegue(withIdentifier: "showDetail", sender: nil)

    }
    func deleteUser(id: Int){
        UserManager.shared.deleteUserDetail(id: id, completion:{ [weak self]
            result, errorMessage in
            
            if result == true{
                self?.getListUsers()
            }else{
                print("Not possible get users to the server")
                let alertView = UIAlertController(title: "msg_general_error".localized(), message: errorMessage, preferredStyle: .alert)
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
        
    }
}

extension UsersViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "primariCell")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        let user = UserManager.shared.users[indexPath.row]
        
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let dateLavel = cell.contentView.viewWithTag(2) as! UILabel
        
        nameLabel.text = user?.name
        
        if let date = user?.birthdate {
             dateLavel.text = Utils.UTCToLocal(date:date)
        }else{
             dateLavel.text = ""
        }
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    // Update the data model according to edit actions delete or insert.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
             let elementSelected = indexPath.row
            deleteUser(id: (UserManager.shared.users[elementSelected]?.id)!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // handle tap events
        print("You selected cell #\((indexPath as NSIndexPath).item)!")
        let elementSelected = indexPath.row
        navegateToDetail(id: (UserManager.shared.users[elementSelected]?.id)!)
    
    }
    
}
