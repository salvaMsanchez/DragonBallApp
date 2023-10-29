//
//  DetailViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import Foundation

final class DetailViewModel: DetailViewControllerDelegate {
    
    private let hero: Hero
    private let backButtonActive: Bool
    var viewState: ((DetailViewState) -> Void)?
    
    init(hero: Hero, backButtonActive: Bool) {
        self.hero = hero
        self.backButtonActive = backButtonActive
    }
    
    var heroModel: Hero {
        hero
    }
    
    func onViewAppear() {
        viewState?(.backButton(isActive: backButtonActive))
    }
    
}
