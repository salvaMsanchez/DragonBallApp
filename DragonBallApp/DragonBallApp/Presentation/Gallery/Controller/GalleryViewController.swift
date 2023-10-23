//
//  GalleryViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol GalleryViewControllerDelegate {
    var viewState: ((GalleryViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func onViewAppear()
    func onViewDidAppear()
    func heroBy(index: Int) -> Hero?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        
        view.addSubview(galleryCollectionView)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.onViewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        galleryCollectionView.frame = view.bounds
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        // TODO: Añadir UIView y activity indicator para simular carga hacia detalle - OPCIONAL
                        print("¿La vista está cargando? -> \(isLoading)")
                    case .updateData:
                        self?.galleryCollectionView.reloadData()
                }
            }
        }
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
                let downloadAction = UIAction(
                    title: "Download",
                    subtitle: nil,
                    image: nil,
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { _ in
//                        guard let indexPath = indexPaths.first else {
//                            return
//                        }
//                        self?.downloadTitleAt(indexPath: indexPath)
                    }
                return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
}
