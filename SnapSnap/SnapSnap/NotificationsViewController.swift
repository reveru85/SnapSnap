//
//  NotificationsViewController.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var NotificationsTableView: UITableView!
    let postCellId = "NotificationsCell"
    let data = NotificationData()
    
    class NotificationsEntry {
        var title : String?
        var datetime : String?
        var user : String?
        var message : String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationsTableView.delegate = self
        NotificationsTableView.dataSource = self
        NotificationsTableView.estimatedRowHeight = 44
        NotificationsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(postCellId, forIndexPath: indexPath) as! NotificationsTableViewCell
        
        // Prevent layout constraints error
        cell.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
        
        // Initialise an instance of PostData class using the current row
        let post = data.entries[indexPath.row]

        cell.Title.text = post.title
        cell.DateTime.text = post.datetime
        cell.entry = post

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    // Prepare for segue transitions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ShowNotification") {

            var vc = segue.destinationViewController as! SingleNotificationViewController
            vc.entry = (sender as! NotificationsTableViewCell).entry
            
        }
    }

}

