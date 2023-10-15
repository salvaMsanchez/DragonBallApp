//
//  GalleryHeaderView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

final class GalleryHeaderView: UICollectionReusableView {
    
    static let identifier = "GalleryHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
