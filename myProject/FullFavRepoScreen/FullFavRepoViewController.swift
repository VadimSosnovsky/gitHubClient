//
//  FullFavRepoViewController.swift
//  myProject
//
//  Created by Вадим Сосновский on 23.11.2021.
//

import UIKit
import Kingfisher

class FullFavRepoViewController: UIViewController {

//    @IBOutlet private weak var repoName: UILabel!
//    @IBOutlet private weak var authorName: UILabel!
//    @IBOutlet private weak var authorImage: UIImageView!
//    @IBOutlet private weak var commitInfo: UILabel!
    
    @IBOutlet private weak var repoName: UILabel!
    @IBOutlet private weak var authorName: UILabel!
    @IBOutlet private weak var authorImage: UIImageView!
    @IBOutlet private weak var commitInfo: UILabel!
    
    var repo = ""
    var author = ""
    var image = ""
    var info = ""
    
    var table = UITableView()
    var model = RepoViewModel()
    var data = FavRepositoryData()
    var repos = [FavRepositoryData]()
    var pos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.repoName.text = repo
        self.authorName.text = author
        self.commitInfo.text = info
        
        KF.url(URL(string: "\(image)"))
                    .set(to: self.authorImage)
    }
    
    @IBAction func deleteButton(_ sender: Any) {

        repos.remove(at: pos)
        //model.deleteReposFromDataBase(models: data)

        //viewModel.fetchDataFromDataBase()
        table.reloadData()
    }
}
