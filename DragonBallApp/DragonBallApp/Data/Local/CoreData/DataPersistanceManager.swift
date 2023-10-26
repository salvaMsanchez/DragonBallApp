//
//  DataPersistanceManager.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import Foundation
import CoreData

protocol DataPersistanceManagerProtocol {
    func saveHero(hero: Hero, completion: @escaping (Result<Void, DataBaseError>) -> Void)
    func saveLocation(id: String, heroLocations: LocationsHero, completion: @escaping (Result<Void, DataBaseError>) -> Void)
    func fetchingHeroes(completion: @escaping (Result<Heroes, DataBaseError>) -> Void)
    func fetchingLocations(completion: @escaping (Result<Locations, DataBaseError>) -> Void)
    func fetchingHeroesIds() -> [String]
}

enum DataBaseError: Error {
    case failedToSaveData
    case failedToFetchHeroes
    case failedToFetchHeroesIds
}

final class DataPersistanceManager: DataPersistanceManagerProtocol {
    
//    static let shared = DataPersistanceManager()
    
    func saveHero(hero: Hero, completion: @escaping (Result<Void, DataBaseError>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let item = HeroDAO(context: context)
        
        item.id = hero.id
        item.name = hero.name
        item.heroDescription = hero.description
        item.photo = hero.photo.absoluteString
        item.favorite = hero.favorite
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.failedToSaveData))
        }
    }
    
    func saveLocation(id: String, heroLocations: LocationsHero, completion: @escaping (Result<Void, DataBaseError>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let container = LocationContainer(context: context)
        container.heroId = id
        
        heroLocations.forEach { location in
            let item = LocationDAO(context: context)
            item.latitude = location.latitud
            item.heroId = location.hero.id
            item.longitude = location.longitud
            item.id = location.id
            item.date = location.dateShow
            
            container.addToLocations(item)
        }
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.failedToSaveData))
        }
    }
    
    func fetchingHeroes(completion: @escaping (Result<Heroes, DataBaseError>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<HeroDAO>
        request = HeroDAO.fetchRequest()
        
        do {
            let heroesDAO = try context.fetch(request)
            let heroesDAOFiltered = heroesDAO.filter { $0.heroDescription != "No description" }
            let heroes: Heroes = heroesDAOFiltered.compactMap { HeroMapper.mapHeroDAOToHero($0) }
            completion(.success(heroes))
        } catch {
            completion(.failure(.failedToFetchHeroes))
        }
    }
    
    func fetchingLocations(completion: @escaping (Result<Locations, DataBaseError>) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<LocationContainer>
        request = LocationContainer.fetchRequest()
        
        do {
            let locationContainers = try context.fetch(request)
            
            var finalLocations: Locations = []
            locationContainers.forEach { locationContainer in
                if let locations = locationContainer.locations as? Set<LocationDAO> {
//                    locations.forEach { location in
//                        let locationsHero: LocationsHero =
//                    }
                    let locationsHero: LocationsHero = locations.compactMap { LocationMapper.mapLocationContainerToLocationsHero($0)
                    }
                    finalLocations.append(locationsHero)
                }
            }
            completion(.success(finalLocations))
        } catch {
            completion(.failure(.failedToFetchHeroes))
        }
    }
    
    func fetchingHeroesIds() -> [String] {
        var heroesIds: [String] = [String]()
        fetchingHeroes { result in
            switch result {
                case .success(let heroes):
                    let ids: [String] = heroes.map { $0.id }
                    heroesIds = ids
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        return heroesIds
    }
    
}
