//
//  Model.swift
//  myProject
//
//  Created by Вадим Сосновский on 06.11.2021.
//

import Foundation
import RealmSwift

struct Repository: Codable {

    var id: Int?
    var name: String?
    var fullName: String?
    var desc: String?
    var owner: Owner?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case desc = "description"
        case owner
    }
}

struct Owner: Codable {

    var login: String?
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatar = "avatar_url"
    }
}
