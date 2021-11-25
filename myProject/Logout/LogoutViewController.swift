//
//  LogoutViewController.swift
//  myProject
//
//  Created by Вадим Сосновский on 26.11.2021.
//

import UIKit
import Lottie
import Firebase

class LogoutViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView.animation = Animation.named("door")
        animationView.play(completion: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
