//
//  APIClient.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import Foundation

protocol ApiProviderProtocol {
    func login(for user: String, with password: String, apiRouter: APIRouter) async throws -> String
    func getHeroes(by name: String?, token: String, apiRouter: APIRouter) async throws -> Heroes
    func getLocations(by id: String, token: String, apiRouter: APIRouter) async throws -> Locations
}

// MARK: - APIRouter -
enum APIRouter {
    case login
    case getHeroes
    case getLocations
    
    var host: String {
        switch self {
            case .login, .getHeroes, .getLocations:
                return "dragonball.keepcoding.education"
        }
    }
    
    var scheme: String {
        switch self {
            case .login, .getHeroes, .getLocations:
                return "https"
        }
    }
    
    var path: String {
        switch self {
            case .login:
                return "/api/auth/login"
            case .getHeroes:
                return "/api/heros/all"
            case .getLocations:
                return "/api/heros/locations"
        }
    }
    
    var method: String {
        switch self {
            case .login, .getHeroes, .getLocations:
                return "POST"
        }
    }
}

final class APIClient: ApiProviderProtocol {
    // MARK: - Singleton -
//    static let shared = APIClient()
    
    // MARK: - APIError -
    enum APIError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
    }
    
    // MARK: - Functions -
    func login(for user: String, with password: String, apiRouter: APIRouter) async throws -> String {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            throw APIError.malformedUrl
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            throw APIError.decodingFailed
        }
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRouter.method
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let urlResponse = response as? HTTPURLResponse
        let statusCode = urlResponse?.statusCode
        guard statusCode == 200 else {
            throw APIError.statusCode(code: statusCode)
        }
        
        guard let token = String(data: data, encoding: .utf8) else {
            throw APIError.decodingFailed
        }
        
        return token
    }
    
    func getHeroes(by name: String?, token: String, apiRouter: APIRouter) async throws -> Heroes {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            throw APIError.malformedUrl
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRouter.method
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let urlResponse = response as? HTTPURLResponse
        let statusCode = urlResponse?.statusCode
        guard statusCode == 200 else {
            throw APIError.statusCode(code: statusCode)
        }
        
        guard !data.isEmpty else {
            throw APIError.noData
        }
        
        guard let resource = try? JSONDecoder().decode(Heroes.self, from: data) else {
            throw APIError.decodingFailed
        }
        
        return resource
    }
    
    func getLocations(by id: String, token: String, apiRouter: APIRouter) async throws -> Locations {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        
        guard let url = components.url else {
            throw APIError.malformedUrl
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: "\(id)")]
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRouter.method
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let urlResponse = response as? HTTPURLResponse
        let statusCode = urlResponse?.statusCode
        guard statusCode == 200 else {
            throw APIError.statusCode(code: statusCode)
        }
        
        guard !data.isEmpty else {
            throw APIError.noData
        }
        
        guard let resource = try? JSONDecoder().decode(Locations.self, from: data) else {
            throw APIError.decodingFailed
        }
        
        return resource
    }
    
}
