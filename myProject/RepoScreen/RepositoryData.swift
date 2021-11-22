//
//  RepositoryData.swift
//  myProject
//
//  Created by Вадим Сосновский on 16.11.2021.
//

import Foundation
import RealmSwift

class RepositoryData: Object, Codable {

    @Persisted var id: Int?
    @Persisted var name: String?
    @Persisted var fullName: String?
    @Persisted var desc: String?
    @Persisted var login: String?
    @Persisted var avatar: String?
    
    @Persisted var language: String?
    @Persisted var stargazers: Int?
    @Persisted var forks: Int?
    
    override class func primaryKey() -> String? {
      return "id"
    }
}
