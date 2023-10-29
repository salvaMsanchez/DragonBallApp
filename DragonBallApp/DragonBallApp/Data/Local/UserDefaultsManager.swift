//
//  UserDefaultsManager.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 26/10/23.
//

import Foundation

// MARK: - Protocol -
protocol UserDefaultsManagerProtocol {
    func getIsLogged() -> Bool?
    func save(isLogged: Bool)
    func deleteIsLogged()
}

// MARK: - UserDefaultsManager -
struct UserDefaultsManager: UserDefaultsManagerProtocol {
    private let userDefaults = UserDefaults.standard
    
    private let key = "IsLogged"
    
    func getIsLogged() -> Bool? {
        userDefaults.bool(forKey: key)
    }
    
    func save(isLogged: Bool) {
        userDefaults.set(isLogged, forKey: key)
    }
    
    func deleteIsLogged() {
        userDefaults.removeObject(forKey: key)
    }
}
