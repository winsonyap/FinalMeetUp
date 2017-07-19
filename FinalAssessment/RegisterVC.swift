//
//  RegisterVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//
import UIKit
import FirebaseAuth
import Firebase

class RegisterVC: UIViewController,UITextFieldDelegate {
    
    static let storyboardIdentifier = "RegisterVC"
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!{
        didSet{
            userPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var doublePasswordComfrimation: UITextField!{
        didSet{
            doublePasswordComfrimation.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var selectPhotoButton: UIButton!{
        didSet{
            selectPhotoButton.addTarget(self, action: #selector(tapSelectProfileButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var comfrimRegisterButton: UIButton!{
        didSet{
            comfrimRegisterButton.addTarget(self, action: #selector(didTappedRegisterButton), for: .touchUpInside)
        }
    }
    //to select image as false
    var isImageSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupSpinner()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }
    
    func tapSelectProfileButton(_ sender : Any){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func didTappedRegisterButton(_ sender: Any){
        
        
        guard
            let username = usernameTextField.text,
            let email = userEmailTextField.text,
            let password = userPasswordTextField.text,
            let confirmPassword = doublePasswordComfrimation.text
            else { return }
        
        if username == "" {
            self.warningAlert(warningMessage: "Username Required")
            
            
        } else if email == "" {
            self.warningAlert(warningMessage: "Email Required")
            
            
        } else if password == "" {
            self.warningAlert(warningMessage: "Password Required")
            
        } else if password.characters.count < 6  {
            self.warningAlert(warningMessage: "At least 6 characters!")
            
            
        } else if password != confirmPassword {
            self.warningAlert(warningMessage: "Different passwords inserted!")
            
        } else if isImageSelected == false {
            self.warningAlert(warningMessage: "Profile Photo Required")
            
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let validError = error {
                    print(validError.localizedDescription)
                    self.warningAlert(warningMessage: "Same Email Exists!")
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let storageRef = Storage.storage().reference()
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                let data = UIImageJPEGRepresentation(self.userPhoto.image!, 0.8)
                
                storageRef.child("\(uid).jpg").putData(data!, metadata: metadata) { (newMeta, error) in
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
                        
                        let param : [String : Any] = ["username": username,
                                                      "email": email,
                                                      "profileImageURL": imageURL]
                        
                        let ref = Database.database().reference().child("users")
                        ref.child(uid).setValue(param)
                        
                    }
                }
                print("User sign-up successfully! \(user?.uid ?? "")")
                print("User email address! \(user?.email ?? "")")
                print("Username is \(username)")
                
                self.toHomeVC()
                
                
            })
        }
    }
    func toHomeVC()  {
        let loginStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = loginStoryboard.instantiateViewController(withIdentifier: "NavigationController2")
        
        self.present(homeVC, animated: true, completion: nil)
        
        
    }
    
    
    
    func warningAlert(warningMessage: String){
        let alertController = UIAlertController(title: "Error", message: warningMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
}

extension RegisterVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //cancel button in photo
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.userPhoto.image = selectedImage
        
        self.isImageSelected = true
        
        dismiss(animated: true, completion: nil)
        
        
    }
}

