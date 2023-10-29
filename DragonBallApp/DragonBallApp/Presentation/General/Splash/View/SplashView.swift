//
//  SplashView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import UIKit
import Lottie

final class SplashView: UIView {
    // MARK: - UI elements -
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainBackgroundSplash")
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let splashActivityIndicatorUiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(named: "mainBackgroundColor")
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    public let splashAnimationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dragonBallSplashAnimation")
        animation.loopMode = .loop
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainBackgroundColor")
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
    
    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
        addSubview(splashActivityIndicatorUiView)
        addSubview(splashAnimationView)
    }

    private func applyConstraints() {
        let splashActivityIndicatorUiViewConstraints = [
            splashActivityIndicatorUiView.centerYAnchor.constraint(equalTo: centerYAnchor),
            splashActivityIndicatorUiView.heightAnchor.constraint(equalToConstant: 125),
            splashActivityIndicatorUiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            splashActivityIndicatorUiView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        let splashAnimationViewConstraints = [
            splashAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(splashAnimationViewConstraints)
        NSLayoutConstraint.activate(splashActivityIndicatorUiViewConstraints)
    }
    
}
