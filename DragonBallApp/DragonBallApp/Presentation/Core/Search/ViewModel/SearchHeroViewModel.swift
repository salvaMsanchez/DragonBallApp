//
//  SearchHeroViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 24/10/23.
//

import Foundation

// MARK: - SearchHeroViewModel -
final class SearchHeroViewModel: SearchHeroViewControllerDelegate {
    // MARK: - Properties -
    private var heroes: Heroes
    var heroesCount: Int {
        heroes.count
    }
    
    // MARK: - Initializers -
    init(heroes: Heroes) {
        self.heroes = heroes
    }
    
    // MARK: - Functions -
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
}
