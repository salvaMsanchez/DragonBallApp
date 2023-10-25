//
//  ExploreViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit
import MapKit

protocol ExploreViewControllerDelegate {
    func onViewAppear()
}

final class ExploreViewController: UIViewController {
    
    var viewModel: ExploreViewControllerDelegate?
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        
        view.addSubview(mapView)
        mapView.delegate = self
//        setup()
        
        viewModel?.onViewAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
//    private func setup() {
//        addViews()
//        applyConstraints()
//    }
//
//    private func addViews() {
//        view.addSubview(mapView)
//    }
//
//    private func applyConstraints() {
//        let mapViewConstraints = [
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ]
//
//        NSLayoutConstraint.activate(mapViewConstraints)
//    }
    
}

extension ExploreViewController: MKMapViewDelegate {
    
}
