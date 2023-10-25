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
            Task.init { [weak self] in
                do {
                    let locations = try await self?.apiProvider.getLocations(by: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", token: token, apiRouter: .getLocations)
                    guard let locations else { return }
                    print(locations)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
