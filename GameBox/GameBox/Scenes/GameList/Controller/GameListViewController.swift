//
//  GameListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

// MARK: - Enums
// MARK: GameListRedirection
enum GameListRedirection {
    case toDetailPage
    case toNotePage
}

// MARK: - GameListViewController
final class GameListViewController: BaseViewController {
    
    // MARK: - Constants
    static let identifier = String(describing: GameListViewController.self)
    
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
    
    // Variables for colorizing page
    public var gameListRedirection: GameListRedirection?
    private var pageColorNavigationBar: UIColor = Constants.Colors.PageColors.blue
    private var pageColorGenreCard: UIColor = Constants.Colors.PageColors.blue
    
    // Variable for Genre categories detection
    private var selectedGenreIndex: Int = 0
    
    // Variables for PullDownMenu
    internal var pullDownMenu: UIBarButtonItem!
    private var selectedPullDownMenuActionName: String = ""
    private var selectedPullDownMenuParentPlatformActionName: String = ""
    private var selectedPullDownMenuOrderingActionName: String = ""
    
    // Variables for Local Notification
    private var localNotificationManager: LocalNotificationManagerProtocol = LocalNotificationManager()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Local Notification pushed
        localNotificationManager.scheduleLocalNotification(notificationTitle: "GameBox", notificationSubtitle: "Welcome to the game world", notificationBody: "There are hundreds of thousands of games to review. GameBox is ready for you...")
        
        prepareScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.blue
    }

}

// MARK: - Extension: Helper Methods
extension GameListViewController {
    
    private func prepareScene() {
        // Page redirection stabilized
        gameListRedirection = gameListRedirection == nil ? .toDetailPage : .toNotePage
        
        // Preparing NavigationItem
        self.navigationItem.title = "Games".localized
        
        // Setting appearance of NavigationBar
        let appearance = UINavigationBarAppearance()
        
        // Preparing Page Colors
        switch gameListRedirection {
            case .toDetailPage:
                pageColorNavigationBar = Constants.Colors.PageColors.blue
                pageColorGenreCard = Constants.Colors.BackgroundColors.blue
            case .toNotePage:
                pageColorNavigationBar = Constants.Colors.PageColors.green
                pageColorGenreCard = Constants.Colors.BackgroundColors.green
            default:
                showAlert(title: "Error", message: "An error occurred while determining target page")
                break
        }
        
        appearance.backgroundColor = pageColorNavigationBar
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Initializing Search Bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Type something to search".localized
        navigationItem.searchController = search
        
        // Prevented automatic hiding of SearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Filtering Menu
        let pullDownMenu = UIBarButtonItem(title: "",
                                           image: UIImage(named: "filter"),
                                           primaryAction: nil,
                                           menu: generatePullDownMenu())
        self.pullDownMenu = pullDownMenu
        navigationItem.rightBarButtonItem = pullDownMenu
        
        // Preparing selected TabBar
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.blue
        self.tabBarController?.tabBar.selectedItem?.title = "Games".localized
        self.tabBarController?.tabBar.items?[1].title = "Favorites".localized
        self.tabBarController?.tabBar.items?[2].title = "Notes".localized
        
        // Preparing viewModel
        viewModel.delegate = self
        viewModel.fetchGenres()
        viewModel.fetchGames()
    }
    
    private func generatePullDownMenu() -> UIMenu {
        return GameListSceneUtility.getPullDownMenu(selfObject: self)
    }
    
    // MARK: - Public Methods for PullDownMenu
    public func getSelectedPullDownActionName() -> String {
        return self.selectedPullDownMenuActionName
    }
    
    public func getSelectedPullDownOrderingActionName() -> String {
        return self.selectedPullDownMenuOrderingActionName
    }
    
    public func getSelectedPullDownParentPlatformActionName() -> String {
        return self.selectedPullDownMenuParentPlatformActionName
    }
    
    public func clearFilters() {
        selectedPullDownMenuOrderingActionName = ""
        selectedPullDownMenuParentPlatformActionName = ""
        viewModel.clearFilter()
        selectedGenreIndex = 0
        collectionViewGenres.reloadData()
        tableViewGames.setContentOffset(.zero, animated: true)
    }
    
    public func setSelectedPullDownAction(actionName: String) {
        if actionName.split(separator: ".")[1] == "ordering" {
            selectedPullDownMenuActionName = actionName
            selectedPullDownMenuOrderingActionName = actionName
        } else if actionName.split(separator: ".")[1] == "parentPlatform" {
            selectedPullDownMenuActionName = actionName
            selectedPullDownMenuParentPlatformActionName = actionName
        } else {
            selectedPullDownMenuActionName = actionName
        }
    }
    
    public func setPullDownMenuFilter(filterFromPullDown: [String: String]) {
        if selectedGenreIndex == 0 {
            viewModel.removeFilter(filterKey: "genres")
        } else {
            viewModel.addFilter(filter: ["genres": viewModel.getGenre(at: (selectedGenreIndex - 1))!.slug])
        }
        viewModel.addFilter(filter: filterFromPullDown)
    }
    
    public func pullDownFetchGames(){
        self.viewModel.fetchGames()
    }
    
    public func refreshPullDownMenu() {
        self.pullDownMenu.menu = self.generatePullDownMenu()
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
        collectionViewGenres.reloadData()
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
        
        var selectedGenreColor: UIColor
        switch gameListRedirection! {
            case .toDetailPage:
                selectedGenreColor = (selectedGenreIndex == indexPath.row) ? Constants.Colors.PageColors.green : pageColorGenreCard
            case .toNotePage:
                selectedGenreColor = (selectedGenreIndex == indexPath.row) ? Constants.Colors.PageColors.blue : pageColorGenreCard
        }
        
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
            viewModel.removeFilter(filterKey: "genres")
        } else {
            viewModel.addFilter(filter: ["genres": viewModel.getGenre(at: (indexPath.row - 1))!.slug])
        }
        selectedGenreIndex = indexPath.row
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
        
        let cellColor = gameListRedirection == .toNotePage ? Constants.Colors.BackgroundColors.gray : Constants.Colors.BackgroundColors.blue
        cell.configureCell(game: cellGame, gameCardColor: cellColor)
        
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch gameListRedirection {
            case .toNotePage:
            
                guard let addNoteViewController = storyboard?.instantiateViewController(withIdentifier: AddNoteViewController.identifier) as? AddNoteViewController else { return }

                addNoteViewController.noteModel = NoteModel(id: UUID(), gameId: selectedGame.id, note: "", noteGame: selectedGame, noteState: .addNote)
                self.navigationController?.pushViewController(addNoteViewController, animated: true)
            
            case .toDetailPage:
            
                guard let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: GameDetailViewController.identifier) as? GameDetailViewController else { return }
                
                gameDetailViewController.gameDetail = selectedGame
                self.navigationController?.pushViewController(gameDetailViewController, animated: true)
            
            default:
                showAlert(title: "Error", message: "An error occurred while determining target page")
                break
        }
        
    }
    
}

// MARK: - Extension: UISearchResultsUpdating
extension GameListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            guard let searchText = searchController.searchBar.text else { return }
            if searchText.isEmpty {
                viewModel.removeFilter(filterKey: "search")
            } else {
                viewModel.addFilter(filter: ["search" : searchText])
            }
        } else {
            viewModel.removeFilter(filterKey: "search")
        }
        viewModel.fetchGames()
    }
    
}
