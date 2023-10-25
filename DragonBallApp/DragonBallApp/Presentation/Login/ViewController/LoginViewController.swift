//
//  LoginViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    var galleryViewModel: GalleryViewControllerDelegate { get }
    var searchViewModel: SearchViewControllerDelegate { get }
    var exploreViewModel: ExploreViewControllerDelegate { get }
    func onLoginPressed(email: String?, password: String?)
}

// MARK: View State -
enum LoginViewState {
    case loading(_ isLoading: Bool)
//    case showErrorEmail(_ error: String?)
//    case showErrorPassword(_ error: String?)
    case navigateToNext
}

final class LoginViewController: UIViewController {
    
    var viewModel: LoginViewControllerDelegate?
    
    private let loginView = LoginView()
    
    override func loadView() {
        super.loadView()
        
        loginView.delegate = self
        view = loginView
        
        setObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ocultar teclado al pulsar fuera de los campos, es decir, al pulsar en la vista
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        )
    }
    
    @objc
    func dismissKeyboard() {
        // Para ocultar el teclado al pulsar en cualquier punto de la vista
        view.endEditing(true)
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        print("Loading: \(isLoading)")
                    case .navigateToNext:
                        print("A navegar!")
                        let galleryViewController = GalleryViewController()
                        galleryViewController.viewModel = self?.viewModel?.galleryViewModel
                        let searchViewController = SearchViewController()
                        searchViewController.viewModel = self?.viewModel?.searchViewModel
                        let exploreViewController = ExploreViewController()
                        exploreViewController.viewModel = self?.viewModel?.exploreViewModel
                        
                        let nextVC = MainTabBarViewcontroller(galleryViewController: galleryViewController, searchViewController: searchViewController, exploreViewController: exploreViewController)
                        self?.navigationController?.setViewControllers([nextVC], animated: true)
                }
            }
        }
    }
    
}

extension LoginViewController: LoginViewDelegate {
    func onLoginButtonTapped(send loginData: LoginData) {
        print("Email: \(loginData.email)\nPassword: \(loginData.password)")
        viewModel?.onLoginPressed(email: loginData.email, password: loginData.password)
    }
}
