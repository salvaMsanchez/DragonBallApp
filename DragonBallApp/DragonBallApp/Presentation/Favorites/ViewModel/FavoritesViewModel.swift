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
        // TODO: Hacer cuando la vista aparezca
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
}
