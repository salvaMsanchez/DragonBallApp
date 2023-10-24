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
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    
    lazy var galleryViewModel: GalleryViewControllerDelegate = {
        GalleryViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, dataPersistanceManager: DataPersistanceManager(), isLogged: false) // TODO: CAMBIAR A TRUE!!!
    }()
    
    lazy var searchViewModel: SearchViewControllerDelegate = {
        SearchViewModel(dataPersistanceManager: DataPersistanceManager())
    }()
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onLoginPressed(email: String?, password: String?) {
        print("Hola")
        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
//                self.viewState?(.showErrorEmail("Indique un email válido")) // los textos no deberían ir a fuego, deberían ir en un archivo localizable y traducido a otros idiomas
                print("Email invalid")
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
//                self.viewState?(.showErrorPassword("Indique una password válida"))
                print("Password invalid")
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 3 // los números deberían estar en variables constantes!! y no hardcodearlos
    }
    
    private func doLoginWith(email: String, password: String) {
        print("dologinwith")
        Task.init {
            do {
                let token = try await apiProvider.login(for: email, with: password, apiRouter: .login)
                
                guard !token.isEmpty else {
                    print("Aquí hemos caído")
                    return
                }
                
                print("Tokenaso: \(token)")
                secureDataProvider.save(token: token)
                viewState?(.navigateToNext)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
