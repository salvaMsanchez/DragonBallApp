//
//  FavoritesViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

final class FavoritesViewModel: FavoritesViewControllerDelegate {
    // MARK: - Dependencies -
    private let dataPersistanceManager: DataPersistanceManagerProtocol
    // MARK: - Properties -
    var viewState: ((FavoritesViewState) -> Void)?
    private var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    
    // MARK: - Initializers -
    init(dataPersistanceManager: DataPersistanceManagerProtocol) {
        self.dataPersistanceManager = dataPersistanceManager
    }
    
    func onViewAppear() {
        dataPersistanceManager.fetchingFavoritesHeroes { [weak self] result in
            switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    self?.viewState?(.updateData)
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
