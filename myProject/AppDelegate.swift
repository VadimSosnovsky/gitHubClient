//
//  AppDelegate.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user == nil {
                self.showModalAuth()
            }
        }
        
        return true
    }
    
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        self.window?.rootViewController?.present(newVC, animated: true, completion: nil)
    }
}

