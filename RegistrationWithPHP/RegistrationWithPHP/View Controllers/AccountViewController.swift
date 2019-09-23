//
//  AccountViewController.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/23/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var userController: UserController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadUserAccountInfo()
       
    }
    
    private func loadUserAccountInfo() {
        guard let firstName = userController?.user[0].firstName,
        let lastName = userController?.user[0].lastName,
            let email = userController?.user[0].email else { return }
        
        
        fullnameLabel.text = firstName + " " + lastName
        emailLabel.text = email
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        userController?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    

}
