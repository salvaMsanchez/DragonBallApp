//
//  TestViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 21/10/23.
//

import UIKit

final class TestViewController: UIViewController {
    
    private let activityIndicatorUiView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 20
        uiView.backgroundColor = .black.withAlphaComponent(0.7)
        uiView.isHidden = true
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let splashActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 191.5, height: 250)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        view.addSubview(galleryCollectionView)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.frame = view.bounds
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
        view.addSubview(splashActivityIndicator)
        view.addSubview(activityIndicatorUiView)
    }

    private func applyConstraints() {
        let activityIndicatorUiViewConstraints = [
            activityIndicatorUiView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorUiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorUiView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorUiView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            activityIndicatorUiView.widthAnchor.constraint(equalToConstant: 80),
//            activityIndicatorUiView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let splashActivityIndicatorConstraints = [
            splashActivityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorUiView.centerXAnchor),
            splashActivityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorUiView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(splashActivityIndicatorConstraints)
        NSLayoutConstraint.activate(activityIndicatorUiViewConstraints)
    }
    
}

extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.identifier, for: indexPath) as? TestCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}
