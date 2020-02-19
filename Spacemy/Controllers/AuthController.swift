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

final class AuthController: ObservableObject {
    let eventEndpoint = "https://spacemy.herokuapp.com/events"
    let loginEndpoint = "https://spacemy.herokuapp.com/login"
    
    var events = Events()
    @Published var authToken: String = ""

    func login(regNumber: Int, password: String) {
        self.performLoginRequest(identifier: regNumber, password: password, with: self.loginEndpoint, completion: { tokenData in
            DispatchQueue.main.sync {
                self.authToken = String(data: tokenData, encoding: .utf8)!
            }
        })
    }
    
    func performLoginRequest(identifier: Int, password: String, with urlString: String, completion: @escaping (Data) -> Void) {
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
    
    func performRequest(with urlString: String, completion: @escaping (Events) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    completion(self.parseJSON(safeData))
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ eventsData: Data) -> Events {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var decodedEventsData: Events?
        
        do {
            decodedEventsData = try decoder.decode(Events.self, from: eventsData)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return decodedEventsData!
        
    }
}
