//
//  HomeViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 08/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func chaqtButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.StoryBoard.usersView, sender: self)
    }
    
  
    @IBAction func logoutButton(_ sender: UIButton) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
}
