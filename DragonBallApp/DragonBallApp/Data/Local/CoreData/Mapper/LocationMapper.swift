//
//  LocationMapper.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 25/10/23.
//

import Foundation

struct LocationMapper {
    static func mapLocationContainerToLocationsHero(_ locationDAO: LocationDAO) -> Location? {
        guard let id = locationDAO.id,
              let heroId = locationDAO.heroId,
              let longitude = locationDAO.longitude,
              let latitude = locationDAO.latitude,
              let date = locationDAO.date else {
            return nil
        }
        return Location(latitud: latitude, hero: HeroId(id: heroId), longitud: longitude, id: id, dateShow: date)
    }
}
