//
//  CollabsController.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct SugCollabRequest: Encodable {
    var categoryId: Int
    var date: Date
    var durationHour: Int
}

final class CollabsModel: ObservableObject {
    let collabsEndpoint = "https://spacemy.herokuapp.com/suggestedCollabs"
    
    @Published var collabs = Collabs()

    func fetchCollabs(categoryId: Int, date: Date, durationHour: Int) {
        self.performCollabsRequest(categoryId: categoryId, date: date, durationHour: durationHour, with: self.collabsEndpoint, completion: { collabs in
            DispatchQueue.main.async {
                self.collabs = collabs
            }
        })
    }
    
    func performCollabsRequest(categoryId: Int, date: Date, durationHour: Int, with urlString: String, completion: @escaping (Collabs) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            let authToken = UserDefaults().string(forKey: "authToken")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .iso8601
            
            do {
                let encodedData = try encoder.encode(SugCollabRequest(categoryId: categoryId, date: date, durationHour: durationHour))
            
                request.httpBody = encodedData
                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let safeData = data {
                        completion(self.parseJSON(safeData))
                    }
                }
                
                task.resume()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func parseJSON(_ collabsData: Data) -> Collabs {
        let decoder = JSONDecoder()
        
        var decodedCollabsData: Collabs?
        
        do {
            decodedCollabsData = try decoder.decode(Collabs.self, from: collabsData)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return decodedCollabsData!
    }
}
