//
//  SingleNotificationViewController.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import UIKit

class SingleNotificationViewController: UIViewController {
    
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var UserLabel: UILabel!
    var entry : NotificationData.NotificationEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = entry.title
        MessageLabel.text = entry.message
        UserLabel.text = entry.user
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}