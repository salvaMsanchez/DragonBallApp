//
//  GalleryViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

final class GalleryViewModel: GalleryViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties -
    private var heroes: Heroes = []
    private var userIsLogged: Bool
    var heroesCount: Int {
        heroes.count
    }
    var viewState: ((GalleryViewState) -> Void)?
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, userIsLogged: Bool) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.userIsLogged = userIsLogged
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
    }
}
