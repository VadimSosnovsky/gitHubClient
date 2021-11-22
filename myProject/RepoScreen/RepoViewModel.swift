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
    func dadaDidReceiveReposFromDataBase(data: [RepositoryData])
    func dadaDidDeleteReposFromDataBase(data: RepositoryData)
    func dataDidRecieveDetailedReposData(data: DetailedRepository)
    func dataDidRecieveAllReposData(data: [RepositoryData])
    func dataDidRecieveFullReposData(data: [FullRepository])
    func error()
}

class RepoViewModel {
    
    weak var delegate: RepoViewModelDelegate?
    

//    private let localRealm = try! Realm(configuration: Realm.Configuration.init(
//        fileURL: Realm.Configuration().fileURL!.deletingLastPathComponent().appendingPathComponent("\(User.userID).realm")))
    
    private let localRealm = try! Realm()
    
    func fetchDataFromDataBase() {
        let realmRepos = Array(localRealm.objects(RepositoryData.self))
        guard !realmRepos.isEmpty else {
            print("Empty")
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
            
            //self?.saveReposToDataBase(models: reposModels)
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
    
    func getFullReposData(url: URL) {
        
        var reposUrl = URLRequest(url: url)
        reposUrl.addValue("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", forHTTPHeaderField: "Authorization")
        reposUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        NetworkService.shared.getFullReposData(url: reposUrl) { [weak self] repos in
            guard let reposModels = repos else {
                self?.delegate?.error()
                return
            }
            
            self?.delegate?.dataDidRecieveFullReposData(data: reposModels)
        }
    }
    
    func saveReposToDataBase(models: RepositoryData) {
        
//        let localRealm = try! Realm(configuration: Realm.Configuration.init(
//            fileURL: Realm.Configuration().fileURL!.deletingLastPathComponent().appendingPathComponent("\(User.userID).realm")))
        
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
    
    func deleteReposFromDataBase(models: RepositoryData) {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.localRealm.write {
                    self?.localRealm.delete(models)
                }
            } catch {
                print("database error")
            }
            
            self?.delegate?.dadaDidDeleteReposFromDataBase(data: models)
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

            rep.id = repos[i].id
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
