//
//  SplashViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import Foundation

final class SplashViewModel: SplashViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    var viewState: ((SplashViewState) -> Void)?
    
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }()
    
    lazy var galleryViewModel: GalleryViewControllerDelegate = {
        GalleryViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, dataPersistanceManager: DataPersistanceManager(), userDefaultsManager: userDefaultsManager)
    }()
    
    lazy var searchViewModel: SearchViewControllerDelegate = {
        SearchViewModel(dataPersistanceManager: DataPersistanceManager())
    }()
    
    lazy var exploreViewModel: ExploreViewControllerDelegate = {
        ExploreViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, dataPersistanceManager: DataPersistanceManager(), userDefaultsManager: userDefaultsManager)
    }()
    
    lazy var favoritesViewModel: FavoritesViewControllerDelegate = {
        FavoritesViewModel(dataPersistanceManager: DataPersistanceManager())
    }()
    
    private var isLogged: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }
    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.userDefaultsManager = userDefaultsManager
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
//        print(secureDataProvider.getToken() ?? "Default value")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
//            print("is logged: \(self.isLogged)")
            self.isLogged ? self.userDefaultsManager.save(isLogged: true) : self.userDefaultsManager.save(isLogged: false)
            self.isLogged ? self.viewState?(.navigateToMain) : self.viewState?(.navigateToLogin)
//            self.isLogged ? self.viewState?(.navigateToLogin) : self.viewState?(.navigateToMain)
        }
    }
}
