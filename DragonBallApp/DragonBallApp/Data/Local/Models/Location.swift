//
//  Location.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 25/10/23.
//

import Foundation

typealias Locations = [Location]

struct Location: Decodable {
    let latitude: String
    let date: String
    let id: String
    let longitude: String
}
