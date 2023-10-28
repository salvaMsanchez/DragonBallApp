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
    var loginViewModel: LoginViewControllerDelegate { get }
    var galleryViewModel: GalleryViewControllerDelegate { get }
    var searchViewModel: SearchViewControllerDelegate { get }
    var exploreViewModel: ExploreViewControllerDelegate { get }
    var favoritesViewModel: FavoritesViewControllerDelegate { get }
    func onViewAppear()
}

// MARK: View State -
enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
    case navigateToMain
}

final class SplashViewController: UIViewController {
    
    var viewModel: SplashViewControllerDelegate?
    
    private let splashView = SplashView()
    
    override func loadView() {
        super.loadView()
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        splashView.splashAnimationView.stop()
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.splashView.splashAnimationView.isHidden = !isLoading
                    case .navigateToLogin:
                        let nextVC = LoginViewController()
                        nextVC.viewModel = self?.viewModel?.loginViewModel
                        self?.navigationController?.setViewControllers([nextVC], animated: true)
                    case .navigateToMain:
                        let galleryViewController = GalleryViewController()
                        galleryViewController.viewModel = self?.viewModel?.galleryViewModel
                        let searchViewController = SearchViewController()
                        searchViewController.viewModel = self?.viewModel?.searchViewModel
                        let exploreViewController = ExploreViewController()
                        exploreViewController.viewModel = self?.viewModel?.exploreViewModel
                        let favoritesViewController = FavoritesViewController()
                        favoritesViewController.viewModel = self?.viewModel?.favoritesViewModel
                        
                        let nextVC = MainTabBarViewcontroller(galleryViewController: galleryViewController, searchViewController: searchViewController, exploreViewController: exploreViewController, favoritesViewController: favoritesViewController)
                        self?.navigationController?.setViewControllers([nextVC], animated: true)
                }
            }
        }
    }
    
}
