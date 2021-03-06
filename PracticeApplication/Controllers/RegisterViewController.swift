//
//  RegisterViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 23/06/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var fullNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var dateOfBirth: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
     let db = Firestore.firestore()
    let picker = UIDatePicker()
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        showDatePicker()
        }
    
    func showDatePicker() {
        picker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateOfBirth.inputAccessoryView = toolbar
        dateOfBirth.inputView = picker
    }
    @objc func donedatePicker() {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           dateOfBirth.text = formatter.string(from: picker.date)
           self.view.endEditing(true)
       }
       
       @objc func cancelDatePicker() {
           self.view.endEditing(true)
       }
    
    func setupElements(){
        // hide the error label
        errorLabel.alpha = 0
        
    }
    
    // validating the fields
    func validateFields() -> String? {
        // check all the fields are filled or not
        if fullNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateOfBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all the fields"
        }
        // check the email validation
               let emailVal = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               if Utilities.isValidEmail(emailVal) == false {
                   return "email must be valid"
               }
        // check the password validation
        let passVal = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidPassword(passVal) == false {
            return "password must be atleast 6 characters with alteast 1 numeric, 1 capital and 1 special character"
        }
       
        // check the phoneNumber validation
        let phoneVal = phoneNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidPhone(phoneVal) ==  false {
            return "phone number must valid phone number"
        }
        return nil
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // validate the fields
        let error = validateFields()
        if error != nil {
            errorMessage(error!)
        }else {
            // creating referenece to the fields
            let fullName = fullNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let dob = dateOfBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNum = phoneNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // create a User
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                // check there is an any error
                if err != nil {
                    self.errorMessage("Email already exists")
                }else {
                    // the user created successfully
                    self.db.collection("users").addDocument(data: ["fullName":fullName, "phoneNumber":phoneNum, "DOB": dob!, "uid": result!.user.uid]) { (er) in
                        if er != nil {
                            self.errorMessage("Please enter the data again and submit the details")
                        }
                    }
                    // Transition to the homeScreen
                    self.performSegue(withIdentifier: Constants.StoryBoard.registerChat , sender: self)
                }
            }
        }
        
        
    }
    
    func errorMessage(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
//    func transitionHome() {
//        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as?
//        HomeViewController
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//    }

}
