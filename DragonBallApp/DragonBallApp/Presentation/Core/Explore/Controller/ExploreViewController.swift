//
//  ExploreViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit
import MapKit
import Lottie

// MARK: - Protocol -
protocol ExploreViewControllerDelegate {
    var viewState: ((ExploreViewState) -> Void)? { get set }
    var locations: Locations { get }
    var heroes: Heroes { get }
    func onViewAppear()
    func heroBy(name: String) -> Hero?
}

// MARK: - View State -
enum ExploreViewState {
    case loading(_ isLoading: Bool)
    case addPins
}

// MARK: - ExploreViewController -
final class ExploreViewController: UIViewController {
    // MARK: Properties -
    var viewModel: ExploreViewControllerDelegate?
    var annotations: [MKAnnotation] = []
    
    // MARK: - UI elements -
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let activityIndicatorUiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black.withAlphaComponent(0.6)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dragonBallSplashAnimation")
        animation.loopMode = .loop
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemIndigo
        
        view.addSubview(mapView)
        mapView.delegate = self
        setup()
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
        view.addSubview(mapView)
        view.addSubview(activityIndicatorUiView)
        view.addSubview(animationView)
    }

    private func applyConstraints() {
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let activityIndicatorUiViewConstraints = [
            activityIndicatorUiView.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorUiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorUiView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorUiView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let animationViewConstraints = [
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        NSLayoutConstraint.activate(mapViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorUiViewConstraints)
        NSLayoutConstraint.activate(animationViewConstraints)
    }
    
    private func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async { [weak self] in
                switch state {
                    case .loading(let isLoading):
                        self?.activityIndicatorUiView.isHidden = !isLoading
                        self?.animationView.isHidden = !isLoading
                    case .addPins:
                        self?.addPins()
                }
            }
        }
    }
    
    func addPins() {
        mapView.removeAnnotations(mapView.annotations)
        
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
                let exploreDetailViewController = ExploreDetailViewController()
                exploreDetailViewController.viewModel = ExploreDetailViewModel(hero: model)
                present(exploreDetailViewController, animated: true)
            }
        }
    }
}

// MARK: - ExploreViewController extension -
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
        }

        annotations.append(annotation)
        
        let rightButton: UIButton = UIButton(type: .detailDisclosure)
        
        if let index = annotations.lastIndex(where: { $0.title == annotation.title }) {
            rightButton.tag = index
        }
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        annotationView?.rightCalloutAccessoryView = rightButton

        return annotationView
    }
}
