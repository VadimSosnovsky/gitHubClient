//
//  ViewControllerFavRepo.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Firebase
import Kingfisher
import RealmSwift

class FavRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var position = 0
    
    private var selectedRepo: FavRepositoryData?
    private let viewModel = RepoViewModel()
    private var repos = [FavRepositoryData]()
    private var reposDetailed = DetailedRepository()
    private var reposData = [RepositoryData]()
    private var reposFull = [FullRepository]()
    private var links = [URL(string: "https://api.github.com/repositories")]
    
    let myRefreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        tableView.refreshControl = myRefreshControl
        viewModel.delegate = self
        configureTableView()
        viewModel.fetchDataFromDataBase()
        //tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("Обновляю willAppear")
        //tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? FullFavRepoViewController,
           let selectedRepo = selectedRepo {
            destVC.repo = selectedRepo.name ?? ""
            destVC.author = selectedRepo.login!
            destVC.image = selectedRepo.avatar!
            
            var info = ""
            var counter = 1
            info += "Last 10 commits \n\n"
            outofloop: for item in  reposFull {
                if(counter > 10) {
                    break outofloop
                }
                info += "№\(counter) \n"
                info += "date: \(item.commit?.committer?.date ?? "") \n"
                info += "message: \(item.commit?.message  ?? "")\n\n"
                counter += 1
            }
                
            destVC.info = info
                
            destVC.model = viewModel
            destVC.table = tableView
            destVC.data = selectedRepo
            destVC.repos = repos
            destVC.pos = position
            
        }
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
            
            print("Configure")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func btnAction(_ sender: UIButton) {

        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        
        selectedRepo = repos[indexPath.row]
        position = indexPath.row
        
        repos.remove(at: indexPath.row)
        viewModel.deleteReposFromDataBase(models: selectedRepo ?? FavRepositoryData())
        
        //viewModel.fetchDataFromDataBase()
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

        let url = URL(string: "https://api.github.com/repos/\(selectedRepo?.fullName ?? "")/commits")
        print(url ?? "")
        viewModel.getFullReposData(url: url!)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        tableView.reloadData()
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

extension FavRepoViewController: RepoViewModelDelegate {
    
    func dadaDidDeleteReposFromDataBase(data: FavRepositoryData) {
        //tableView.reloadData()
    }
    

    func dadaDidReceiveReposFromDataBase(data: [FavRepositoryData]) {
        self.repos = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
    }

    func dataDidRecieveReposData(data: [Repository]) {
//        DispatchQueue.main.async { [weak self] in
//            print("Данные загружены")
//            //self?.repos = data
//            //self?.viewModel.getAllinfo(data: self!.repos)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//                self?.tableView.reloadData()
//                self?.activityIndicator.stopAnimating()
//                self?.activityIndicator.isHidden = true
//            }
//        }
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
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.reposFull = data
            self?.performSegue(withIdentifier: "toDetailedFavRepo", sender: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
        print("stole the data!")
    }

    func error() {
        DispatchQueue.main.async { [weak self] in
            let a = self.hashValue
            print("Ошибка сети")
            print(a)
        }
    }
}
