//
//  TestView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 21/10/23.
//

import UIKit

//class TestCollectionViewCell: UICollectionViewCell {
//
//    static let identifier = "TestCollectionViewCell"
//
//    var imageView: UIImageView!
//    var gradientLayer: CAGradientLayer!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Crear la UIImageView
//        imageView = UIImageView(frame: self.contentView.bounds)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "goku")
//        self.contentView.addSubview(imageView)
//
//        // Crear el gradiente
//        gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.contentView.bounds
//        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.clear.cgColor]
//        gradientLayer.locations = [0.0, 1.0]
//        self.contentView.layer.addSublayer(gradientLayer)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Asegurarse de que el gradiente se actualiza cuando cambia el tamaño de la celda
//        gradientLayer.frame = self.contentView.bounds
//    }
//}

//final class TestCollectionViewCell: UICollectionViewCell {
//
//    static let identifier = "TestCollectionViewCell"
//
//    // MARK: - Private properties -
//    private var gradientAdded = false
//
//    private let shadowView: UIView = {
//        let uiView = UIView()
//        uiView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
//        uiView.layer.cornerRadius = 20
//        uiView.layer.shadowColor = UIColor.systemOrange.cgColor
//        uiView.layer.shadowOpacity = 1
//        uiView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        uiView.layer.shadowRadius = 10
//        uiView.translatesAutoresizingMaskIntoConstraints = false
//        return uiView
//    }()
//
//    private let cardView: UIView = {
//        let uiView = UIView()
//        uiView.backgroundColor = .systemGray
//        uiView.layer.cornerRadius = 20
//        uiView.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 163.66666666666666, height: 234.0))
//        uiView.translatesAutoresizingMaskIntoConstraints = false
//        return uiView
//    }()
//
//    private let gradientView: UIView = {
//        let uiView = UIView()
//        uiView.backgroundColor = .systemGray
//        uiView.layer.cornerRadius = 20
//        uiView.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 163.66666666666666, height: 234.0))
//        uiView.translatesAutoresizingMaskIntoConstraints = false
//        return uiView
//    }()
//
//    private let heroImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20
//        imageView.image = UIImage(named: "goku")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let heroNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "GOKU"
//        label.textColor = .label
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    public func addGradient() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [
//            UIColor.clear.cgColor,
//            UIColor.clear.cgColor,
//            UIColor.clear.cgColor,
//            UIColor.systemOrange.cgColor
//        ]
//        gradientLayer.locations = [0.01, 0.1, 0.7, 1.0]
//        gradientLayer.frame = gradientView.bounds
//        gradientLayer.cornerRadius = 20
//
//        gradientView.layer.addSublayer(gradientLayer)
//
//        // Remove any existing gradient layers before adding a new one
////        if let existingGradientLayer = cardView.layer.sublayers?.first as? CAGradientLayer {
////            existingGradientLayer.removeFromSuperlayer()
////        }
//
////        cardView.layer.insertSublayer(gradientLayer, at: 0)
//
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .systemBlue
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        heroImageView.frame = cardView.bounds
//
////        if !(cardView.layer.sublayers?.first is CAGradientLayer) {
////            addGradient()
////        }
//        print(gradientView.bounds)
//
//        if !gradientAdded && gradientView.bounds != .zero {
////            layoutIfNeeded()
//            addGradient()
//            gradientAdded = true
//        }
//    }
//
//    // MARK: - Functions -
//    private func setup() {
//        addViews()
//        applyConstraints()
//    }
//
//    private func addViews() {
////        contentView.addSubview(cardView)
////        cardView.addSubview(heroImageView)
////        contentView.addSubview(heroImageView)
//
//        shadowView.addSubview(cardView)
//        cardView.addSubview(gradientView)
//        cardView.addSubview(heroImageView)
//        contentView.addSubview(shadowView)
//        cardView.addSubview(heroNameLabel)
//    }
//
//    private func applyConstraints() {
//        let shadowViewConstraints = [
//            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
//            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
//        ]
//
//        let cardViewConstraints = [
//            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
//            cardView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
//            cardView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
//            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2)
//        ]
//
//        let heroImageViewConstraints = [
//            heroImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
//            heroImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//            heroImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//            heroImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
//        ]
//
//        let heroNameLabelConstraints = [
//            heroNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
//            heroNameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
//        ]
//
//        NSLayoutConstraint.activate(shadowViewConstraints)
//        NSLayoutConstraint.activate(cardViewConstraints)
//        NSLayoutConstraint.activate(heroImageViewConstraints)
//        NSLayoutConstraint.activate(heroNameLabelConstraints)
//
//    }
//
//}

final class TestCollectionViewCell: UICollectionViewCell {

    static let identifier = "TestCollectionViewCell"

    // MARK: - Private properties -
    private var gradientAdded = false

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

    private let cardView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemGray
        uiView.layer.cornerRadius = 20
        uiView.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 163.66666666666666, height: 234.0))
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "goku")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.text = "GOKU"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.locations = [0.01, 0.1, 0.7, 1.0]
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = 20

        cardView.layer.addSublayer(gradientLayer)

        // Remove any existing gradient layers before adding a new one
//        if let existingGradientLayer = cardView.layer.sublayers?.first as? CAGradientLayer {
//            existingGradientLayer.removeFromSuperlayer()
//        }

//        cardView.layer.insertSublayer(gradientLayer, at: 0)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        setup()
        addGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        heroImageView.frame = cardView.bounds

//        if !(cardView.layer.sublayers?.first is CAGradientLayer) {
//            addGradient()
//        }
        print(cardView.bounds)

//        if !gradientAdded && cardView.bounds != .zero {
////            layoutIfNeeded()
//            addGradient()
//            gradientAdded = true
//        }
    }

    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
//        contentView.addSubview(cardView)
//        cardView.addSubview(heroImageView)
//        contentView.addSubview(heroImageView)

        
        shadowView.addSubview(cardView)
        cardView.addSubview(heroImageView)
        contentView.addSubview(shadowView)
//        cardView.addSubview(heroNameLabel)
        contentView.addSubview(heroNameLabel)
        
    }

    private func applyConstraints() {
        let shadowViewConstraints = [
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ]

        let cardViewConstraints = [
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            cardView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            cardView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2)
        ]

        let heroImageViewConstraints = [
            heroImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ]

        let heroNameLabelConstraints = [
            heroNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
            heroNameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ]

        NSLayoutConstraint.activate(shadowViewConstraints)
        NSLayoutConstraint.activate(cardViewConstraints)
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(heroNameLabelConstraints)

    }

}
