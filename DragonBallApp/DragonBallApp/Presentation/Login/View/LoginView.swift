//
//  LoginView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 22/10/23.
//

import UIKit
import Lottie

typealias LoginData = (email: String, password: String)

protocol LoginViewDelegate {
    func onLoginButtonTapped(send loginData: LoginData)
}

final class LoginView: UIView {
    
    var delegate: LoginViewDelegate?
    
    private let emailContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let emailTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemOrange.cgColor
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(string: "Introduce tu email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Agrega un espacio en la parte izquierda del campo de texto
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always

        return textField
    }()
    
    private let passwordContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0
        view.layer.shadowRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        textField.isSecureTextEntry = true
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5.0
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemOrange.cgColor
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = .systemGray6
        textField.attributedPlaceholder = NSAttributedString(string: "Introduce tu contraseña", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Agrega un espacio en la parte izquierda del campo de texto
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var loginContinueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continuar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18.0)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let activityIndicatorUiView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 20
        uiView.backgroundColor = .black.withAlphaComponent(0.6)
        uiView.isHidden = true
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    public let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dragonBallSplashAnimation")
        animation.loopMode = .loop
        animation.play()
        animation.isHidden = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        addSubview(emailContainerView)
        emailContainerView.addSubview(emailTextField)
        addSubview(passwordContainerView)
        passwordContainerView.addSubview(passwordTextField)
        addSubview(loginContinueButton)
        addSubview(activityIndicatorUiView)
        addSubview(animationView)
    }
    
    private func applyConstraints() {
        let emailContainerViewConstraints = [
            emailContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailContainerView.bottomAnchor.constraint(equalTo: passwordContainerView.topAnchor, constant: -16),
            emailContainerView.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
        ]
        
        let passwordContainerViewConstraints = [
            passwordContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            passwordContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            passwordContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let loginContinueButtonConstraints = [
            loginContinueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginContinueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loginContinueButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginContinueButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let activityIndicatorUiViewConstraints = [
            activityIndicatorUiView.topAnchor.constraint(equalTo: topAnchor),
            activityIndicatorUiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicatorUiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicatorUiView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            activityIndicatorUiView.widthAnchor.constraint(equalToConstant: 180),
//            activityIndicatorUiView.heightAnchor.constraint(equalToConstant: 180)
        ]
        let animationViewConstraints = [
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(emailContainerViewConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordContainerViewConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(loginContinueButtonConstraints)
        NSLayoutConstraint.activate(activityIndicatorUiViewConstraints)
        NSLayoutConstraint.activate(animationViewConstraints)
    }
    
    @objc
    func buttonTouchDown() {
        zoomIn()
    }
    
    @objc
    func buttonTapped() {
        zoomOut()
        if let emailInput = emailTextField.text,
           let passwordInput = passwordTextField.text {
            delegate?.onLoginButtonTapped(send: (emailInput, passwordInput))
        }
//        if let emailInput = emailTextField.text,
//        let passwordInput = passwordTextField.text {
//            buttonTapHandler?((emailInput, passwordInput))
//        }
    }
    
}

// MARK: - Animations
extension LoginView {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.loginContinueButton.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.loginContinueButton.transform = .identity
        }
    }

}

extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
            case 1:
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [.allowUserInteraction],
                    animations: { [weak self] in
                        self?.emailContainerView.layer.shadowOffset = CGSize(width: 5, height: 5)
                        self?.emailContainerView.layer.shadowColor = UIColor.systemOrange.cgColor
                        self?.emailContainerView.layer.shadowOpacity = 1.0
                        self?.emailContainerView.layer.shadowRadius = 1.0
                    },
                    completion: nil
                )
            case 2:
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [.allowUserInteraction],
                    animations: { [weak self] in
                        self?.passwordContainerView.layer.shadowOffset = CGSize(width: 5, height: 5)
                        self?.passwordContainerView.layer.shadowColor = UIColor.systemOrange.cgColor
                        self?.passwordContainerView.layer.shadowOpacity = 1.0
                        self?.passwordContainerView.layer.shadowRadius = 1.0
                    },
                    completion: nil
                )
            default:
                break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
            case 1:
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [.allowUserInteraction],
                    animations: { [weak self] in
                        self?.emailContainerView.layer.shadowColor = .none
                        self?.emailContainerView.layer.shadowOffset = .zero
                        self?.emailContainerView.layer.shadowOpacity = 0.0
                        self?.emailContainerView.layer.shadowRadius = 0.0
                    },
                    completion: nil
                )
            case 2:
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [.allowUserInteraction],
                    animations: { [weak self] in
                        self?.passwordContainerView.layer.shadowColor = .none
                        self?.passwordContainerView.layer.shadowOffset = .zero
                        self?.passwordContainerView.layer.shadowOpacity = 0.0
                        self?.passwordContainerView.layer.shadowRadius = 0.0
                    },
                    completion: nil
                )
            default:
                break
        }
    }
}
