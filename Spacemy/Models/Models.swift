//
//  Models.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 18/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct Event: Codable {
    let categoryID, durationHour: Int
    let name: String
    let creatorID, id: Int
    let eventDate: Date
    let collabID: Int
    let eventDescription: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case durationHour = "duration_hour"
        case name
        case creatorID = "creator_id"
        case id
        case eventDate = "event_date"
        case collabID = "collab_id"
        case eventDescription = "description"
    }
}

typealias Events = [Event]


struct Collab: Codable {
    let id, spots: Int
}

typealias Collabs = [Collab]
