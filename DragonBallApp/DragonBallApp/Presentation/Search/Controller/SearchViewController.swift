//
//  SearchViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

protocol SearchViewControllerDelegate {
    var viewState: ((SearchViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var getHeroes: [Hero] { get }
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
}

// MARK: View State -
enum SearchViewState {
    case navigateToDetail(_ model: Hero)
}

final class SearchViewController: UIViewController {
    
    var viewModel: SearchViewControllerDelegate?
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
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
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                    case .navigateToDetail(_):
                        // TODO: Navegar al Detail
                        break
                }
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

extension SearchViewController: SearchHeroViewControllerNavigationDelegate {
    func searchResultsViewControllerDidTapItem(_ model: Hero) {
        let detailViewController = DetailViewController()
        detailViewController.viewModel = DetailViewModel(hero: model)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200)) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}
