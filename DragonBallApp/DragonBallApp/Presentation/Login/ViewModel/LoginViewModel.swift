//
//  LoginViewModel.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import Foundation

final class LoginViewModel: LoginViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
}
