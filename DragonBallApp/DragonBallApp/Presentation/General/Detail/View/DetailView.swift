//
//  DetailView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit
import Kingfisher

// MARK: - DetailView -
final class DetailView: UIView {
    // MARK: - UI components -
    private let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let shadowView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        uiView.layer.cornerRadius = 20
        uiView.layer.shadowColor = UIColor.systemOrange.cgColor
        uiView.layer.shadowOpacity = 1
        uiView.layer.shadowOffset = CGSize(width: 0, height: 0)
        uiView.layer.shadowRadius = 10
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let descriptionHeroUiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemBackground
        uiView.layer.cornerRadius = 20
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroDescriptionText: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textAlignment = .justified
        textView.backgroundColor = .systemBackground
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    public lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "dragonBallColor")?.cgColor
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor(named: "mainBackgroundColor")?.cgColor
        if let uiImage = UIImage(systemName: "chevron.backward") {
            let image = uiImage.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(named: "dragonBallColor")
        }
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        addSubview(heroImage)
        shadowView.addSubview(descriptionHeroUiView)
        descriptionHeroUiView.addSubview(heroNameLabel)
        descriptionHeroUiView.addSubview(heroDescriptionText)
        addSubview(shadowView)
        addSubview(backButton)
    }
    
    private func applyConstraints() {
        let heroImageConstraints = [
            heroImage.topAnchor.constraint(equalTo: topAnchor, constant: 140),
            heroImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroImage.heightAnchor.constraint(equalToConstant: 225)
        ]
        
        let shadowViewConstraints = [
            shadowView.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 16),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ]
        
        let descriptionHeroUiViewConstraints = [
            descriptionHeroUiView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            descriptionHeroUiView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            descriptionHeroUiView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            descriptionHeroUiView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2)
        ]
        
        let heroNameLabelConstraints = [
            heroNameLabel.topAnchor.constraint(equalTo: descriptionHeroUiView.topAnchor, constant: 24),
            heroNameLabel.centerXAnchor.constraint(equalTo: descriptionHeroUiView.centerXAnchor)
        ]
        
        let heroDescriptionTextConstraints = [
            heroDescriptionText.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 12),
            heroDescriptionText.leadingAnchor.constraint(equalTo: descriptionHeroUiView.leadingAnchor, constant: 16),
            heroDescriptionText.trailingAnchor.constraint(equalTo: descriptionHeroUiView.trailingAnchor, constant: -16),
            heroDescriptionText.bottomAnchor.constraint(equalTo: descriptionHeroUiView.bottomAnchor, constant: -16)
        ]
        
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 114),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(heroImageConstraints)
        NSLayoutConstraint.activate(shadowViewConstraints)
        NSLayoutConstraint.activate(descriptionHeroUiViewConstraints)
        NSLayoutConstraint.activate(heroNameLabelConstraints)
        NSLayoutConstraint.activate(heroDescriptionTextConstraints)
        NSLayoutConstraint.activate(backButtonConstraints)
    }
    
    func configure(with model: Hero) {
        heroImage.kf.setImage(with: model.photo)
        heroNameLabel.text = model.name
        heroDescriptionText.text = model.description
    }
    
    @objc
    func buttonTapped() {
        zoomOut()
        NotificationCenter.default.post(name: NSNotification.Name("BackButtonTapped"), object: nil)
    }
    
    @objc
    func buttonTouchDown() {
        zoomIn()
    }
}

// MARK: Animations
extension DetailView {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.backButton.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.backButton.transform = .identity
        }
    }
}
