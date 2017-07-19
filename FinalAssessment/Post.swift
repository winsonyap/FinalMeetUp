//
//  Post.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SDWebImage

class Post {
    var pid : String
    var title : String
    var userID: String?
    var description: String?
    var time : String?
    var location : String?
    var category : String?
    var imageURL : URL?
    var timeStamp: Date
    
    init?(snapshot: DataSnapshot){
        self.pid = snapshot.key
        
        guard
            let dictionary = snapshot.value as? [String: Any],
        let validUser = dictionary["userID"]as? String,
        let validTitle = dictionary["title"] as? String,
        let validDescription = dictionary["description"] as? String,
        let validLocation = dictionary["location"] as? String,
        let validCategory = dictionary["category"] as? String,
        let validTimestamp = dictionary["timestamp"] as? Double,
        let validTime = dictionary["time"] as? String
        else {return nil}
    
        self.userID = validUser
        self.title = validTitle
        self.description = validDescription
        self.location = validLocation
        self.category = validCategory
        self.timeStamp = Date(timeIntervalSince1970: validTimestamp)
        self.time = validTime
      

        if let validImageURL = dictionary["imageURL"] as? String{
            self.imageURL = URL(string: validImageURL)
        }
        
    }
}
