//
//  AuthViewModel.swift
//  myProject
//
//  Created by Вадим Сосновский on 09.11.2021.
//

import Foundation

protocol RepoViewModelDelegate: AnyObject {
    func dataDidRecieveReposData(data: [Repository])
    func error()
}

class RepoViewModel {
    
    weak var delegate: RepoViewModelDelegate?
    
    func getReposData()  {
        let reposUrl = URL(string: "https://api.github.com/repositories")!
        NetworkService.shared.getReposData(url: reposUrl) { [weak self] repos in
            guard let reposModels = repos else {
                self?.delegate?.error()
                return
            }
            
            self?.delegate?.dataDidRecieveReposData(data: reposModels)
        }
    }
}
