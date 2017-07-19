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
        
    }
    
}
