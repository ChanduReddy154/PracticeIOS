//
//  ForgotPassViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 15/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
    }
    
    func setUpFields() {
        errorLabel.alpha = 0
    }
    
    func validateEmail() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Enter email field"
        }
        let emailVal = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isValidEmail(emailVal) == false {
            return "Please enter valid email"
        }
        return nil
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let err = validateEmail()
        if err != nil {
            errorMessage(err!)
        }else {
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: email!) { error in
                if error != nil {
                    self.errorMessage("entered email is invalid")
                }else {
                    //self.errorMessage("The reset link is sent to your mail")
                    let alert = UIAlertController(title: "ResetPassword", message: "The reset link is sent to your mail", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                            alert.addAction(alertAction)
                            self.present(alert, animated: true)
                            
                }
            }
        }
        
    }
    
    func errorMessage(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
