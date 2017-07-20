//
//  UploadPostVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import Firebase

class UploadPostVC: UIViewController {
    
    static let storyboardIdentifier = "UploadPostVC"
    //add activityIndicator
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var isImageSelected : Bool = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!{
        didSet{
            addImageButton.addTarget(self, action: #selector(tapAddImageButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!{
        didSet{
            uploadButton.addTarget(self, action: #selector(uploadDataButtonTapped), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUploadView()
        
        self.navigationItem.title = "Creates New Event"
    }
    
    func uploadDataButtonTapped()  {
        //create upload details to firebase
        guard
            let title = titleTextField.text,
            let description = descriptionTextField.text,
            let time = timeTextField.text,
            let location = locationTextField.text,
            let category = categoryTextField.text
            else {return}
        
        if title == "" {
            self.warningAlert(warningMessage: "Title Required")
            
            
        } else if description == "" {
            self.warningAlert(warningMessage: "Description Required")
            
            
        } else if time == "" {
            self.warningAlert(warningMessage: "Time Required")
            
        } else if location == "" {
            self.warningAlert(warningMessage: "Location Required")
            
            
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
                let param : [String : Any] = ["title" : title,"description" : description,"time" : time, "location" : location,"category" : category, "imageURL" : imageURL, "userID" : uid, "timestamp": now.timeIntervalSince1970]
        
        let ref = Database.database().reference().child("posts")
            ref.childByAutoId().setValue(param)
        
        self.setupSpinner()
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
    
    func setupSpinner(){
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        view.addSubview(myActivityIndicator)
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
