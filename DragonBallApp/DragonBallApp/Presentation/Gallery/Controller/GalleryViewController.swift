//
//  GalleryViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit
import Lottie

// MARK: - View Protocol -
protocol GalleryViewControllerDelegate {
    var viewState: ((GalleryViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func onViewAppear()
//    func onViewDidAppear()
    func heroBy(index: Int) -> Hero?
    func onAddFavoriteButtonPressed(model: Hero, isFavorite: Bool)
}

// MARK: - View State -
enum GalleryViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

final class GalleryViewController: UIViewController {
    
    var viewModel: GalleryViewControllerDelegate?
    
    private let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 191.5, height: 250)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemRed
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.register(GalleryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GalleryHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicatorUiView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 20
        uiView.backgroundColor = .black.withAlphaComponent(0.6)
//        uiView.isHidden = true
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    public let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "dragonBallSplashAnimation")
        animation.loopMode = .loop
        animation.play()
//        animation.isHidden = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        
        view.addSubview(galleryCollectionView)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        setup()
        configureNavBar()
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel?.onViewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.frame = view.bounds
    }
    
    private func onHeroCellPressed(model: Hero) {
        let detailViewController = DetailViewController()
        detailViewController.viewModel = DetailViewModel(hero: model)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        print(isLoading)
                        self?.activityIndicatorUiView.isHidden = !isLoading
                        self?.animationView.isHidden = !isLoading
                    case .updateData:
                        self?.galleryCollectionView.reloadData()
                }
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "title")
        let size = CGSize(width: 135, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { (context) in
            image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        image = resizedImage.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }

    private func addViews() {
        view.addSubview(activityIndicatorUiView)
        view.addSubview(animationView)
    }

    private func applyConstraints() {
        let activityIndicatorUiViewConstraints = [
            activityIndicatorUiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorUiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorUiView.widthAnchor.constraint(equalToConstant: 180),
            activityIndicatorUiView.heightAnchor.constraint(equalToConstant: 180)
        ]
        let animationViewConstraints = [
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        NSLayoutConstraint.activate(activityIndicatorUiViewConstraints)
        NSLayoutConstraint.activate(animationViewConstraints)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.configure(with: hero)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.heroesCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
            cell.cellPressedAnimation()
        }
        
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            onHeroCellPressed(model: hero)
        }
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GalleryHeaderView.identifier, for: indexPath) as! GalleryHeaderView
                return headerView
            default:
                assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 215)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let isfavoriteAction = UIAction(
                    title: "Add to favorites",
                    subtitle: nil,
                    image: nil,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { [weak self] _ in
                        guard let indexPath = indexPaths.first else {
                            return
                        }
                        guard let hero = self?.viewModel?.heroBy(index: indexPath.row) else {
                            return
                        }
                        self?.viewModel?.onAddFavoriteButtonPressed(model: hero, isFavorite: true)
                    }
                let isNotfavoriteAction = UIAction(
                    title: "Remove from favorites",
                    subtitle: nil,
                    image: nil,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    attributes: .destructive,
                    state: .off) { [weak self] _ in
                        guard let indexPath = indexPaths.first else {
                            return
                        }
                        guard let hero = self?.viewModel?.heroBy(index: indexPath.row) else {
                            return
                        }
                        self?.viewModel?.onAddFavoriteButtonPressed(model: hero, isFavorite: false)
                    }
                return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [isfavoriteAction, isNotfavoriteAction])
            }
        return config
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}
