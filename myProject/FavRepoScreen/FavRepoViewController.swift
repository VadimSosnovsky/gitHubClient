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
    
    
    private var selectedRepo: RepositoryData?
    private let viewModel = RepoViewModel()
    private var repos = [RepositoryData]()
    private var reposDetailed = DetailedRepository()
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
        viewModel.fetchDataFromDataBase()
        tableView.reloadData()
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        viewModel.delegate = self
        configureTableView()
        viewModel.fetchDataFromDataBase()
        tableView.reloadData()
        tableView.refreshControl = myRefreshControl
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.fetchDataFromDataBase()
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
                           desc: repos[indexPath.row].desc ?? "",
                           language: repos[indexPath.row].language ?? "",
                           forks: "\(repos[indexPath.row].forks ?? 0)" ,
                           stars: "\(repos[indexPath.row].stargazers ?? 0)",
                           author: repos[indexPath.row].login ?? "")
            

            KF.url(URL(string: "\(repos[indexPath.row].avatar ?? "")"))
                .set(to: cell.profilePicture)
            
            cell.deleteButton.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func btnAction(_ sender: UIButton) {

        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        
        selectedRepo = repos[indexPath.row]
        
        viewModel.deleteReposFromDataBase(models: selectedRepo ?? RepositoryData())
        tableView.reloadData()
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
    
    func dadaDidDeleteReposFromDataBase(data: RepositoryData) {
        //tableView.reloadData()
    }
    

    func dadaDidReceiveReposFromDataBase(data: [RepositoryData]) {
        self.repos = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
    }

    func dataDidRecieveReposData(data: [Repository]) {
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            //self?.repos = data
            //self?.viewModel.getAllinfo(data: self!.repos)

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
            self?.reposDetailed = data

            //self?.viewModel.getDetailedReposData(data: self!.repos)

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

    func dataDidRecieveFullReposData(data: [FullRepository]) {

    }

    func error() {
        DispatchQueue.main.async { [weak self] in
            let a = self.hashValue
            print("Ошибка сети")
            print(a)
        }
    }
}
