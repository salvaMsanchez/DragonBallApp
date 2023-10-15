//
//  SplashView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import UIKit
import Lottie

final class SplashView: UIView {
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundSplash")
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicatorUiView: UIView = {
        let uiView = UIView()
//        uiView.layer.cornerRadius = 20
//        uiView.backgroundColor = .black.withAlphaComponent(0.7)
        uiView.backgroundColor = .systemBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    public let splashActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .green
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
//    var animationView = LottieAnimationView(name: "dragonBallSplashAnimation")
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dragonBallSplashAnimation")
        animation.loopMode = .loop
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.frame = bounds
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
//        addSubview(backgroundImage)
//        addSubview(splashActivityIndicator)
        addSubview(activityIndicatorUiView)
        addSubview(animationView)
    }

    private func applyConstraints() {
        let activityIndicatorUiViewConstraints = [
//            activityIndicatorUiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorUiView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            activityIndicatorUiView.widthAnchor.constraint(equalToConstant: 180),
            activityIndicatorUiView.heightAnchor.constraint(equalToConstant: 125),
            activityIndicatorUiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicatorUiView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        let animationViewConstraints = [
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
//        let splashActivityIndicatorConstraints = [
//            splashActivityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorUiView.centerXAnchor),
//            splashActivityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorUiView.centerYAnchor)
//        ]

//        NSLayoutConstraint.activate(splashActivityIndicatorConstraints)
        NSLayoutConstraint.activate(animationViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorUiViewConstraints)
    }
    
}
