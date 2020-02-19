//
//  File.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 18/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    var identifier: Int
    var password: String
}

final class AuthModel: ObservableObject {
    let loginEndpoint = "https://spacemy.herokuapp.com/login"
    let registerEndpoint = "https://spacemy.herokuapp.com/register"
    let logoutEndpoint = "https://spacemy.herokuapp.com/logout"
    
    @Published var authToken: String = ""
    
    func login(regNumber: Int, password: String) {
        self.performRequest(identifier: regNumber, password: password, with: self.loginEndpoint, completion: { tokenData in
            DispatchQueue.main.sync {
                self.authToken = String(data: tokenData, encoding: .utf8)!
            }
        })
    }
    
    func register(regNumber: Int, password: String) {
        self.performRequest(identifier: regNumber, password: password, with: self.registerEndpoint, completion: { response in
            DispatchQueue.main.async {
                //print(response)
            }
        })
    }
    
    func logout() {
        self.performLogoutRequest(with: self.logoutEndpoint, completion: { response in
            DispatchQueue.main.async {
                //print(response)
            }
        })
    }
    
    func performRequest(identifier: Int, password: String, with urlString: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(LoginRequest(identifier: identifier, password: password))
                
                request.httpBody = data
                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let safeData = data {
                        completion(safeData)
                    }
                }
                
                task.resume()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func performLogoutRequest(with urlString: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            let token = UserDefaults().string(forKey: "authToken")
            
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
                        
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    completion(safeData)
                }
            }
            
            task.resume()
        }
    }}
