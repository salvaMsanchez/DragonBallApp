//
//  LoginViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import UIKit

protocol LoginViewControllerDelegate {
    
}

final class LoginViewController: UIViewController {
    
    var viewModel: LoginViewControllerDelegate?
    
    private let loginView = LoginView()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
