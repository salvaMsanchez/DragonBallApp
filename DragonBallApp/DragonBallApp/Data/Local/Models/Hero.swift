//
//  Hero.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import Foundation

typealias Heroes = [Hero]

protocol MainHeroData: Decodable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var photo: URL { get }
}

struct Hero: MainHeroData, Equatable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}
