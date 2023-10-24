//
//  DetailView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit
import Kingfisher

final class DetailView: UIView {
    // MARK: - UI components -
    private let heroImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "goku")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20
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
//        uiView.layer.borderColor = UIColor.blue.cgColor
//        uiView.layer.borderWidth = 3
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
//        label.text = "GOKU"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroDescriptionText: UITextView = {
        let textView = UITextView()
//        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque consequat orci a tincidunt iaculis. Sed vitae libero eu libero placerat convallis vitae a neque. Suspendisse libero odio, cursus vitae nibh a, iaculis egestas justo. Morbi mollis porta sapien id dictum. Aenean non erat massa. Pellentesque posuere lacus elit, commodo cursus orci tincidunt eget. Donec tempor, orci luctus fermentum dapibus, augue ipsum ultrices erat, et tincidunt eros erat finibus tellus. Donec urna lectus, viverra a lacus non, tempor dapibus mi. Integer varius velit sollicitudin magna feugiat lacinia. Ut aliquet, ligula vel elementum sollicitudin, est urna porta nunc, id porta lorem urna ut nisi. In in aliquam sapien.Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textAlignment = .justified
        textView.backgroundColor = .systemBackground
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    }
    
    private func applyConstraints() {
        
        let heroImageConstraints = [
            heroImage.topAnchor.constraint(equalTo: topAnchor, constant: 104),
            heroImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroImage.heightAnchor.constraint(equalToConstant: 250)
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
        
        NSLayoutConstraint.activate(heroImageConstraints)
        NSLayoutConstraint.activate(shadowViewConstraints)
        NSLayoutConstraint.activate(descriptionHeroUiViewConstraints)
        NSLayoutConstraint.activate(heroNameLabelConstraints)
        NSLayoutConstraint.activate(heroDescriptionTextConstraints)
    }
    
    func configure(with model: Hero) {
        heroImage.kf.setImage(with: model.photo)
        heroNameLabel.text = model.name
        heroDescriptionText.text = model.description
    }
    
}
