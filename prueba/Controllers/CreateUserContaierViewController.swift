//
//  CreateUserContaierViewController.swift
//  prueba
//
//  Created by Adrian on 23/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit

class CreateUserContaierViewController: UIViewController {

    var delegate: CreateUser?
    var indUpdate:Bool = false
    @IBOutlet weak var creteUpdateButton: UIButton!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indUpdate = UserManager.shared.indUpdate
        if indUpdate{
            navigationBarTitle.title = "title_update_users".localized()
        }else{
            navigationBarTitle.title = "title_create_users".localized()
        }
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userForm" {
            if let nextViewController = segue.destination as? CreateUser {
                delegate = nextViewController
                nextViewController.delegateParent = self
            }
        }
    }
    
    func createUser(user:User){
        UserManager.shared.createUser(user, completion:{ [weak self]
            result, errorMessage in
            
            if result == true{
                self?.navigationController?.popViewController(animated: true)
            }else{
                print("Not possible get users to the server")
                let alertView = UIAlertController(title: "msg_general_error".localized(), message: errorMessage, preferredStyle: .alert)
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
    }
    
    func updateUser(user:User){
        UserManager.shared.createUser(user, completion:{ [weak self]
            result, errorMessage in
            
            if result == true{
                self?.navigationController?.popViewController(animated: true)
            }else{
                print("Not possible get users to the server")
                let alertView = UIAlertController(title: "msg_general_error".localized(), message: errorMessage, preferredStyle: .alert)
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func createUpdateUser(_ sender: Any) {
        if (delegate?.getUser())!{
            if indUpdate{
                self.updateUser(user: UserManager.shared.userCreateUpdate)
            }else{
                 self.createUser(user: UserManager.shared.userCreateUpdate)
            }
        }
    }
}
