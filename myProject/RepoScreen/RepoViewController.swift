//
//  ViewControllerRepo.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Kingfisher
import Firebase

class RepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var selectedRepo: RepositoryData?
    private let viewModel = RepoViewModel()
    private var repos = [Repository]()
    private var reposDetailed = [DetailedRepository]()
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
        viewModel.delegate = self
        configureTableView()
        viewModel.getReposData(url: links[0]!)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? FullRepoViewController,
           let selectedRepo = selectedRepo {
            destVC.repo = selectedRepo.name ?? ""
            destVC.author = selectedRepo.login!
            destVC.image = selectedRepo.avatar!
            
            var info = ""
            var counter = 1
            
            outofloop: for item in  reposFull {
                if(counter > 10) {
                    break outofloop
                }
                info += "\(counter) \n"
                info += "\(item.commit?.committer?.date ?? "") \n"
                info += "\(item.commit?.message  ?? "")\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                counter += 1
            }
                
                destVC.info = info
        }
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
           
            cell.addButton.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
//            cell.addButton.tintColor = .clear
//            cell.addButton.backgroundColor = .clear
//            let imgAfter: UIImage = UIImage(named: "filled_star")!
//            cell.addButton.setImage(imgAfter, for: .normal)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func btnAction(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView as UIView)
        let indexPath: IndexPath! = tableView.indexPathForRow(at: point)
        
        selectedRepo = reposData[indexPath.row]
        print(selectedRepo?.fullName ?? "Unknown")
        
        print("row is = \(indexPath.row) && section is = \(indexPath.section)")
        
        viewModel.saveReposToDataBase(models: selectedRepo ?? RepositoryData())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRepo = reposData[indexPath.row]
        
        let url = URL(string: "https://api.github.com/repos/\(selectedRepo?.fullName ?? "")/commits")
        print(url ?? "")
        viewModel.getFullReposData(url: url!)
        
        //performSegue(withIdentifier: "toDetailedRepo", sender: self)
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

extension RepoViewController: RepoViewModelDelegate {
    
    
    func dadaDidDeleteReposFromDataBase(data: RepositoryData) {
        
    }
    
    
    func dadaDidReceiveReposFromDataBase(data: [RepositoryData]) {
        //self.repos = data
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func dataDidRecieveReposData(data: [Repository]) {
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.repos = data
//            User.i = 0
//            self?.viewModel.getAllinfo(data: self!.repos, i: User.i)
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
//            else {
//                User.i += 1
//                self?.viewModel.getAllinfo(data: self!.repos, i: User.i)
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    func dataDidRecieveAllReposData(data: [RepositoryData]) {
        
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.reposData = data
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    func dataDidRecieveFullReposData(data: [FullRepository]) {
        
        DispatchQueue.main.async { [weak self] in
            print("Данные загружены")
            self?.reposFull = data
            self?.performSegue(withIdentifier: "toDetailedRepo", sender: self)
            
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
