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
    
    func getDetailedReposData(url: URL)  {
        
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
}
