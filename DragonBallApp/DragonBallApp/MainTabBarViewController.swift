//
//  MainTabBarViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 13/10/23.
//

import UIKit

final class MainTabBarViewcontroller: UITabBarController {
    
    private let galleryViewController: GalleryViewController
    private let searchViewController: SearchViewController
    private let exploreViewController: ExploreViewController
    
    init(galleryViewController: GalleryViewController, searchViewController: SearchViewController, exploreViewController: ExploreViewController) {
        self.galleryViewController = galleryViewController
        self.searchViewController = searchViewController
        self.exploreViewController = exploreViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: galleryViewController)
        let vc2 = UINavigationController(rootViewController: searchViewController)
        let vc3 = UINavigationController(rootViewController: exploreViewController)
        let vc4 = UINavigationController(rootViewController: FavoritesViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "square.grid.2x2.fill")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "map.fill")
        vc4.tabBarItem.image = UIImage(systemName: "heart")
        
        vc1.title = "Gallery"
        vc2.title = "Search"
        vc3.title = "Explore"
        vc4.title = "Favorites"
        
        tabBar.tintColor = .systemOrange
//        tabBar.itemPositioning = .centered
//        tabBar.itemSpacing = 1
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemGray
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
}
