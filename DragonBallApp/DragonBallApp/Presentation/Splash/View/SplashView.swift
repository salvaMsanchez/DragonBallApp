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
    
    private let splashActivityIndicatorUiView: UIView = {
        let uiView = UIView()
//        uiView.layer.cornerRadius = 20
//        uiView.backgroundColor = .black.withAlphaComponent(0.7)
        uiView.backgroundColor = .systemBackground
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
//    public let splashActivityIndicator: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.style = .large
//        activityIndicator.color = .green
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        return activityIndicator
//    }()
    
//    var animationView = LottieAnimationView(name: "dragonBallSplashAnimation")
    public let splashAnimationView: LottieAnimationView = {
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
        addSubview(splashActivityIndicatorUiView)
        addSubview(splashAnimationView)
    }

    private func applyConstraints() {
        let splashActivityIndicatorUiViewConstraints = [
//            activityIndicatorUiView.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashActivityIndicatorUiView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            activityIndicatorUiView.widthAnchor.constraint(equalToConstant: 180),
            splashActivityIndicatorUiView.heightAnchor.constraint(equalToConstant: 125),
            splashActivityIndicatorUiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            splashActivityIndicatorUiView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        let splashAnimationViewConstraints = [
            splashAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
//        let splashActivityIndicatorConstraints = [
//            splashActivityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorUiView.centerXAnchor),
//            splashActivityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorUiView.centerYAnchor)
//        ]

//        NSLayoutConstraint.activate(splashActivityIndicatorConstraints)
        NSLayoutConstraint.activate(splashAnimationViewConstraints)
        NSLayoutConstraint.activate(splashActivityIndicatorUiViewConstraints)
    }
    
}
