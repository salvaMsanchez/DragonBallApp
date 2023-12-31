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
    var favoritesViewModel: FavoritesViewControllerDelegate { get }
    func onLoginPressed(email: String?, password: String?)
}

// MARK: View State -
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case hideErrorEmail
    case showErrorPassword(_ error: String?)
    case hideErrorPassword
    case showAlertFailedAuthentication
    case navigateToNext
}

// MARK: LoginViewController -
final class LoginViewController: UIViewController {
    // MARK: Properties -
    var viewModel: LoginViewControllerDelegate?
    private var loginView = LoginView()
    
    // MARK: Lifecycle -
    override func loadView() {
        super.loadView()
        
        view = loginView
        loginView.delegate = self
        
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
    
    // MARK: Functions -
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
                        self?.loginView.activityIndicatorUiView.isHidden = !isLoading
                        self?.loginView.animationView.isHidden = !isLoading
                    case .showErrorEmail(let error):
                        self?.loginView.invalidEmailText.text = error
                        self?.loginView.invalidEmailText.isHidden = (error == nil || error?.isEmpty == true)
                    case .hideErrorEmail:
                        self?.loginView.invalidEmailText.isHidden = true
                    case .showErrorPassword(let error):
                        self?.loginView.invalidPasswordText.text = error
                        self?.loginView.invalidPasswordText.isHidden = (error == nil || error?.isEmpty == true)
                    case .hideErrorPassword:
                        self?.loginView.invalidPasswordText.isHidden = true
                    case .showAlertFailedAuthentication:
                        let alertController = UIAlertController(
                            title: "Autenticación fallida",
                            message: "Las credenciales proporcionadas son incorrectas. Por favor, verifica tu correo electrónico y contraseña e inténtalo nuevamente",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alertController, animated: true)
                    case .navigateToNext:
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
                        self?.loginView.activityIndicatorUiView.isHidden = true
                        self?.loginView.animationView.isHidden = true
                }
            }
        }
    }
}

// MARK: LoginViewController extension -
extension LoginViewController: LoginViewDelegate {
    func onLoginButtonTapped(send loginData: LoginData) {
        viewModel?.onLoginPressed(email: loginData.email, password: loginData.password)
    }
}
