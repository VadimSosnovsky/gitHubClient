//
//  Model.swift
//  myProject
//
//  Created by Вадим Сосновский on 06.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class Repository: Object, Codable {

    @Persisted var name: String?
    @Persisted var fullName: String?
    @Persisted var desc: String?
    @Persisted var owner: Owner?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fullName = "full_name"
        case desc = "description"
        case owner
    }
    
    override class func primaryKey() -> String? {
      return "fullName"
    }
}

class Owner: Object, Codable {

    @Persisted var login: String?
    @Persisted var avatar: String?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatar = "avatar_url"
    }
}
