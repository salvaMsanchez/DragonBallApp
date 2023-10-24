//
//  DetailViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit

protocol DetailViewControllerDelegate {
    var heroModel: Hero { get }
}

final class DetailViewController: UIViewController {
    
    var viewModel: DetailViewControllerDelegate?
    
    private let detailView = DetailView()
    
    override func loadView() {
        super.loadView()
        view = detailView
        
        if let hero = viewModel?.heroModel {
            detailView.configure(with: hero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
