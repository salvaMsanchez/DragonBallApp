//
//  HeroMapper.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import Foundation

struct HeroMapper {
    static func mapHeroDAOToHero(_ heroDAO: HeroDAO) -> Hero? {
        guard let id = heroDAO.id,
              let name = heroDAO.name,
              let description = heroDAO.heroDescription,
              let photoString = heroDAO.photo,
              let photoURL = URL(string: photoString) else {
            return nil
        }
        return Hero(id: id, name: name, description: description, photo: photoURL, favorite: heroDAO.favorite)
    }
}
