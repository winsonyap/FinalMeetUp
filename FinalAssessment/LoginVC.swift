//
//  LoginVC.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class LoginVC: UIViewController {
    
    
    @IBOutlet weak var LoginLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet {
            emailTextField.addTarget(self, action: #selector(textFieldChanges), for: .editingChanged)
            
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        
        didSet{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.addTarget(self, action: #selector(textFieldChanges), for: .editingChanged)
            
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        
        didSet{
            loginButton.addTarget(self, action: #selector(whenLoginButtonTapped(_:)), for: .touchUpInside)
            
        }
        
    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.addTarget(self, action: #selector(whenRegisterButtonTapped(_:)), for: .touchUpInside)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLoginView()
    }
    
    func whenRegisterButtonTapped(_ sender:Any)  {
        
        let mainStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        let registerVC = mainStoryboard.instantiateViewController(withIdentifier: "RegisterVC")
        
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    //pop out an alert controller
    func warningAlert(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let getItButton = UIAlertAction(title: "Get it!", style: .cancel, handler: nil)
        popUP.addAction(getItButton)
        present(popUP, animated: true, completion: nil)
    }
    
    
    func textFieldChanges(textField : UITextField)   {
        // for password and email if the textfields r empty then disable login button else enable
        //2.login disable in viewDid, so if textField is filled, enable login
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginButton.isEnabled = true
        }else{
            loginButton.isEnabled = false
        }
    }
    
    func initLoginView() {
        // design login view optional
        UIDesign().setGradientBackgroundColor(view: self.view, firstColor: UIColor.blue, secondColor: UIColor.blue)
        
        UIDesign().setLoginLabel(lable: LoginLabel)
        UIDesign().setButtonDesign(button: loginButton, color: UIColor.purple)
        UIDesign().setButtonDesign(button: registerButton, color: UIColor.purple)
        //to disable button when no input
        //1. set it in viewDidLoad to disable login
        loginButton.isEnabled = false
    }
    
    func whenLoginButtonTapped(_ sender:Any)  {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else{
                
                return
        }
        Auth.auth().signIn(withEmail : email, password : password ) {(user, error) in
            
            if let validError = error {
                
                print("login error\(validError)")
                
                self.warningAlert(withTitle: "Login Error", withMessage: "Email and Password not match")
                
                return
            }
            
            print(" User Exist \(user?.uid ?? "")")
            
            let mainStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
            let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController2")
            
            self.present(mainViewController, animated: true, completion: nil)
            
        }
    }
    
}
