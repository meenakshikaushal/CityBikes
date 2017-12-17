//
//  Networks.swift
//  CityBikes
//
//  Created by Meenakshi katal on 12/11/17.
//  Copyright © 2017 Meenakshi Katal. All rights reserved.
//

import Foundation

struct NetworkRoot: Decodable {
    let networks: [Network]
}

struct Network: Decodable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Decodable {
    let city: String
}


struct NetworkDetailRoot: Decodable {
    let network: NetworkDetail
}

struct NetworkDetail: Decodable {
    let stations: [Station]
}

struct Station: Decodable {
    var name: String
    var freeBikes: Int
    var emptySlots: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case freeBikes = "free_bikes"
        case emptySlots = "empty_slots"
    }
}

