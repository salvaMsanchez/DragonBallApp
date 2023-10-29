//
//  SearchViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

// MARK: - SearchViewModel -
final class SearchViewModel: SearchViewControllerDelegate {
    // MARK: - Dependencies -
    private let dataPersistanceManager: DataPersistanceManagerProtocol
    
    // MARK: - Properties -
    private var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    var getHeroes: [Hero] {
        heroes
    }
    
    // MARK: - Initializers -
    init(dataPersistanceManager: DataPersistanceManagerProtocol) {
        self.dataPersistanceManager = dataPersistanceManager
    }
    
    // MARK: - Functions -
    func onViewAppear() {
        dataPersistanceManager.fetchingHeroes { [weak self] result in
            switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
}
