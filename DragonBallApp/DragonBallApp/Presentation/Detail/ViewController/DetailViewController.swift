//
//  DetailViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
