//
//  NetworkService.swift
//  myProject
//
//  Created by Вадим Сосновский on 09.11.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func getReposData(url: URLRequest, completion: @escaping ([Repository]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data!)
                completion(repositories)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getDetailedReposData(url: URLRequest, completion: @escaping (DetailedRepository?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            do {
                let repositories = try JSONDecoder().decode(DetailedRepository.self, from: data!)
                completion(repositories)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }

}
