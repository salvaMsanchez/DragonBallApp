//
//  SearchHeroViewController.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 15/10/23.
//

import UIKit

protocol SearchHeroViewControllerDelegate {
    var viewState: ((SearchViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func heroBy(index: Int) -> Hero?
}

// MARK: View State -
enum SearchViewState {
    case navigateToDetail
}

final class SearchHeroViewController: UIViewController {
    
    var viewModel: SearchHeroViewControllerDelegate?
    
    public let searchHeroTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemPink
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        view.addSubview(searchHeroTableView)
        searchHeroTableView.dataSource = self
        searchHeroTableView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchHeroTableView.frame = view.bounds
    }
    
    private func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                    case .navigateToDetail:
                        // TODO: Navegar al Detail
                        break
                }
            }
        }
    }
    
}

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
    }
}
