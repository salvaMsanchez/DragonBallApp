//
//  LoginViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import Foundation

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
    
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            DispatchQueue.global().async {
                guard self.isValid(email: email) else {
                    self.viewState?(.loading(false))
                    self.viewState?(.showErrorEmail("Indique un email válido")) // los textos no deberían ir a fuego, deberían ir en un archivo localizable y traducido a otros idiomas
                    self.viewState?(.hideErrorPassword)
//                    print("Email invalid")
                    return
                }
                
                guard self.isValid(password: password) else {
                    self.viewState?(.loading(false))
                    self.viewState?(.showErrorPassword("Indique una contraseña válida"))
                    self.viewState?(.hideErrorEmail)
//                    print("Password invalid")
                    return
                }
                
                self.doLoginWith(
                    email: email ?? "",
                    password: password ?? ""
                )
            }
        }
        
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 3 // los números deberían estar en variables constantes!! y no hardcodearlos
    }
    
    private func doLoginWith(email: String, password: String) {
//        defer {
//            viewState?(.loading(false))
//        }
        Task.init {
            do {
                let token = try await apiProvider.login(for: email, with: password, apiRouter: .login)
                
                guard !token.isEmpty else {
                    return
                }
                
//                print("Tokenaso: \(token)")
                secureDataProvider.save(token: token)
                userDefaultsManager.save(isLogged: false)
                viewState?(.navigateToNext)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
