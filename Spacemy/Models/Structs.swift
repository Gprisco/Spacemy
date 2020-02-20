//
//  Models.swift
//  Spacemy
//
//  Created by Giovanni Prisco on 18/02/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

struct Event: Codable {
    let category_id: Int
    let name: String
    let creator_id, id: Int
    let event_date: Date
    let collab_id: Int
    let description: String
    let finish_date: Date
}

typealias Events = [Event]

struct Collab: Codable, Hashable, Identifiable {
    let id, spots: Int
}

typealias Collabs = [Collab]

enum Category: String, CaseIterable {
    case meetAndShare = "Meet and Share"
    case notPublic = "Private"
    case notPrivate = "Public"
}
