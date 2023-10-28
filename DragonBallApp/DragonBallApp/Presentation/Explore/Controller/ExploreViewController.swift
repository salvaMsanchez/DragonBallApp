//
//  ExploreViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit
import MapKit

protocol ExploreViewControllerDelegate {
    var viewState: ((ExploreViewState) -> Void)? { get set }
    var locations: Locations { get }
    var heroes: Heroes { get }
    func onViewAppear()
    func heroBy(name: String) -> Hero?
}

// MARK: View State -
enum ExploreViewState {
    case addPins
    case navigateToDetail(_ model: Hero)
}

final class ExploreViewController: UIViewController {
    
    var viewModel: ExploreViewControllerDelegate?
    
    var annotations: [MKAnnotation] = []
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var loginContinueButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        
        view.addSubview(mapView)
        mapView.delegate = self
        setup()
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        mapView.frame = view.bounds
//    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
        view.addSubview(mapView)
    }

    private func applyConstraints() {
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(mapViewConstraints)
    }
    
    private func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async { [weak self] in
                switch state {
                    case .addPins:
                        self?.addPins()
                    case .navigateToDetail(_):
                        // TODO: Navigate to Detail
                        break
                }
            }
        }
    }
    
    func addPins() {
        guard let locations = viewModel?.locations,
        let heroes = viewModel?.heroes else {
            return
        }
        if locations.count > 0 {
            locations.enumerated().forEach { index, locationsHero in
                locationsHero.forEach { location in
                    guard let latitude = Double(location.latitud),
                          let longitude = Double(location.longitud) else {
                        return
                    }
                    let pin = MKPointAnnotation()
                    pin.title = heroes[index].name
                    pin.coordinate = CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    )
                    mapView.addAnnotation(pin)
                }
            }
        }
    }
    
    @objc
    func buttonTapped(sender: UIButton) {
        let index = sender.tag
        
        if index < annotations.count {
            let annotation = annotations[index]
            if let title = annotation.title {
                guard let title,
                      let model = viewModel?.heroBy(name: title) else {
                    return
                }
                let detailViewController = DetailViewController()
                detailViewController.viewModel = DetailViewModel(hero: model, backButtonActive: false)
                detailViewController.modalPresentationStyle = .formSheet
                present(detailViewController, animated: true)
            }
        }
    }
    
}

extension ExploreViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            
            let pinImage = UIImage(named: "dragonBallPin")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView?.image = resizedImage
            
            annotations.append(annotation)
            
            let rightButton: UIButton = UIButton(type: .detailDisclosure)
            if let index = annotations.firstIndex(where: { $0.isEqual(annotation) }) {
                rightButton.tag = index
            }
            rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotationTitle = view.annotation?.title,
//              let heroName = annotationTitle,
//              let model = viewModel?.heroBy(name: heroName) else {
//            return
//        }
//        let detailViewController = DetailViewController()
//        detailViewController.viewModel = DetailViewModel(hero: model)
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
}
