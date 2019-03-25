//
//  FilterViewController.swift
//  prueba
//
//  Created by Adrian on 24/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
        
        //Array
        
        @IBOutlet weak var name: UITextField!
        @IBOutlet weak var id: UITextField!
        @IBOutlet weak var dateContainerView: UIView!
        
        var delegateParent: CreateUserContaierViewController? = CreateUserContaierViewController()
        
        //Pickers
        
        @IBOutlet weak var dayButton: UIButton!
        var daySelected: Bool = false
        
        @IBOutlet weak var dayConstHeight: NSLayoutConstraint!
        
        @IBOutlet weak var fromDay: UIDatePicker!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.endEditing(true)
            setValues()
            fromDay.datePickerMode = .date
            setupKeyboardDismissRecognizer()
        }
    
    func setValues(){
        if UserManager.shared.indFilter{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let user = UserManager.shared.userFilter
            name.text = user.name
            if let idValue = user.id{
                id.text = String(idValue)
            }
            
            if (user.birthdate != nil){
                let date = dateFormatter.date(from:(user.birthdate)!)
                 fromDay.setDate(date!, animated: false)
                 dayButton.setTitle(Utils.UTCToLocal(date: (user.birthdate)!), for: .normal)
            }
           
           
        }
    }
        
        func setupKeyboardDismissRecognizer(){
            let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapRecognizer)
        }
        
        @objc func dismissKeyboard()
        {
            view.endEditing(true)
        }
        
        func initialiceConstPicker(){
            dayConstHeight.constant = 0
        }
        
        
        func openPicker(ind:Int){
            var picker: UIDatePicker = UIDatePicker()
            var constraint: NSLayoutConstraint = NSLayoutConstraint()
            switch ind {
            case 1:
                constraint = dayConstHeight
                picker = fromDay
            default:
                break
            }
            
            view.endEditing(true)
            picker.superview!.alpha = 0
            picker.superview!.isHidden = false
            UIView.animate(withDuration: 0.35, animations: {
                picker.superview!.alpha = 1
            })
            Utils.simpleConstraintAnimation(view: self.view, constraint: constraint, desiredConstant: 234, time: 0.35)
        }
        
        func hidePicker(ind:Int){
            var picker: UIDatePicker = UIDatePicker()
            var constraint: NSLayoutConstraint = NSLayoutConstraint()
            switch ind {
            case 1:
                constraint = dayConstHeight
                picker = fromDay
            default:
                break
            }
            picker.superview!.alpha = 1
            UIView.animate(withDuration: 0.37, animations: {
                picker.superview!.alpha = 0
            }, completion: {
                _ in picker.superview!.isHidden = true
            })
            Utils.simpleConstraintAnimation(view: self.view, constraint: constraint, desiredConstant: 0, time: 0.35)
        }
        
        func selectedElement(ind:Int){
            var text = "";
            var button: UIButton
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            switch ind {
            case 1:
                text = dateFormatter.string(from: fromDay.date)
                button = dayButton
                daySelected = true
                
            default:
                text = dateFormatter.string(from: fromDay.date)
                button = dayButton
            }
            button.setTitle(text, for: .normal)
            button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        
        //Open Pickers
        @IBAction func openPikerDaysView(_ sender: Any) {
            if self.fromDay.superview!.isHidden {
                openPicker(ind: 1)
            }else {
                hidePicker(ind: 1)
            }
        }
        
        
        @IBAction func pickerDays(_ sender: Any) {
            hidePicker(ind: 1)
            selectedElement(ind: 1)
        }
        
    
        func getUser(){
                let user:User = User()
                user.id = Int(id.text!)
                user.name = name.text
            if daySelected{
                user.birthdate = Utils.LocalToUTC(date: fromDay.date)
            }else{
                user.birthdate = nil
            }
            
                UserManager.shared.userFilter = user
        }
    func clearFilter(){
        name.text = ""
        id.text = ""
        dayButton.setTitle("title_birthdaty".localized(), for: .normal)
        dayButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        daySelected = false
        fromDay.setDate(Date(), animated: false)
    }
}
