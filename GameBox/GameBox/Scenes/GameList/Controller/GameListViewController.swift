//
//  GameListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

// MARK: - GameListViewController
final class GameListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionViewGenres: UICollectionView! {
        didSet {
            collectionViewGenres.delegate = self
            collectionViewGenres.dataSource = self
            
            // MARK: Registering collectionViewGenres cells
            collectionViewGenres.register(UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        }
    }
    
    @IBOutlet private weak var tableViewGames: UITableView! {
        didSet {
            tableViewGames.delegate = self
            tableViewGames.dataSource = self
            
            // MARK: Registering tableViewGames cells
            tableViewGames.register(UINib(nibName: GameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GameTableViewCell.identifier)
            
            // MARK: Automatic Dimension
            tableViewGames.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: - Variables
    private var viewModel: GameListViewModelProtocol = GameListViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.tintColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
    }

}

// MARK: - Extension: Helper Methods
extension GameListViewController {
    
    private func prepareScreen() {
        // Preparing NavigationItem
        self.navigationItem.title = "Games"
        
        // Setting appearance of NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Initializing Search Bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Type something to search"
        navigationItem.searchController = search
        
        // Prevented automatic hiding of SearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Changing TabBar icon colors
        self.tabBarController?.tabBar.tintColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
        
        // Preparing viewModel
        viewModel.delegate = self
        viewModel.fetchGenres()
        viewModel.fetchGames()
    }
    
}

// MARK: - Extension: viewModel
extension GameListViewController: GameListViewModelDelegate {
    
    func preFetch() {
        indicator.startAnimating()
    }
    
    func postFetch() {
        indicator.stopAnimating()
    }
    
    func fetchFailed(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func fetchedGames() {
        tableViewGames.reloadData()
    }
    
    func fetchedGenres() {
        collectionViewGenres.reloadData()
    }
    
}

// MARK: - Extension: collectionViewGenres
extension GameListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGenreCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell
        else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            // Initializing "All" as a genre
            let genreAllJson = """
            {
                "id": 0,
                "name": "All",
                "slug": "all"
            }
            """

            let genreAll = try! JSONDecoder().decode(CommonModel.self, from: Data(genreAllJson.utf8))
            
            cell.configureCell(genre: genreAll, backgroundColorType: .blue)
        } else {
            let cellModel = viewModel.getGenre(at: (indexPath.row - 1))
            cell.configureCell(genre: cellModel!, backgroundColorType: .blue)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.removeFilter(filterKey: "genres")
        } else {
            viewModel.addFilter(filter: ["genres": viewModel.getGenre(at: (indexPath.row - 1))!.slug])
        }
        viewModel.fetchGames()
    }
    
}

// MARK: - Extension: tableViewGames
extension GameListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell,
              let cellGame = viewModel.getGame(at: indexPath.row)
        else { return UITableViewCell() }
        
        cell.configureCell(game: cellGame)
        
        if indexPath.row == (viewModel.getGameCount() - 1) {
            viewModel.fetchMoreGames(page: (viewModel.getCurrentPage() + 1))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedGame = viewModel.getGame(at: indexPath.row) else { return }
        
        guard let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: GameDetailViewController.identifier) as? GameDetailViewController else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        gameDetailViewController.gameDetail = selectedGame
        self.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
}

// MARK: - Extension: UISearchResultsUpdating
extension GameListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            viewModel.removeFilter(filterKey: "search")
        } else {
            viewModel.addFilter(filter: ["search" : searchText])
        }
        viewModel.fetchGames()
    }
    
}
