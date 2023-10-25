//
//  Location.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 25/10/23.
//

import Foundation

typealias Locations = [Location]

struct Location: Decodable {
    let latitud: String
    let id: String
    let longitud: String
    let dateShow: String
}
