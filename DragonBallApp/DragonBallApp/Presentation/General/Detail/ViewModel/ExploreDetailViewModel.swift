//
//  ExploreDetailViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 29/10/23.
//

import Foundation

// MARK: - ExploreDetailViewModel -
final class ExploreDetailViewModel: ExploreDetailViewControllerDelegate {
    // MARK: - Properties -
    private let hero: Hero
    var heroModel: Hero {
        hero
    }
    
    // MARK: - Initializers -
    init(hero: Hero) {
        self.hero = hero
    }
}
