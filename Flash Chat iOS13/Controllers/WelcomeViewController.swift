//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        let titleText = "⚡️FlashChat"
        
        // You can't subscript a string, so work around it by converting it to an array
        let titleCharArray = Array(titleText)
        
        // As each timer starts at the same time, subsequent timers need to wait longer to fire off
        for index in 0..<titleCharArray.count {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { (timer) in
                self.titleLabel.text?.append(titleCharArray[index])
            }
        }
    }
    
    
}
