//
//  ProfileVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileVC: UIViewController {

    static let storyboardIdentifier = "ProfileVC"
    //var userData:[UserData] = []
    var profileImg: [UserData] = []
    var currentUserID : String?
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!{
        didSet{
            logoutButton.target = self
            logoutButton.action = #selector(logoutButtonTapped)
        }
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!{
        didSet{
            editButton.target = self
            editButton.action = #selector(editButtonTapped)
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        initProfileView()
      //  editButton.isEnabled = false
    }

    func logoutButtonTapped()  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func editButtonTapped()  {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let editproVC = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileVC")
        self.navigationController?.pushViewController(editproVC, animated: true)
    }
    
    func fetchData()  {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            let username = dictionary["username"] as? String
            let email = dictionary["email"] as? String
            
            if let profileURL = dictionary["profileImageURL"] as? String {
                let displayUrl = NSURL(string : profileURL)
                self.profileImage.sd_setImage(with: displayUrl! as URL)
            }
            self.usernameLabel.text = username
            self.userEmailLabel.text = email
            self.profileImg = []
        })
    }
    
    func initProfileView() {
       
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
        UIDesign().setLabel(lable: usernameLabel)
        UIDesign().setLabel(lable: userEmailLabel)
    }

}

