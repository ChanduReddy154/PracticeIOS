//
//  LoginViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 23/06/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setElements()
    }
    func setElements() {
        // hide the error label
        errorLabel.alpha = 0
    }
    
    // validate the fields
    func validatingFields() -> String? {
        // validating the email and password fields
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Enter email and password"
            }
        // checking the email validation
        let emailVal = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               if Utilities.isValidEmail(emailVal) == false {
                   return "Please enter valid email"
               }
        // check the password validation
        let passVal = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               if Utilities.isValidPassword(passVal) == false {
                   return "password must be atleast 6 characters with alteast 1 numeric, 1 capital and 1 special character"
        }
        return nil
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
       let error = validatingFields()
        if error != nil {
            errorMessage(error!)
        } else {
            // reference to the fields
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // signing in the User
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.errorMessage("email or password are incorrect")
                }else {
                    self.performSegue(withIdentifier: Constants.StoryBoard.loginChat, sender: self)
                }
                
            }
        }
        
        }
    func errorMessage(_ message : String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
//    func transitionHomeController() {
//        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as?
//        HomeViewController
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//    }
}
