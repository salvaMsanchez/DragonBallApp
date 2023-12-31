//
//  DetailViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit

// MARK: - Protocol -
protocol DetailViewControllerDelegate {
    var viewState: ((DetailViewState) -> Void)? { get set }
    var heroModel: Hero { get }
    func onViewAppear()
}

// MARK: - View State -
enum DetailViewState {
    case backButton(isActive: Bool)
}

// MARK: - DetailViewController -
final class DetailViewController: UIViewController {
    // MARK: - Properties -
    var viewModel: DetailViewControllerDelegate?
    private let detailView = DetailView()
    
    // MARK: - Lifecycle -
    override func loadView() {
        super.loadView()
        
        view = detailView
        
        if let hero = viewModel?.heroModel {
            detailView.configure(with: hero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(backDetail), name: NSNotification.Name("BackButtonTapped"), object: nil)
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Functions -
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .backButton(isActive: let isActive):
                        self?.detailView.backButton.isHidden = !isActive
                }
            }
        }
    }
    
    @objc
    func backDetail() {
        navigationController?.popViewController(animated: true)
    }
}
