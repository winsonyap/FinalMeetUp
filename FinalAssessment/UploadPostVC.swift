//
//  UploadPostVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class UploadPostVC: UIViewController,CLLocationManagerDelegate {
    
    static let storyboardIdentifier = "UploadPostVC"
    
    var isImageSelected : Bool = false
    var getLat: Double?
    var getLong: Double?
    
    let pinView = MKPointAnnotation()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!{
        didSet{
            addImageButton.addTarget(self, action: #selector(tapAddImageButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!{
        didSet{
            uploadButton.addTarget(self, action: #selector(uploadDataButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //[0] = current location
        let location = locations[0]
        //span-zoom
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        pinView.coordinate = myLocation
        pinView.title = "I M Here!"
        
        //set double? 
        getLat = myLocation.latitude
        getLong = myLocation.longitude
        
        mapView.addAnnotation(pinView)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapFunc()
        initUploadView()
        keyboardAddObserver()
        self.navigationItem.title = "Creates Live Event"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardAddObserver()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -210 // Move view 210 points upward
    }
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    func mapFunc()  {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func uploadDataButtonTapped()  {
        //create upload details to firebase
        guard
            let title = titleTextField.text,
            let description = descriptionTextField.text,
            let time = timeTextField.text,
            let category = categoryTextField.text
            
            else {return}
        
        if title == "" {
            self.warningAlert(warningMessage: "Title Required")
            
            
        } else if description == "" {
            self.warningAlert(warningMessage: "Description Required")
            
            
        } else if time == "" {
            self.warningAlert(warningMessage: "Time Required")
            
        } else if category == "" {
            self.warningAlert(warningMessage: "Category Required")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Event Image Required, Click on ( + ) to insert image®")
            
        } else {
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let storageRef = Storage.storage().reference()
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            guard let data = UIImageJPEGRepresentation(imageView.image!, 0.8) else {
                
                dismiss(animated: true, completion: nil)
                return
            }
            
            storageRef.child("\(uid).jpg").putData(data, metadata: metadata) { (newMeta, error) in
                if (error != nil) {
                    
                    print(error!)
                } else {
                    
                    if let foundError = error {
                        print(foundError.localizedDescription)
                        return
                    }
                    
                    guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                        return
                    }
                    
                    let now = Date()
                    let param : [String : Any] = ["title" : title,"description" : description,"time" : time, "category" : category, "imageURL" : imageURL, "userID" : uid, "timestamp": now.timeIntervalSince1970, "Lat": self.getLat ?? "", "Long": self.getLong ?? ""]
                    
                    let ref = Database.database().reference().child("posts")
                    ref.childByAutoId().setValue(param)
                    
                    self.presentPostVC()
                }
            }
        }
    }
    
    func presentPostVC() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let postVC = mainStoryboard.instantiateViewController(withIdentifier: "TadBarController")
        
        self.present(postVC, animated: true, completion: nil)
    }
    
    func tapAddImageButton()  {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func initUploadView() {
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
        UIDesign().setButtonDesign(button: uploadButton, color: UIColor.red)
        UIDesign().setButtonDesign(button: addImageButton, color: UIColor.red)
    }
}

extension UploadPostVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //cancel button in photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
        self.isImageSelected = true
        
        dismiss(animated: true, completion: nil)
    }
}
