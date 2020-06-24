//
//  Utilities.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 24/06/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import Foundation

class Utilities {
    
    static func isValidPassword(_ password : String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPhone(_ phone : String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

}

