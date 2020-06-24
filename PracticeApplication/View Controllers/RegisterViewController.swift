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
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
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
            phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill the the fields"
        }
        // check the password validation
        let passVal = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidPassword(passVal) == false {
            return "password must be atleast 6 characters with alteast 1 numeric, 1 capital and 1 special character"
        }
        // check the email validation
        let emailVal = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(emailVal) == false {
            return "email must be valid"
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
            let phoneNum = phoneNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // create a User
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                // check there is an any error
                if err != nil {
                    self.errorMessage("error while creating the user")
                }else {
                    // the user created successfully
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["fullName":fullName, "phoneNumber":phoneNum, "uid": result!.user.uid]) { (er) in
                        if er != nil {
                            self.errorMessage("please enter the data again and submit the details")
                        }
                    }
                    // Transition to the homeScreen
                    self.transitionHome()
                }
            }
        }
        
        
    }
    
    func errorMessage(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 3
    }
    func transitionHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as?
        HomePageViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
