//
//  AppDelegate.swift
//  FinalAssessment
//
//  Created by Winson Yap on 17/07/2017.
//  Copyright © 2017 Winson Yap. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()
        //firebase configuration
        
        
        handleUser(Auth.auth().currentUser)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.handleUser(user)
        }
        return true
    }
    //to make sure keep user login
    func handleUser(_ user : User?){
        if user != nil {
            self.displayMainScreen()
            return;
        } else {
            self.displayLoginScreen()
        }
    }
    
    func displayLoginScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    func displayMainScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "TadBarController")
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
}

