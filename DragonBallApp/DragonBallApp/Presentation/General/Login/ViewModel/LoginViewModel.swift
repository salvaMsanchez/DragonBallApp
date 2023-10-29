//
//  LoginViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import Foundation

// MARK: - LoginViewModel -
final class LoginViewModel: LoginViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    
    lazy var galleryViewModel: GalleryViewControllerDelegate = {
        GalleryViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, dataPersistanceManager: DataPersistanceManager(), userDefaultsManager: UserDefaultsManager())
    }()
    
    lazy var searchViewModel: SearchViewControllerDelegate = {
        SearchViewModel(dataPersistanceManager: DataPersistanceManager())
    }()
    
    lazy var exploreViewModel: ExploreViewControllerDelegate = {
        ExploreViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, dataPersistanceManager: DataPersistanceManager(), userDefaultsManager: UserDefaultsManager())
    }()
    
    lazy var favoritesViewModel: FavoritesViewControllerDelegate = {
        FavoritesViewModel(dataPersistanceManager: DataPersistanceManager())
    }()
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.userDefaultsManager = userDefaultsManager
    }
    
    // MARK: Functions -
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.global().async {
                guard self.isValid(email: email) else {
                    self.viewState?(.loading(false))
                    self.viewState?(.showErrorEmail("Indique un email válido"))
                    self.viewState?(.hideErrorPassword)
                    return
                }
                
                guard self.isValid(password: password) else {
                    self.viewState?(.loading(false))
                    self.viewState?(.showErrorPassword("Indique una contraseña válida"))
                    self.viewState?(.hideErrorEmail)
                    return
                }
                
                self.doLoginWith(
                    email: email ?? "",
                    password: password ?? ""
                )
            }
        }
        
    }
    
    func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 3
    }
    
    private func doLoginWith(email: String, password: String) {
        Task.init {
            do {
                let token = try await apiProvider.login(for: email, with: password, apiRouter: .login)
                
                guard !token.isEmpty else {
                    return
                }
                
                secureDataProvider.save(token: token)
                userDefaultsManager.save(isLogged: false)
                viewState?(.navigateToNext)
            } catch {
                print(error.localizedDescription)
                viewState?(.loading(false))
                viewState?(.showAlertFailedAuthentication)
            }
        }
    }
}
