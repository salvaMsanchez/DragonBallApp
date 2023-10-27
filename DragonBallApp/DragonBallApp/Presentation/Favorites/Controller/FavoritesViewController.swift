//
//  FavoritesViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

protocol FavoritesViewControllerDelegate {
    var viewState: ((FavoritesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
}

// MARK: View State -
enum FavoritesViewState {
    case navigateToDetail(_ model: Hero)
}

final class FavoritesViewController: UIViewController {
    
    var viewModel: FavoritesViewControllerDelegate?
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        
        view.addSubview(favoritesTableView)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTableView.frame = view.bounds
    }
    
}

// MARK: - TABLE VIEW EXTENSION -
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.configure(with: hero, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}
