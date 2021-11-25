//
//  FavRepositoryData.swift
//  myProject
//
//  Created by Вадим Сосновский on 25.11.2021.
//

import Foundation
import RealmSwift

class FavRepositoryData: Object, Codable {

    @Persisted var id: Int?
    @Persisted var name: String?
    @Persisted var fullName: String?
    @Persisted var desc: String?
    @Persisted var login: String?
    @Persisted var avatar: String?
    
    @Persisted var language: String?
    @Persisted var stargazers: Int?
    @Persisted var forks: Int?
    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case fullName = "full_name"
//        case desc = "description"
//        case language = "language"
//        case stargazers = "stargazers_count"
//        case forks = "forks_count"
//    }
    
    override class func primaryKey() -> String? {
      return "id"
    }
}
