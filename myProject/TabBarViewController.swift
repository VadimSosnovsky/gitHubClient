//
//  TabBarViewController.swift
//  myProject
//
//  Created by Вадим Сосновский on 04.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img"), style: .done, target: self, action: nil)

        // Для Tab bar
        self.tabBarController?.navigationItem.rightBarButtonItems = [rightBarButtonItem]
        // Do any additional setup after loading the view.
    }
}
