//
//  SecureDataProvider.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 21/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProtocol {
    func save(token: String)
    func getToken() -> String?
}

// Lo suyo sería hacerlo genérico para poder guardar cualquier tipo de dato!
final class SecureDataProvider: SecureDataProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
    }
}
