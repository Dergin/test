//
//  UserDetailViewController.swift
//  prueba
//
//  Created by Adrian on 23/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var birthdayValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDetail(id: UserManager.shared.idSelected)
    }
    
    func setValues(){
        let user = UserManager.shared.userDetail.element
        if let id = user?.id{
            idValueLabel.text = String(id)
        }
        
        nameValueLabel.text = user?.name
        
        if let date = user?.birthdate {
            birthdayValueLabel.text = Utils.UTCToLocal(date:date)
        }else{
            birthdayValueLabel.text = ""
        }
    }
    
    func getDetail(id:Int){
        UserManager.shared.getUserDetail(id: id, completion:{ [weak self]
            result, errorMessage in
            
            if result == true{
                UserManager.shared.indUpdate = true
                self?.setValues()
            }else{
                print("Not possible get users to the server")
                let alertView = UIAlertController(title: "msg_error".localized(), message: errorMessage, preferredStyle: .alert)
                let noAction = UIAlertAction(title: "msg_btn_cancel".localized(), style: .default)
                alertView.addAction(noAction)
                self?.present(alertView, animated: true, completion: nil)
            }
        })
    }

}
