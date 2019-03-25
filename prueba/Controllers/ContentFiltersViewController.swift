//
//  ContentFiltersViewController.swift
//  prueba
//
//  Created by Adrian on 24/3/19.
//  Copyright © 2019 Adrian. All rights reserved.
//

import UIKit

class ContentFiltersViewController: UIViewController {

    var delegate: FilterViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterForm" {
            if let nextViewController = segue.destination as? FilterViewController {
                delegate = nextViewController
            }
        }
    }
    @IBAction func setFilter(_ sender: Any) {
        delegate?.getUser()
        UserManager.shared.indFilter = true
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clearFilter(_ sender: Any) {
        delegate?.clearFilter()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
