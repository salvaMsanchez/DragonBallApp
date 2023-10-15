//
//  APIClient.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import Foundation

final class APIClient {
    // MARK: - Singleton -
    static let shared = APIClient()
    
    enum APIRouter {
        case login
        
        var host: String {
            switch self {
                case .login:
                    return "dragonball.keepcoding.education"
            }
        }
        
        var scheme: String {
            switch self {
                case .login:
                    return "https"
            }
        }
        
        var path: String {
            switch self {
                case .login:
                    return "/api/auth/login"
            }
        }
        
        var method: String {
            switch self {
                case .login:
                    return "POST"
            }
        }
    }
    
    enum APIError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
    }
    
    func login(user: String, password: String, apiRouter: APIRouter) async throws -> String {
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
    
}
