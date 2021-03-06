//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "one@two.com", body: "Hey!"),
        Message(sender: "three@four.com", body: "Hello!"),
        Message(sender: "one@two.com", body: "What's up!"),
        Message(sender: "one@two.com", body: K.longAssString)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the ChatViewController instance as the data source of the table view
        tableView.dataSource = self
        
        // Hide the back button on this screen
        navigationItem.hidesBackButton = true
        
        // Add a title to this screen
        title = K.appName
        
        // Register the message cell xib to the table view
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e.localizedDescription)")
            }
            else {
                print("Successfully retrieving data!")
                
                self.messages = []
                
                if let snapshotDocuments = querySnapshot?.documents {
                    for ssDoc in snapshotDocuments {
                        
                        let data = ssDoc.data()
                        
                        // Conditionally down cast as String using as?
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as?  String {
                            
                            // Create a Message object and add it to the messages array
                            self.messages.append(Message(sender: sender, body: messageBody))
                        }
                    }
                    
                    // Trigger a reload of data from data source
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore: \(e.localizedDescription)")
                }
                else {
                    print("Successfully save data!")
                }
            }
        }
    }
        
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This number controls how many rows the table view has
        return messages.count
    }
    
    // This function asks for a cell to display in each row of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        // If the message's sender is the current user, then show the right image view
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}
