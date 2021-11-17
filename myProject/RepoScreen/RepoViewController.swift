//
//  ViewControllerRepo.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Kingfisher

class RepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var selectedRepo: Repository?
    private let viewModel = RepoViewModel()
    private var repos = [Repository]()
    private var reposDetailed = [DetailedRepository]()
    private var reposData = [RepositoryData]()
    private var links = [URL(string: "https://api.github.com/repositories")]
    
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
        viewModel.getReposData(url: links[0]!)
        //viewModel.fetchDataFromDataBase()
        tableView.refreshControl = myRefreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: .main), forCellReuseIdentifier: "myCellRepo")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCellRepo", for: indexPath) as? RepoTableViewCell {
            
            cell.configure(name: reposData[indexPath.row].name ?? "",
                           desc: reposData[indexPath.row].desc ?? "",
                           language: reposData[indexPath.row].language ?? "",
                           forks: "\(reposData[indexPath.row].forks ?? 0)" ,
                           stars: "\(reposData[indexPath.row].stargazers ?? 0)",
                           author: reposData[indexPath.row].login ?? "")
            

            KF.url(URL(string: "\(reposData[indexPath.row].avatar ?? "")"))
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
        return reposData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRepo = repos[indexPath.row]
        
        performSegue(withIdentifier: "toDetailedRepo", sender: self)
    }
}

extension RepoViewController: RepoViewModelDelegate {
    
    func dadaDidReceiveReposFromDataBase(data: [Repository]) {
        self.repos = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func dataDidRecieveReposData(data: [Repository]) {
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.repos = data
            self?.viewModel.getAllinfo(data: self!.repos)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    func dataDidRecieveDetailedReposData(data: DetailedRepository) {
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.reposDetailed.append(data)
            if(self?.reposDetailed.count == self?.repos.count) {
                self?.viewModel.getAllDetailedInfo(repos: self?.repos ?? [Repository](), detailedRepos: self?.reposDetailed ?? [DetailedRepository]())            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    func dataDidRecieveAllReposData(data: [RepositoryData]) {
        reposData = data
    }
    
    
    func error() {
        DispatchQueue.main.async { [weak self] in
            let a = self.hashValue
            print("Ошибка сети")
            print(a)
        }
    }
}
