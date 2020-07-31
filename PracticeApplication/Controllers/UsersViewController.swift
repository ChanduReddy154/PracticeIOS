//
//  UsersViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 14/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase


class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var userid = ""
    //var usersData = [Users]()
    //var rawuserData = [RawUserData]()
    
    
    @IBOutlet weak var usersTable: UITableView!
    
    let currentUser = Auth.auth().currentUser
    var db = Firestore.firestore()
    var name = [Users]()
    
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
                        if var userID = usersData["uid"] as? String,  let userName = usersData["fullName"] as? String  {
                            let newUser = Users(userId: userID, fullName: userName)
                            self.name.append(newUser)
                            userID = self.userid
                            DispatchQueue.main.async {
                                self.usersTable.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }
//    // reference to the video when tapped
//                  let selectedVideo = youVideos[tableView.indexPathForSelectedRow!.row]
//
//                  //get a reference to the video view controller
//                  let videosVC = segue.destination as! VideosViewController
//
//                   //set the video property of the videoviewcontroller
//                   videosVC.videoPlay = selectedVideo
    
//    let destination = segue.destination as! ListTableViewController
//    if let indexpath = tableView.indexPathForSelectedRow {
//        destination.selectedCategory = categoryArray[indexpath.row]
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //userId = rawuserData[indexPath.row].uid
        tableView.deselectRow(at: indexPath, animated: true)
       performSegue(withIdentifier: Constants.StoryBoard.chatView, sender: self)
        
    }
     override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let vc = segue.destination as! ChatViewController
        if let selectedCell = usersTable.indexPathForSelectedRow {
            vc.messageReciever = name[selectedCell.row]
            //vc.messageReciever = [selectedCell.row]
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return name.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let userCell = usersTable.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)
           userCell.textLabel?.text = name[indexPath.row].fullName
           return userCell
       }

}

