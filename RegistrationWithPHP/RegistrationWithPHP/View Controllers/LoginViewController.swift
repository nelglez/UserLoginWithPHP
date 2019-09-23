//
//  ViewController.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/22/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userController = UserController()
 
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if !userController.user.isEmpty {
            print("User is not nil! Present User To Other VC")
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
            controller.userController = userController
            
            DispatchQueue.main.async {
                self.getTopMostViewController()?.present(controller, animated: true, completion: nil)
            }
        }
    }

    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAccountVC" {
        let destination = segue.destination as! AccountViewController
        destination.userController = userController
        } else if segue.identifier == "ToRegisterVC" {
            let destination = segue.destination as! RegisterViewController
            destination.userController = userController
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let helper = Helper()
        
        if !helper.isValid(email: emailTextField.text!){
            helper.showAlert(title: "Invalid Email", message: "Please enter register email address", in: self)
            return
        } else if passwordTextField.text!.count < 6 {
            helper.showAlert(title: "Invalid Password", message: "Password must contain at least 6 characters", in: self)
            return
        }
        
        userController.logUserIn(email: emailTextField.text!.lowercased(), password: passwordTextField.text!) { (_, error) in
            if let error = error {
                helper.showAlert(title: "Error", message: error.localizedDescription, in: self)
                return
            }
            
            //Take user to next screen
            self.performSegue(withIdentifier: "ToAccountVC", sender: self)
        }
    }
    
}

