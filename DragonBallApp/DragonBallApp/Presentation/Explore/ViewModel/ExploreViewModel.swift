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
    
    // MARK: - Properties -
    private var locations: Locations = []
    private var heroesIds: [String] = []
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol, dataPersistanceManager: DataPersistanceManagerProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.dataPersistanceManager = dataPersistanceManager
    }
    
    func onViewAppear() {
        DispatchQueue.global().async { [weak self] in
            guard let token = self?.secureDataProvider.getToken() else {
                return
            }
            guard let heroesIds = self?.dataPersistanceManager.fetchingHeroesIds() else {
                return
            }
            self?.heroesIds = heroesIds
            let dispatchGroup = DispatchGroup()
            heroesIds.forEach { id in
                dispatchGroup.enter()
                Task.init { [weak self] in
                    defer {
                        dispatchGroup.leave()
                    }
                    do {
                        guard let locationsHero = try await self?.apiProvider.getLocations(by: id, token: token, apiRouter: .getLocations) else {
                            return
                        }
                        self?.locations.append(locationsHero)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.sortLocations()
            }
        }
    }
    
    func sortLocations() {
        self.locations.sort(by: compareLocations)
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
