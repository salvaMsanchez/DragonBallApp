//
//  GalleryHeaderView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

// MARK: - GalleryHeaderView -
final class GalleryHeaderView: UICollectionReusableView {
    // MARK: - Properties -
    static let identifier = "GalleryHeaderView"
    
    // MARK: - UI elements -
    private let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shenron")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "SHENRON"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
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
        addSubview(headerImage)
        addSubview(headerLabel)
    }
    
    private func applyConstraints() {
        let headerImageConstraints = [
            headerImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 200),
            headerImage.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let headerLabelConstraints = [
            headerLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -25),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(headerImageConstraints)
        NSLayoutConstraint.activate(headerLabelConstraints)
    }
}
