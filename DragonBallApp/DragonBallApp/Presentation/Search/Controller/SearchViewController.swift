//
//  SearchViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

protocol SearchViewControllerDelegate {
    var heroesCount: Int { get }
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
}

final class SearchViewController: UIViewController {
    
    var viewModel: SearchViewControllerDelegate?
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchHeroViewController())
        controller.searchBar.placeholder = "Search for a hero"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        
        searchController.searchResultsUpdater = self
        
        viewModel?.onViewAppear()
        viewModel?.testConnection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
}

// MARK: - TABLE VIEW EXTENSION -
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
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
        return viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell {
            cell.cellPressedAnimation()
        }
    }
}

// MARK: - SEARCH CONTROLLER EXTENSION -
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
}
