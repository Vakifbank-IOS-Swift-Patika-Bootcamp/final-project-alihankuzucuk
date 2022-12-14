//
//  NoteListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit

// MARK: - NoteListViewController
final class NoteListViewController: BaseViewController {
    
    // MARK: - Variables
    static let floatingBtnNoteListSize: Int = 60
    let floatingButton = FloatingButton.getFloatingButton(systemImage: "plus", size: floatingBtnNoteListSize, backgroundColor: Constants.Colors.PageColors.green)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.green
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - CGFloat(NoteListViewController.floatingBtnNoteListSize) - 30,
                                      y: view.frame.size.height - CGFloat(NoteListViewController.floatingBtnNoteListSize) - 100,
                                      width: CGFloat(NoteListViewController.floatingBtnNoteListSize),
                                      height: CGFloat(NoteListViewController.floatingBtnNoteListSize))
    }
    
    // MARK: - Actions
    @objc func didFloatingButtonClicked() {
        guard let gameListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: GameListViewController.identifier) as? GameListViewController else { return }
        
        gameListViewController.gameListRedirection = .toNotePage
        
        // Creating a navigation controller with gameListViewController at the root of the navigation stack
        let gameListNavController = UINavigationController(rootViewController: gameListViewController)
        
        self.present(gameListNavController, animated:true, completion: nil)
    }

}

// MARK: - Extension: Helper Methods
extension NoteListViewController {
    
    private func prepareScene() {
        // Preparing NavigationItem
        self.navigationItem.title = "Note List"
        
        // Setting appearance of NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.PageColors.green
        
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
        self.tabBarController?.tabBar.tintColor = Constants.Colors.PageColors.green
        
        // FloatingButton
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didFloatingButtonClicked), for: .touchUpInside)
    }
    
}

// MARK: - Extension: UISearchResultsUpdating
extension NoteListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            // TODO: Removing search filter
        } else {
            // TODO: Searching with filter
        }
        // TODO: Fetching data
    }
    
}
