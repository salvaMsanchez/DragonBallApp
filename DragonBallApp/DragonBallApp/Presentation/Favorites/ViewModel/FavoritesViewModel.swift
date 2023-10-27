//
//  FavoritesViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

final class FavoritesViewModel: FavoritesViewControllerDelegate {
    // MARK: - Dependencies -
    
    // MARK: - Properties -
    var viewState: ((FavoritesViewState) -> Void)?
    private var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    
    func onViewAppear() {
        <#code#>
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
}
