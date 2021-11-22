//
//  FullReposModel.swift
//  myProject
//
//  Created by Вадим Сосновский on 18.11.2021.
//

import Foundation
import RealmSwift

class FullRepository: Object, Codable {
    
    @Persisted var commit: Commit?
    
    enum CodingKeys: String, CodingKey {
        case commit
    }
}

class Commit: Object, Codable {
    
    @Persisted var committer: Committer?
    @Persisted var message: String?
    
    enum CodingKeys: String, CodingKey {
        case committer
        case message = "message"
    }
}

class Committer: Object, Codable {
    
    @Persisted var date: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
