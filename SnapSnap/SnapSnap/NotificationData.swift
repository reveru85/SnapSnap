//
//  NotificationData.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import Foundation

class NotificationData {
    class NotificationEntry {
        var title : String?
        var datetime : String?
        var user : String?
        var message : String?
    }
    
    var entries = [NotificationEntry]()
    
    init() {
        // Init fixed data
        var entry = NotificationEntry()
        entry.title = "Welcome to Gegder"
        entry.datetime = "30 May 2015, 00:00"
        entry.user = "Gegder Administrator"
        entry.message = "Welcome to Gegder from admin"
        
        entries.append(entry)
        
        var entry2 = NotificationEntry()
        entry2.title = "Announcement"
        entry2.datetime = "30 May 2015, 00:00"
        entry2.user = "Gegder Administrator"
        entry2.message = "We are working on Notification feature at this moment to provide a better notification for you!"
        
        entries.append(entry2)
    }
}