//
//  FavoriteListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit

// MARK: FavoriteListViewController
final class FavoriteListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionViewGenres: UICollectionView! {
        didSet {
            collectionViewGenres.delegate = self
            collectionViewGenres.dataSource = self
            
            // MARK: Registering collectionViewGenres cells
            collectionViewGenres.register(UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        }
    }
    
    @IBOutlet private weak var tableViewFavoriteGames: UITableView! {
        didSet {
            tableViewFavoriteGames.delegate = self
            tableViewFavoriteGames.dataSource = self
            
            // MARK: Registering tableViewGames cells
            tableViewFavoriteGames.register(UINib(nibName: GameTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GameTableViewCell.identifier)
            
            // MARK: Automatic Dimension
            tableViewFavoriteGames.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: - Variables
    private var viewModel: FavoriteListViewModelProtocol = FavoriteListViewModel()
    
    private var selectedGenreIndex: Int = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.orange
    }

}

// MARK: - Extension: Helper Methods
extension FavoriteListViewController {
    
    // MARK: - prepareScene
    private func prepareScene() {
        // Preparing NavigationItem
        self.navigationItem.title = "Favorite List"
        
        // Setting appearance of NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.PageColors.orange
        
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
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.orange
        
        // Preparing viewModel
        viewModel.delegate = self
        viewModel.fetchGenres()
        viewModel.fetchFavoriteGames()
        
        // NotificationCenter Observers
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFavoriteGames), name: NSNotification.Name(rawValue: NSNotificationNames.newFavoriteGame.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFavoriteGames), name: NSNotification.Name(rawValue: NSNotificationNames.gameDeletedFromFavorites.rawValue), object: nil)
    }
    
    // MARK: - fetchFavoriteGames
    @objc private func fetchFavoriteGames() {
        viewModel.fetchFavoriteGames()
    }
    
}

// MARK: - Extension: viewModel
extension FavoriteListViewController: FavoriteListViewModelDelegate {
    
    func preFetch() {
        indicator.startAnimating()
    }
    
    func postFetch() {
        indicator.stopAnimating()
    }
    
    func fetchFailed(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func fetchedFavoriteGames() {
        tableViewFavoriteGames.reloadData()
        collectionViewGenres.reloadData()
    }
    
    func fetchedGenres() {
        collectionViewGenres.reloadData()
    }
    
}

// MARK: - Extension: collectionViewGenres
extension FavoriteListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGenreCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell
        else { return UICollectionViewCell() }
        
        let selectedGenreColor = (selectedGenreIndex == indexPath.row) ? Constants.Colors.PageColors.green : Constants.Colors.BackgroundColors.orange
        
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
            
            cell.configureCell(genre: genreAll, genreBackgroundColor: selectedGenreColor)
        } else {
            let cellModel = viewModel.getGenre(at: (indexPath.row - 1))
            cell.configureCell(genre: cellModel!, genreBackgroundColor: selectedGenreColor)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.changeFilterGenre(filter: "all")
        } else {
            viewModel.changeFilterGenre(filter: viewModel.getGenre(at: (indexPath.row - 1))!.slug)
        }
        selectedGenreIndex = indexPath.row
        viewModel.fetchFavoriteGames()
    }
    
}

// MARK: - Extension: tableViewGames
extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavoriteGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell,
              let cellGame = viewModel.getFavoriteGame(at: indexPath.row)
        else { return UITableViewCell() }
        
        cell.configureCell(game: cellGame, gameCardColor: Constants.Colors.BackgroundColors.orange)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedGame = viewModel.getFavoriteGame(at: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: GameDetailViewController.identifier) as? GameDetailViewController else { return }
        gameDetailViewController.gameDetail = selectedGame
        self.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Unfavorite", handler: { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            if GameBoxCoreDataManager.shared.deleteFavoriteBy(gameId: self.viewModel.getFavoriteGame(at: indexPath.row)!.id) == true {
                self.viewModel.fetchFavoriteGames()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
          })
        action.image = UIImage(systemName: "heart.slash")
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
}

// MARK: - Extension: UISearchResultsUpdating
extension FavoriteListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            guard let searchText = searchController.searchBar.text else { return }
            if searchText.isEmpty {
                viewModel.changeFilterSearch(filter: "")
            } else {
                viewModel.changeFilterSearch(filter: searchText)
            }
        } else {
            viewModel.changeFilterSearch(filter: "")
        }
        tableViewFavoriteGames.reloadData()
    }
    
}
