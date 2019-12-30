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
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
    
}
