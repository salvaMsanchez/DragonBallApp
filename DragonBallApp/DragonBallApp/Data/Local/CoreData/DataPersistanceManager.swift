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
    func fetchingHeroes(completion: @escaping (Result<Heroes, DataBaseError>) -> Void)
}

enum DataBaseError: Error {
    case failedToSaveData
    case failedToFetchData
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
//            print(error.localizedDescription)
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
//            print(error.localizedDescription)
            completion(.failure(.failedToFetchData))
        }
    }
    
}
