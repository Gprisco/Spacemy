//
//  EventsController.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 19/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct CreateEvent: Encodable {
    let category_id: Int
    let name: String
    let creator_id: Int
    let event_date: Date
    let collab_id: Int
    let description: String
    let finish_date: Date
}

final class EventsModel: ObservableObject {
    let eventsEndpoint: String = "https://spacemy.herokuapp.com/events"
    
    @Published var events = Events()
    @Published var createdEvent: Event?
    
    func fetchEvents() {
        self.performEventsRequest(with: self.eventsEndpoint, completion: { events in
            DispatchQueue.main.async {
                print(events)
                self.events = events
            }
        })
    }
    
    func participate(event_id: Int) {
        self.performParticipateRequest(with: "\(self.eventsEndpoint)/participate/\(event_id)", completion: { data in
            DispatchQueue.main.async {
                //print(data)
            }
        })
    }
    
    func createEvent(event: CreateEvent) {
        self.performEventCreation(event: event, with: "\(self.eventsEndpoint)/create", completion: { event in
            DispatchQueue.main.async {
                self.createdEvent = event
            }
        })
    }
    
    func performEventCreation(event: CreateEvent, with urlString: String, completion: @escaping (Event) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            let authToken = UserDefaults().string(forKey: "authToken")
            
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .iso8601
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            do {
                let encodedData = try encoder.encode(event)
            
                request.httpBody = encodedData
                                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    if let safeData = data {
                        completion(self.parseJSON(eventData: safeData))
                    }
                }
                
                task.resume()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func performParticipateRequest(with urlString: String, completion: @escaping (Data) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            let authToken = UserDefaults().string(forKey: "authToken")
            
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data {
                    completion(safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func performEventsRequest(with urlString: String, completion: @escaping (Events) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            let authToken = UserDefaults().string(forKey: "authToken")
            
            request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data {
                    completion(self.parseJSON(eventsData: safeData))
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(eventsData: Data) -> Events {
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
    
    func parseJSON(eventData: Data) -> Event {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        var decodedEventData: Event?
        
        do {
            decodedEventData = try decoder.decode(Event.self, from: eventData)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return decodedEventData!
        
    }
}
