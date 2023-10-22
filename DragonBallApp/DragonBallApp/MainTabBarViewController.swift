//
//  MainTabBarViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import UIKit

final class MainTabBarViewcontroller: UITabBarController {
    
    private let galleryViewController: GalleryViewController
    
    init(galleryViewController: GalleryViewController) {
        self.galleryViewController = galleryViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        let vc1 = UINavigationController(rootViewController: GalleryViewController())
        let vc1 = UINavigationController(rootViewController: galleryViewController)
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: ExploreViewController())
        let vc4 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "square.grid.2x2.fill")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "map.fill")
        vc4.tabBarItem.image = UIImage(systemName: "gear")
        
        vc1.title = "Gallery"
        vc2.title = "Search"
        vc3.title = "Explore"
        vc4.title = "Settings"
        
        tabBar.tintColor = .systemOrange
//        tabBar.itemPositioning = .centered
//        tabBar.itemSpacing = 1
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemGray
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
}
