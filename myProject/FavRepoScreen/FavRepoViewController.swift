//
//  ViewControllerFavRepo.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Kingfisher

class FavRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var selectedRepo: Repository?
    private let viewModel = RepoViewModel()
    private var repos = [Repository]()
    
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        viewModel.delegate = self
        configureTableView()
        viewModel.getReposData()
        tableView.refreshControl = myRefreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavRepoTableViewCell", bundle: .main), forCellReuseIdentifier: "myCellFavRepo")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCellFavRepo", for: indexPath) as? FavRepoTableViewCell {
            cell.configure(name: repos[indexPath.row].name ?? "",
                           desc: repos[indexPath.row].description ?? "",
                           language: repos[indexPath.row].languages ?? "",
                           forks: repos[indexPath.row].forks ?? "",
                           stars: repos[indexPath.row].stargazers ?? "",
                           author: repos[indexPath.row].owner.login ?? "")
            
            KF.url(repos[indexPath.row].owner.avatar)
                .set(to: cell.profilePicture)
            
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRepo = repos[indexPath.row]
        
        performSegue(withIdentifier: "toDetailedRepo", sender: self)
    }
}

extension FavRepoViewController: RepoViewModelDelegate {
    
    func dataDidRecieveReposData(data: [Repository]) {
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.repos = data
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    func error() {
        DispatchQueue.main.async { [weak self] in
            let a = self.hashValue
            print("Ошибка сети")
            print(a)
        }
    }
}
