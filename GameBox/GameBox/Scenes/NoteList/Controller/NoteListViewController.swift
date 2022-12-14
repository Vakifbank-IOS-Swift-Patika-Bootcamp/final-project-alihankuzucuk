//
//  NoteListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit

// MARK: - NoteListViewController
final class NoteListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableViewNotes: UITableView! {
        didSet {
            tableViewNotes.delegate = self
            tableViewNotes.dataSource = self

            // MARK: Registering tableViewNotes cells
            tableViewNotes.register(UINib(nibName: NoteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoteTableViewCell.identifier)

            // MARK: Automatic Dimension
            tableViewNotes.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    // MARK: - Variables
    private var viewModel: NoteListViewModelProtocol = NoteListViewModel()
    
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
        
        // Preparing viewModel
        viewModel.delegate = self
        viewModel.fetchNotes()
        
        // NotificationCenter Observers
        NotificationCenter.default.addObserver(self, selector: #selector(fetchNotes), name: NSNotification.Name(rawValue: NSNotificationNames.newNote.rawValue), object: nil)
    }
    
    @objc private func fetchNotes() {
        viewModel.fetchNotes()
    }
    
}

// MARK: - Extension: viewModel
extension NoteListViewController: NoteListViewModelDelegate {

    func preFetch() {
        indicator.startAnimating()
    }

    func postFetch() {
        indicator.stopAnimating()
    }

    func fetchFailed(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }

    func fetchedNotes() {
        tableViewNotes.reloadData()
    }

}

// MARK: - Extension: tableViewNotes
extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNoteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell,
              let cellNote = viewModel.getNote(at: indexPath.row)
        else { return UITableViewCell() }

        cell.configureCell(note: cellNote)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedNote = viewModel.getNote(at: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let editNoteViewController = storyboard?.instantiateViewController(withIdentifier: AddNoteViewController.identifier) as? AddNoteViewController else { return }

        editNoteViewController.noteModel = NoteModel(id: selectedNote.id, gameId: selectedNote.gameId, note: selectedNote.note, noteGame: selectedNote.noteGame, noteState: .editNote)
        let editNoteNavController = UINavigationController(rootViewController: editNoteViewController)
        self.present(editNoteNavController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete", handler: { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            if GameBoxCoreDataManager.shared.deleteNoteBy(id: self.viewModel.getNote(at: indexPath.row)!.id) == true {
                self.viewModel.fetchNotes()
                completionHandler(true)
            } else {
                completionHandler(false)
            }
          })
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
}

// MARK: - Extension: UISearchResultsUpdating
extension NoteListViewController: UISearchResultsUpdating {
    
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
        tableViewNotes.reloadData()
    }
    
}
