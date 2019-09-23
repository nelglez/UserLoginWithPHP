//
//  Helper.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/22/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class Helper {
//Validate email address logic
   func isValid(email: String) -> Bool {
       //Declaring the rule of characters to be used. Applying rule to current state. Verifying the result.
       let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let test = NSPredicate(format: "SELF MATCHES %@", regex)
       let result = test.evaluate(with: email)
       
       return result
   }
   
   //validate name logic
   func isValid(name: String) -> Bool {
       //Declaring the rule of characters to be used. Applying rule to current state. Verifying the result.
       let regex = "[A-Za-z]{2,}"
       let test = NSPredicate(format: "SELF MATCHES %@", regex)
       let result = test.evaluate(with: name)
       
       return result
   }
   //Shows alert message to the user
   func showAlert(title: String, message: String, in vc: UIViewController) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       alert.addAction(okAction)
       
       vc.present(alert, animated: true, completion: nil)
   }
   
}
