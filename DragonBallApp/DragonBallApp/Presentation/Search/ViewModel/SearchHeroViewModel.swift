//
//  SearchHeroViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 24/10/23.
//

import Foundation

final class SearchHeroViewModel: SearchHeroViewControllerDelegate {
    var viewState: ((SearchViewState) -> Void)?
    
    private var heroes: Heroes
    var heroesCount: Int {
        heroes.count
    }
    
    init(heroes: Heroes) {
        self.heroes = heroes
    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
}
