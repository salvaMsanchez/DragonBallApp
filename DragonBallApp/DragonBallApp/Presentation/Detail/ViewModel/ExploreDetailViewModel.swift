//
//  ExploreDetailViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 29/10/23.
//

import Foundation

final class ExploreDetailViewModel: ExploreDetailViewControllerDelegate {
    private let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    var heroModel: Hero {
        hero
    }
}
