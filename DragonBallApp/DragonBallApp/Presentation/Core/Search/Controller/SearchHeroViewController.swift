//
//  SearchHeroViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 15/10/23.
//

import UIKit

// MARK: - Protocol -
protocol SearchHeroViewControllerNavigationDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ model: Hero)
}

protocol SearchHeroViewControllerDelegate {
    var viewState: ((SearchHeroViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func heroBy(index: Int) -> Hero?
}

// MARK: View State -
enum SearchHeroViewState {
    case navigateToDetail(_ model: Hero)
}

// MARK: - SearchHeroViewController -
final class SearchHeroViewController: UIViewController {
    // MARK: - Properties -
    var viewModel: SearchHeroViewControllerDelegate?
    public weak var delegate: SearchHeroViewControllerNavigationDelegate?
    
    // MARK: - UI Elements -
    public let searchHeroTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchHeroTableView)
        searchHeroTableView.dataSource = self
        searchHeroTableView.delegate = self
        
        setObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchHeroTableView.frame = view.bounds
    }
    
    // MARK: - Functions -
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

// MARK: - SearchHeroViewController extension -
extension SearchHeroViewController: UITableViewDataSource, UITableViewDelegate {
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
            delegate?.searchResultsViewControllerDidTapItem(hero)
        }
    }
}
