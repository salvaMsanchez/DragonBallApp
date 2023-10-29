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
    private let dataPersistanceManager: DataPersistanceManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Properties -
    private var heroes: Heroes = []
//    private var isLogged: Bool
    var heroesCount: Int {
        heroes.count
    }
    var viewState: ((GalleryViewState) -> Void)?
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider, userDefaultsManager: userDefaultsManager)
    }()
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, dataPersistanceManager: DataPersistanceManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.dataPersistanceManager = dataPersistanceManager
        self.userDefaultsManager = userDefaultsManager
//        self.isLogged = isLogged
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        if userDefaultsManager.getIsLogged() ?? false {
            defer { viewState?(.loading(false)) }
            dataPersistanceManager.fetchingHeroes(completion: { [weak self] result in
                switch result {
                    case .success(let heroes):
                        self?.heroes = heroes
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            })
        } else {
            DispatchQueue.global().async { [weak self] in
                defer { self?.viewState?(.loading(false)) }
                guard let token = self?.secureDataProvider.getToken() else {
                    return
                }
                Task.init { [weak self] in
                    do {
                        let heroes = try await self?.apiProvider.getHeroes(by: nil, token: token, apiRouter: .getHeroes)
                        guard let heroes else { return }
                        self?.heroes = heroes.filter { $0.description != "No description" }
                        self?.viewState?(.updateData)
                        
                        DispatchQueue.main.async { [weak self] in
                            heroes.forEach { hero in
                                self?.dataPersistanceManager.saveHero(hero: hero) { result in
                                    switch result {
                                        case .success():
                                            break
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
//    func onViewDidAppear() {
//        self.heroes.forEach { hero in
//            self.dataPersistanceManager.saveHero(hero: hero) { result in
//                switch result {
//                    case .success():
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                }
//            }
//        }
//    }
    
    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            return heroes[index]
        } else {
            return nil
        }
    }
    
    func onAddFavoriteButtonPressed(model: Hero, isFavorite: Bool) {
        // TODO: Actualizar CoreData parámetro favorite
        dataPersistanceManager.updateFavorite(thisHero: model, to: isFavorite) { result in
            switch result {
                case .success(()):
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func onLogOutButtonPressed(completion: @escaping (Result<Void, DataBaseError>) -> Void) {
        // TODO: Eliminar CoreData
        // TODO: Eliminar UserDefaults
        // TODO: Eliminar Keychain = Cambiar valor a ""
        
        // TODO: Integrar DISPATCH GROUP PARA AVISAR QUE HAN ACABADO CON ÉXITO LAS TAREAS Y HACER COMPLETION SUCCESS
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async { [weak self] in
            self?.secureDataProvider.save(token: "")
            self?.userDefaultsManager.deleteIsLogged()
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self?.dataPersistanceManager.deleteAllHeroDAO { result in
                    switch result {
                        case .success(()):
                            break
                        case .failure(let error):
                            completion(.failure(error))
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self?.dataPersistanceManager.deleteAllLocationDAO(completion: { result in
                    switch result {
                        case .success(()):
                            break
                        case .failure(let error):
                            completion(.failure(error))
                    }
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
}
