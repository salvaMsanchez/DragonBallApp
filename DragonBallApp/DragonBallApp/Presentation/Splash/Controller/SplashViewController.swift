//
//  SplashViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set }
}

// MARK: View State -
enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToNext
}

final class SplashViewController: UIViewController {
    
    private let splashView = SplashView()
    
    override func loadView() {
        super.loadView()
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.init {
            do {
                let token = try await APIClient.shared.login(for: "morenosanchezsalva@gmail.com", with: "0000000", apiRouter: .login)
                print("Tu token es \(token)")
            } catch {
                print(error)
            }
        }
    }
    
}
