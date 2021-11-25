//
//  DetailedReposModel.swift
//  myProject
//
//  Created by Вадим Сосновский on 13.11.2021.
//

import Foundation
import RealmSwift

struct DetailedRepository: Codable {
    
    var language: String?
    var stargazers: Int?
    var forks: Int?
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case stargazers = "stargazers_count"
        case forks = "forks_count"
    }
}
