//
//  Model.swift
//  myProject
//
//  Created by Вадим Сосновский on 06.11.2021.
//

import Foundation
import UIKit

struct Repository: Decodable {
    
    let name: String?
    let description: String?
    let languages: String?
    let forks: String?
    let stargazers: String?
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case languages = "languages_url"
        case forks = "forks_url"
        case stargazers = "stargazers_url"
        case owner
    }
}

struct Owner: Decodable {
    
    let login: String?
    let avatar: URL?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatar = "avatar_url"
    }
}

