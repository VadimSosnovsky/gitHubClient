//
//  FullRepoViewController.swift
//  myProject
//
//  Created by Вадим Сосновский on 18.11.2021.
//

import UIKit
import Kingfisher

class FullRepoViewController: UIViewController {
    
    @IBOutlet private weak var repoName: UILabel!
    @IBOutlet private weak var authorName: UILabel!
    @IBOutlet private weak var authorImage: UIImageView!
    @IBOutlet private weak var commitInfo: UILabel!
    
    var repo = ""
    var author = ""
    var image = ""
    var info = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repoName.text = repo
        self.authorName.text = author
        self.commitInfo.text = info
        
        KF.url(URL(string: "\(image)"))
                    .set(to: self.authorImage)
    }
}
