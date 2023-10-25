//
//  Location.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 25/10/23.
//

import Foundation

typealias LocationsHero = [Location]
typealias Locations = [LocationsHero]

struct Location: Decodable {
    let latitud: String
    let hero: HeroId
    let longitud: String
    let id: String
    let dateShow: String
}

struct HeroId: Decodable {
    let id: String
}
