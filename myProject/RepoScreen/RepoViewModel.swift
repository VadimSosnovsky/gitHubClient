//
//  AuthViewModel.swift
//  myProject
//
//  Created by Вадим Сосновский on 09.11.2021.
//

import Foundation
import RealmSwift

protocol RepoViewModelDelegate: AnyObject {
    func dataDidRecieveReposData(data: [Repository])
    func dadaDidReceiveReposFromDataBase(data: [Repository])
    func dataDidRecieveDetailedReposData(data: DetailedRepository)
    func dataDidRecieveAllReposData(data: [RepositoryData])
    func error()
}

class RepoViewModel {
    
    weak var delegate: RepoViewModelDelegate?
    
    private let localRealm = try! Realm()
    
    func fetchDataFromDataBase() {
        let realmRepos = Array(localRealm.objects(Repository.self))
        guard !realmRepos.isEmpty else {
            return
        }
        
        delegate?.dadaDidReceiveReposFromDataBase(data: realmRepos)
    }
    
    func getReposData(url: URL)  {
        var reposUrl = URLRequest(url: url)
        reposUrl.addValue("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", forHTTPHeaderField: "Authorization")
        reposUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        NetworkService.shared.getReposData(url: reposUrl) { [weak self] repos in
            guard let reposModels = repos else {
                self?.delegate?.error()
                return
            }
            
            self?.saveReposToDataBase(models: reposModels)
            self?.delegate?.dataDidRecieveReposData(data: reposModels)
        }
    }
    
    private var detailed = DetailedRepository()
    private var rp = [RepositoryData](repeating: RepositoryData(), count: 100)
    
    func getDetailedReposData(url: URL) {
        
        var reposUrl = URLRequest(url: url)
        reposUrl.addValue("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", forHTTPHeaderField: "Authorization")
        reposUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        NetworkService.shared.getDetailedReposData(url: reposUrl) { [weak self] repos in
            guard let reposModels = repos else {
                self?.delegate?.error()
                return
            }
            
            self?.delegate?.dataDidRecieveDetailedReposData(data: reposModels)
        }
    }
    
    private func saveReposToDataBase(models: [Repository]) {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.localRealm.write {
                    self?.localRealm.add(models, update: .modified)
                }
            } catch {
                print("database error")
            }
        }
    }
    
    func getAllinfo(data: [Repository]) {
        
        data.forEach { item in
            
            let url = URL(string: "https://api.github.com/repos/\(item.fullName ?? "")")
            getDetailedReposData(url: url!)
        }
    }
    
    func getAllDetailedInfo(repos: [Repository], detailedRepos: [DetailedRepository]) {
        
        var reposData = [RepositoryData]()
        
        var i = 0
        while i < repos.count {
            
            let rep = RepositoryData()

            rep.name = repos[i].name
            rep.fullName = repos[i].fullName
            rep.desc = repos[i].desc
            rep.login = repos[i].owner?.login
            rep.avatar = repos[i].owner?.avatar
            rep.language = detailedRepos[i].language
            rep.stargazers = detailedRepos[i].stargazers
            rep.forks = detailedRepos[i].forks
            reposData.append(rep)
            
            i += 1
        }
        
        self.delegate?.dataDidRecieveAllReposData(data: reposData)
    }
}
