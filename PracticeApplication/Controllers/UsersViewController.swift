//
//  UsersViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 14/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController {
    
    @IBOutlet weak var usersTable: UITableView!
    
    var db = Firestore.firestore()
    var name: [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        usersTable.delegate = self
        usersTable.dataSource = self
        loadUsers()
    }
    func loadUsers() {
        name = []
        db.collection("users").getDocuments { (query, error) in
            if let e = error {
                print("error occured\(e)")
            }else {
                if let querySnap = query?.documents {
                    for doc in querySnap {
                        let usersData = doc.data()
                        if let userID = usersData["uid"] as? String,  let userName = usersData["fullName"] as? String  {
                            let newUser = Users(userId: userID, fullName: userName)
                            self.name.append(newUser)
                            DispatchQueue.main.async {
                                self.usersTable.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }

}
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = usersTable.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)
        userCell.textLabel?.text = name[indexPath.row].fullName
        return userCell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.StoryBoard.chatView, sender: self)
    }
}


