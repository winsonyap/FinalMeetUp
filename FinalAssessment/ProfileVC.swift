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
import CoreLocation
import MapKit

class ProfileVC: UIViewController,CLLocationManagerDelegate {
    
    static let storyboardIdentifier = "ProfileVC"
    
    var currentUserID : String?
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        //live location
        self.mapView.showsUserLocation = true
    }
    
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
        mapFunc()
    }
    
    func mapFunc()  {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
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
        })
    }
    
    func initProfileView() {
        
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
        UIDesign().setLabel(lable: usernameLabel)
        UIDesign().setLabel(lable: userEmailLabel)
    }
}

