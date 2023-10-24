//
//  SearchViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

final class SearchViewModel: SearchViewControllerDelegate {
    // MARK: - Dependencies -
    private let dataPersistanceManager: DataPersistanceManagerProtocol
    
    // MARK: - Properties -
    private var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    
    init(dataPersistanceManager: DataPersistanceManagerProtocol) {
        self.dataPersistanceManager = dataPersistanceManager
    }
    
    func onViewAppear() {
        print("On view appear")
        dataPersistanceManager.fetchingHeroes { [weak self] result in
            switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    print("Héroes \(heroes)")
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
