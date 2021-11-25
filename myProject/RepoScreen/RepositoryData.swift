//
//  RepositoryData.swift
//  myProject
//
//  Created by Вадим Сосновский on 16.11.2021.
//

import Foundation
import RealmSwift

struct RepositoryData {

    var id: Int?
    var name: String?
    var fullName: String?
    var desc: String?
    var login: String?
    var avatar: String?
    
    var language: String?
    var stargazers: Int?
    var forks: Int?
    
//    override class func primaryKey() -> String? {
//      return "id"
//    }
}
