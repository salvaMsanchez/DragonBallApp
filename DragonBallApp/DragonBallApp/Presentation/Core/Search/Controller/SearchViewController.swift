//
//  SearchViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

// MARK: - Protocol -
protocol SearchViewControllerDelegate {
    var heroesCount: Int { get }
    var getHeroes: [Hero] { get }
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
}

// MARK: - SearchViewController -
final class SearchViewController: UIViewController {
    // MARK: - Properties -
    var viewModel: SearchViewControllerDelegate?
    
    // MARK: - UI elements -
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchHeroViewController())
        controller.searchBar.placeholder = "Buscar un héroe"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Búsquedas"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self
        
        viewModel?.onViewAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    // MARK: - Functions -
    private func onHeroCellPressed(model: Hero) {
        let detailViewController = DetailViewController()
        detailViewController.viewModel = DetailViewModel(hero: model, backButtonActive: true)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
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
        
        if let hero = viewModel?.heroBy(index: indexPath.row) {
            onHeroCellPressed(model: hero)
        }
    }
}

// MARK: - SEARCH CONTROLLER EXTENSION -
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchHeroViewController else {
            return
        }
        resultsController.delegate = self
        
        let heroesSearched = SearchAlgorithm.searchHeroesAlgorithm(heroes: viewModel?.getHeroes ?? [], query: query)
        
        resultsController.viewModel = SearchHeroViewModel(heroes: heroesSearched)
        resultsController.searchHeroTableView.reloadData()
    }
}

// MARK: - SearchHeroViewControllerNavigationDelegate -
extension SearchViewController: SearchHeroViewControllerNavigationDelegate {
    func searchResultsViewControllerDidTapItem(_ model: Hero) {
        let detailViewController = DetailViewController()
        detailViewController.viewModel = DetailViewModel(hero: model, backButtonActive: false)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}
