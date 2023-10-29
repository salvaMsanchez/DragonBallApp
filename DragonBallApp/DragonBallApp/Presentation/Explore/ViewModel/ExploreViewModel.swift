//
//  ExploreViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import Foundation

final class ExploreViewModel: ExploreViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let dataPersistanceManager: DataPersistanceManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    // MARK: - Properties -
    var viewState: ((ExploreViewState) -> Void)?
    private var entireHeroes: Heroes = []
    private var entireLocations: Locations = []
    private var heroesIds: [String] = []
    var locations: Locations {
        entireLocations
    }
    var heroes: Heroes {
        entireHeroes
    }
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, dataPersistanceManager: DataPersistanceManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.dataPersistanceManager = dataPersistanceManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    func onViewAppear() {
        if self.userDefaultsManager.getIsLogged() ?? false {
            defer {
                viewState?(.addPins)
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                    self?.viewState?(.loading(false))
                }
            }
            dataPersistanceManager.fetchingHeroes { [weak self] result in
                switch result {
                    case .success(let heroes):
                        self?.entireHeroes = heroes
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
            dataPersistanceManager.fetchingLocations { [weak self] result in
                switch result {
                    case .success(let locations):
                        self?.entireLocations = locations
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        } else {
            dataPersistanceManager.fetchingHeroes { [weak self] result in
                switch result {
                    case .success(let heroes):
                        self?.entireHeroes = heroes
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
            let heroesIds = self.dataPersistanceManager.fetchingHeroesIds()
            self.heroesIds = heroesIds
            DispatchQueue.global().async { [weak self] in
                guard let token = self?.secureDataProvider.getToken() else {
                    return
                }
                let dispatchGroup = DispatchGroup()
                self?.heroesIds.forEach { id in
                    dispatchGroup.enter()
                    Task.init { [weak self] in
                        defer {
                            dispatchGroup.leave()
                        }
                        do {
                            guard let locationsHero = try await self?.apiProvider.getLocations(by: id, token: token, apiRouter: .getLocations) else {
                                return
                            }
                            self?.entireLocations.append(locationsHero)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) { [weak self] in
                    self?.sortLocations()
                    self?.saveLocationsInTheDatabase()
                    self?.viewState?(.addPins)
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                        self?.viewState?(.loading(false))
                    }
                }
            }
        }
    }
    
    func heroBy(name: String) -> Hero? {
        if let hero = self.heroes.first(where: { $0.name == name }) {
            return hero
        } else {
            return nil
        }
    }
    
    func sortLocations() {
        self.entireLocations.sort(by: compareLocations)
    }
    
    func saveLocationsInTheDatabase() {
        self.entireLocations.forEach {
            dataPersistanceManager.saveLocation(id: $0[0].hero.id, heroLocations: $0) { result in
                switch result {
                    case .success(()):
                        print("Localizaciones guardadas con éxito en CoreData")
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    func compareLocations(_ a: LocationsHero, _ b: LocationsHero) -> Bool {
        guard let idA = a.first?.hero.id,
              let idB = b.first?.hero.id,
              let indexA = self.heroesIds.firstIndex(of: idA),
              let indexB = self.heroesIds.firstIndex(of: idB) else {
            return false
        }
        return indexA < indexB
    }
}
