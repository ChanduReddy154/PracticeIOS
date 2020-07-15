//
//  ChatViewController.swift
//  PracticeApplication
//
//  Created by Chandu Reddy on 08/07/20.
//  Copyright © 2020 Chandu Reddy. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputTextMessage: UITextField!
    var db = Firestore.firestore()
    
    var message: [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Reusable Identifier")
        loadMessges()
}
    func loadMessges() {
       
        db.collection("TextMessages").order(by: "Date").addSnapshotListener { (querySnapShot, error) in
            self.message = []
            if let er = error{
                print("error retrieving from db\(er)")
            }else {
                if let snapShot = querySnapShot?.documents {
                    for doc in snapShot {
                        let data = doc.data()
                        if let messageSender1 = data["sender"] as? String, let messageText1 = data["body"] as? String {
                            let newMessage = Messages(sender: messageSender1, body: messageText1)
                            self.message.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexpath1 = IndexPath(row: self.message.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexpath1, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if let messageText = inputTextMessage.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection("TextMessages").addDocument(data: ["sender": messageSender, "body": messageText, "Date": Date().timeIntervalSince1970]) { (err) in
                if let e = err {
                    print("Something went wrong\(e)")
                }else {
                    DispatchQueue.main.async {
                        self.inputTextMessage.text = ""
                    }
                }
            }
        }
        
    }
}
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = message[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable Identifier", for: indexPath) as! MessageCell
        cell.cellLabel.text = messageCell.body
        
        if messageCell.sender == Auth.auth().currentUser?.email {
            cell.anotherCellImage.isHidden = true
            cell.cellImage.isHidden = true
            cell.cellView.backgroundColor = UIColor(named: "Green")
        }else {
            cell.anotherCellImage.isHidden = true
            cell.cellImage.isHidden = true
            cell.cellView.backgroundColor = UIColor(named: "Pink")
        }
        return cell
    }
    
    
}
