//
//  DetailedReposModel.swift
//  myProject
//
//  Created by Вадим Сосновский on 13.11.2021.
//

import Foundation
import RealmSwift

class DetailedRepository: Object, Codable {
    
    @Persisted var language: String?
    @Persisted var stargazers: Int?
    @Persisted var forks: Int?
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case stargazers = "stargazers_count"
        case forks = "forks_count"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language = try values.decodeIfPresent(String.self, forKey: .language) ?? nil
        stargazers = try values.decodeIfPresent(Int.self, forKey: .stargazers) ?? nil
        forks = try values.decodeIfPresent(Int.self, forKey: .forks) ?? nil
    }
}
