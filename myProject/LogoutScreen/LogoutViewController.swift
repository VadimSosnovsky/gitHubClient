//
//  LogoutViewController.swift
//  myProject
//
//  Created by Вадим Сосновский on 05.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
