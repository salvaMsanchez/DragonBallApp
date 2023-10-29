//
//  ExploreDetailViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 29/10/23.
//

import UIKit

// MARK: - Protocol -
protocol ExploreDetailViewControllerDelegate {
    var heroModel: Hero { get }
}

// MARK: - ExploreDetailViewController -
final class ExploreDetailViewController: UIViewController {
    // MARK: - Properties -
    var viewModel: ExploreDetailViewControllerDelegate?
    private let exploreDetailView = ExploreDetailView()
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        view = exploreDetailView
        
        if let hero = viewModel?.heroModel {
            exploreDetailView.configure(with: hero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let presentationController = presentationController as? UISheetPresentationController else {
            return
        }
        presentationController.detents = [.medium(), .large()]
        presentationController.selectedDetentIdentifier = .medium
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 20
    }
}
