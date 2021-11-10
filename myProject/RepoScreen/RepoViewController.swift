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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var selectedRepo: Repository?
    
    private let viewModel = RepoViewModel()
    
    private var repos = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        viewModel.delegate = self
        
        configureTableView()
        
        viewModel.getReposData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepoTableViewCell", bundle: .main), forCellReuseIdentifier: "myCell")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destVC = segue.destination as? DetailedRepoViewController,
//           let dog = selectedRepo {
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? RepoTableViewCell {
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

extension RepoViewController: RepoViewModelDelegate {
    
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
