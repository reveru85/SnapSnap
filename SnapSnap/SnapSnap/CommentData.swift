//
//  CommentData.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import Foundation

class CommentData {
    class CommentEntry {
        var name : String?
        var datetime : String?
        var comment : String?
        var commentId : String?
        var status : String?
        var postId: String?
        var userId: String?
    }
    
    var entries = [CommentEntry]()
    
    func clearEntries() {
        entries.removeAll(keepCapacity: false)
    }
    
    func addEntriesFromJSON(data: JSON) {
        
        for (index: _, post: JSON) in data {
            
            let entry = CommentEntry()
            entry.commentId = JSON["id"].string!
            entry.userId = JSON["user_id"].string!
            entry.postId = JSON["dphodto_id"].string!
            entry.comment = JSON["comment"].string!
            entry.status = JSON["status"].string!
            entry.datetime = JSON["created_datetime"].string!
            entry.name = JSON["username"].string!
            
            entries.append(entry)
        }
    }
    
    func removeEntry(commentId: String) {
        
        for (index, entry) in entries.enumerate() {
            
            if entry.commentId == commentId {
                
                entries.removeAtIndex(index)
                break
            }
        }
    }
}