//
//  DetailViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import Foundation

// MARK: - DetailViewModel -
final class DetailViewModel: DetailViewControllerDelegate {
    // MARK: - Properties -
    private let hero: Hero
    private let backButtonActive: Bool
    var viewState: ((DetailViewState) -> Void)?
    var heroModel: Hero {
        hero
    }
    
    // MARK: - Initializers -
    init(hero: Hero, backButtonActive: Bool) {
        self.hero = hero
        self.backButtonActive = backButtonActive
    }
    
    // MARK: - Functions -
    func onViewAppear() {
        viewState?(.backButton(isActive: backButtonActive))
    }
}
