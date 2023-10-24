//
//  DetailViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import Foundation

final class DetailViewModel: DetailViewControllerDelegate {
    
    private let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    var heroModel: Hero {
        hero
    }
    
}
