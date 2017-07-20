//
//  EditProfileVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 18/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EditProfileVC: UIViewController, UITextFieldDelegate{
    
    static let storyboardIdentifier = "EditProfileVC"
    
    var isImageSelected : Bool = false
    var getUsername : String?
    var getEmail : String?
    var getProfileImage : UIImage?
    
    @IBOutlet weak var updateImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!{
        didSet{
            addImageButton.addTarget(self, action: #selector(didTappedAddImageButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var usernameUpdate: UITextField!{
        didSet{
            usernameUpdate.delegate = self
        }
    }
    @IBOutlet weak var updateButton: UIButton!{
        didSet{
            updateButton.addTarget(self, action: #selector(didTappedUploadButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameUpdate.text = getUsername
        self.updateImageView.image = getProfileImage

        initEditView()
        self.navigationItem.title = "Update Profile"
    }
    
    func didTappedAddImageButton (_ sender: Any){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    func didTappedUploadButton(_ sender : Any){
        
        guard
            let uid = Auth.auth().currentUser?.uid,
            let changeUsername = self.usernameUpdate.text
        
            else {return}
        
        if changeUsername == "" {
            self.warningAlert(warningMessage: "Username Required")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Profile Photo Required")
    
        } else {
            
        
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let data = UIImageJPEGRepresentation(self.updateImageView.image!, 0.8)
        
        storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
            if (error != nil) {
                // if error
                print(error!)
            } else {
                
                if let foundError = error {
                    print(foundError.localizedDescription)
                    return
                }
                
                guard let imageURL = newMeta?.downloadURLs?.first?.absoluteString else {
                    return
                }
                
                let param : [String : Any] = ["profileImageURL": imageURL,
                                              "username": changeUsername]
                
                let ref = Database.database().reference().child("users")
                ref.child(uid).updateChildValues(param)
            }}
        }
        self.toProfileVC()
    }
    
    func toProfileVC()  {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "TadBarController")
        self.present(mainVC, animated: true, completion: nil)
    }

    
    func initEditView() {
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.cyan, secondColor: UIColor.red)
         UIDesign().setButtonDesign(button: addImageButton, color: UIColor.red)
         UIDesign().setButtonDesign(button: updateButton, color: UIColor.red)
    }
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //cancel button in photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.updateImageView.image = selectedImage
        self.isImageSelected = true
        //isImageSelect
        dismiss(animated: true, completion: nil)
    }
}

