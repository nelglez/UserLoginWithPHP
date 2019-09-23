//
//  RegisterViewController.swift
//  RegistrationWithPHP
//
//  Created by Nelson Gonzalez on 9/22/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailContinueButton: UIButton!
    @IBOutlet weak var fullNameContinueButton: UIButton!
    @IBOutlet weak var passwordContinueButton: UIButton!
    @IBOutlet weak var birthdayContinueButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    let helper = Helper()
    var userController: UserController?
    
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         //Make corners of objects rounded.
               cornerRadius(for: emailTextField)
               cornerRadius(for: firstNameTextField)
               cornerRadius(for: lastNameTextField)
               cornerRadius(for: passwordTextField)
               cornerRadius(for: birthdayTextField)
               
               cornerRadius(for: emailContinueButton)
               cornerRadius(for: fullNameContinueButton)
               cornerRadius(for: passwordContinueButton)
               cornerRadius(for: birthdayContinueButton)
               
        configureFooterView()
        
        //Apply padding to the text fields
               padding(for: emailTextField)
               padding(for: firstNameTextField)
               padding(for: lastNameTextField)
               padding(for: passwordTextField)
               padding(for: birthdayTextField)
        
         //MARK: - creating, configuring DatePicker into birthdayTextField
            
            datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -5, to: Date()) //cant pick date earlier than 5 years from current date. Cant be 5 years old.
        
            datePicker.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)
           birthdayTextField.inputView = datePicker
            
            //MARK:- Swipe Gesture
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handle(_:)))
            swipe.direction = .right
            self.view.addGestureRecognizer(swipe)
            
            //Tap Gesture to hide keyboard.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
       
    }
    
    //Will make corners rounded for any views (objects)
       private func cornerRadius(for view: UIView) {
           view.layer.cornerRadius = 5
           view.layer.masksToBounds = true
       }
    
    //Configuring the appearance of the footer view
       private func configureFooterView() {
           //Adding line at top of footer view.
           let topLine = CALayer()
           topLine.borderWidth = 1
           topLine.borderColor = UIColor.lightGray.cgColor
           topLine.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
           
           footerView.layer.addSublayer(topLine)
       }
    
    //Add blank view to the left side of the text field. Act as padding (blank gap)
      private func padding(for textfield: UITextField) {
          let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
          textfield.leftView = blankView
          textfield.leftViewMode = .always
      }
    
    //Swipe gesture to the right
       @objc private func handle(_ gesture: UISwipeGestureRecognizer) {
           //Get current horizontal scroll view position
           let currentX = scrollView.contentOffset.x
           let screenWidth = self.view.frame.width
           //from current position of scrollview we come back by width of the screen
           let newX = CGPoint(x: currentX - screenWidth, y: 0)
           
           if currentX > 0 {
           scrollView.setContentOffset(newX, animated: true)
           }
       }
       
       @objc private func tapGesture(_ gesture: UISwipeGestureRecognizer) {
           emailTextField.resignFirstResponder()
           firstNameTextField.resignFirstResponder()
           lastNameTextField.resignFirstResponder()
           passwordTextField.resignFirstResponder()
           birthdayTextField.resignFirstResponder()
       }
    
    //Executed when ever any date is selected.
      @objc private func datePickerDidChange(_ datePicker: UIDatePicker) {
         
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          birthdayTextField.text = formatter.string(from: datePicker.date)
         
          //Declaring the format of date, then to place a dummy date into this format.
          let compareDateFormatter = DateFormatter()
          compareDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
          
          let compareDate = compareDateFormatter.date(from: "2014/01/01 00:01") // Dont want anyone register who is later than this date
          
          //If user is older than 5 years show continue button.
          if datePicker.date < compareDate! {
              birthdayContinueButton.isHidden = false
          } else {
              birthdayContinueButton.isHidden = true
          }
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAccountVC" {
            let destination = segue.destination as! AccountViewController
            destination.userController = userController
        }
    }
       
    @IBAction func textfieldDidChange(_ textField: UITextField) {
        
        //Logic for email TextField, first and last name, and password.
               if textField == emailTextField && helper.isValid(email: emailTextField.text!) {
                   emailContinueButton.isHidden = false
               } else if textField == firstNameTextField || textField == lastNameTextField {
                   if helper.isValid(name: firstNameTextField.text!) && helper.isValid(name: lastNameTextField.text!) {
                      fullNameContinueButton.isHidden = false
                   }
                 
               } else if textField == passwordTextField {
                   if passwordTextField.text!.count >= 6 {
                       passwordContinueButton.isHidden = false
                   }
               }
    }
    
    
    @IBAction func emailContinueButtonPressed(_ sender: UIButton) {
        //Move scrollview horizontally by x to the width as a pointer.
            let position = CGPoint(x: self.view.frame.width, y: 0)
            scrollView.setContentOffset(position, animated: true)
             
             //Show/hide keyboard of next Textfield

             if firstNameTextField.text!.isEmpty {
                 firstNameTextField.becomeFirstResponder()
             } else if lastNameTextField.text!.isEmpty {
                 lastNameTextField.becomeFirstResponder()
             } else if firstNameTextField.text!.isEmpty == false  && lastNameTextField.text!.isEmpty == false {
                 firstNameTextField.resignFirstResponder()
                 lastNameTextField.resignFirstResponder()
             }
    }
    @IBAction func fullNameContinueButtonPressed(_ sender: UIButton) {
        //Move scrollview horizontally by x to the 2width as a pointer.
               let position = CGPoint(x: self.view.frame.width * 2, y: 0)
               scrollView.setContentOffset(position, animated: true)
               
         //Show keyboard of next Textfield
               if passwordTextField.text!.isEmpty {
                   passwordTextField.becomeFirstResponder()
               } else if passwordTextField.text!.isEmpty == false {
                   passwordTextField.resignFirstResponder()
               }
    }
    @IBAction func passwordContinueButtonPressed(_ sender: UIButton) {
        let position = CGPoint(x: self.view.frame.width * 3, y: 0)
               scrollView.setContentOffset(position, animated: true)
               
         //Show keyboard of next Textfield
               if birthdayTextField.text!.isEmpty {
                   birthdayTextField.becomeFirstResponder()
               } else if birthdayTextField.text!.isEmpty == false {
                   birthdayTextField.resignFirstResponder()
               }
    }
    @IBAction func birthdayContinueButtonPressed(_ sender: UIButton) {
        let position = CGPoint(x: self.view.frame.width * 4, y: 0)
              scrollView.setContentOffset(position, animated: true)
              
              //Hide keyboard when continue button in birthday is clicked.
             birthdayTextField.resignFirstResponder()
    }
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        
        userController?.registerUserWith(email: emailTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, password: passwordTextField.text!, birthday: datePicker.date, gender: sender.tag) { (user, error) in
            if let error = error {
                DispatchQueue.main.async {
                     self.helper.showAlert(title: "Error", message: error.localizedDescription, in: self)
                }
               
            }
            guard let user = user else { return }
            print(user)
            //Show next screen
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToAccountVC", sender: self)
            }
        }
    }
    
    @IBAction func alreadyHaveAnAccountButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
