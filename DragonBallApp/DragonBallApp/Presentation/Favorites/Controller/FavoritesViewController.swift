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
    func onViewWillAppear()
    func onDeleteButtonPressed(removeAt indexPath: IndexPath)
    func heroBy(index: Int) -> Hero?
}

// MARK: View State -
enum FavoritesViewState {
    case navigateToDetail(_ model: Hero)
    case updateData
    case deleteData(_ indexPath: IndexPath, _ animation: UITableView.RowAnimation)
}

final class FavoritesViewController: UIViewController {
    
    var viewModel: FavoritesViewControllerDelegate?
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(favoritesTableView)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        
        setObservers()
//        viewModel?.onViewAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.onViewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTableView.frame = view.bounds
    }
    
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .navigateToDetail(_):
                        // TODO: Navegar al Detail
                        break
                    case .updateData:
                        self?.favoritesTableView.reloadData()
                    case .deleteData(let indexPath, let animation):
                        self?.favoritesTableView.deleteRows(at: [indexPath], with: animation)
                }
            }
        }
    }
}

// MARK: - TABLE VIEW EXTENSION -
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.configure(with: hero, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                viewModel?.onDeleteButtonPressed(removeAt: indexPath)
            default:
                break
        }
    }
}
