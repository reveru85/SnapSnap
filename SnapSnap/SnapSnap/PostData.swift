//
//  PostData.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import Foundation

class PostData {
    class PostEntry {
//        var title : String?
        var username : String?
//        var location : String?
        var media_url : String?
        var created_datetime : String?
        var hash_tag : String?
        var description : String?
        var total_comments : String?
        var total_likes : String?
        var is_like : Bool
        var post_id : String?
        var display_order : String?
        
        init() {
            is_like = false
        }
    }
    
    var entries = [PostEntry]()
    
    init() {
        let entry = PostEntry()
        entries.append(entry)
    }
    
    func clearEntries() {
        entries.removeAll(keepCapacity: false)
    }
    
    func addEntriesFromJSON(data: JSON) {
        
        for (index: _, post: JSON) in data {
            
            let entry = PostEntry()
//            entry.title = post["title"].string!
            entry.username = JSON["username"].string!
//            entry.location = post["location"].string!
            entry.media_url = JSON["app_link_url"].string!
            entry.created_datetime = JSON["created_datetime"].string!
            
            let dateString = JSON["created_datetime"].string!
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 28800)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.dateFromString(dateString) {
                // Format into desired format
                dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
                entry.created_datetime = dateFormatter.stringFromDate(date)
                
            } else {
                entry.created_datetime = dateString
            }
            
            entry.hash_tag = JSON["hash_tag"].string!
            entry.description = JSON["description"].string!
            entry.total_comments = JSON["total_comments"].string!
            entry.total_likes = JSON["total_likes"].string!
            entry.is_like = JSON["is_like"].bool!
            entry.post_id = JSON["id"].string!
            entry.display_order = JSON["display_order"].string!
            
            entries.append(entry)
        }
    }
    
    func addEntriesToFrontFromJSON(data: JSON) {
        
        let oldEntries = entries
        var newEntries = [PostEntry]()
        
        for (index: _, post: JSON) in data {
            
            let entry = PostEntry()
//            entry.title = post["title"].string!
            entry.username = JSON["username"].string!
//            entry.location = post["location"].string!
            entry.media_url = JSON["app_link_url"].string!
            entry.created_datetime = JSON["created_datetime"].string!
            entry.hash_tag = JSON["hash_tag"].string!
            entry.description = JSON["description"].string!
            entry.total_comments = JSON["total_comments"].string!
            entry.total_likes = JSON["total_likes"].string!
            entry.is_like = JSON["is_like"].bool!
            entry.post_id = JSON["id"].string!
            entry.display_order = JSON["display_order"].string!
            
            newEntries.append(entry)
        }
        
        entries = newEntries + oldEntries
    }
    
    func removeEntry(postId: String) {
        
        for (index, entry) in entries.enumerate() {
            
            if entry.post_id == postId {
                
                entries.removeAtIndex(index)
                break
            }
        }
    }
    
    func findEntry(postId: String) -> PostEntry! {
        
        for entry in entries {
            if entry.post_id == postId {
                return entry
            }
        }
        
        return nil
    }
    
    func likePost(postId: String) {
        for entry in entries {
            if entry.post_id == postId {
                
                entry.is_like = true
                var likesInt = Int(entry.total_likes!)
                likesInt!++
                entry.total_likes = String(likesInt!)
            }
        }
    }
    
    func incrementComment(postId: String) {
        for entry in entries {
            if entry.post_id == postId {
                
                var commentsInt = Int(entry.total_comments!)
                commentsInt!++
                entry.total_comments = String(commentsInt!)
            }
        }
    }
}