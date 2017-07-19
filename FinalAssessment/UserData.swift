//
//  UserData.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


class UserData {
    
    var uid : String
    var name: String
    var userID: String
    var timeStamp: Date
    var email: String
    var profileImageURL : String?
    
    init?(snapshot: DataSnapshot){
        
        self.uid = snapshot.key
        
        guard
            let dictionary = snapshot.value as? [String: Any],
            let validUser = dictionary["userID"] as? String,
            let validTimestamp = dictionary["timestamp"] as? Double,
            let validName = dictionary["username"] as? String,
            let validEmail = dictionary["email"]as? String,
            let validProfileImage = dictionary["profileImageURL"]as? String
            
    
            else { return nil }
        
        self.userID = validUser
        self.timeStamp = Date(timeIntervalSince1970: validTimestamp)
        self.name = validName
        self.email = validEmail
        self.profileImageURL = validProfileImage
        
        }
    }
    

