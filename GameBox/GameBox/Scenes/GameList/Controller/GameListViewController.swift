//
//  GameListViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

final class GameListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionViewGenres: UICollectionView!
    
    // MARK: - Variables
    private var viewModel: GameListViewModelProtocol = GameListViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
    }

}

// MARK: - Extension: Helper Methods
extension GameListViewController {
    
    private func prepareScreen() {
        // MARK: - Preparing NavigationItem
        self.navigationItem.title = "Games"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // MARK: - Registering collectionViewGenres cells
        collectionViewGenres.register(UINib(nibName: GenreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        // MARK: - Preparing viewModel
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
        
    }
    
    func fetchedGenres() {
        // MARK: - Preparing collectionViewGenres
        collectionViewGenres.delegate = self
        collectionViewGenres.dataSource = self
    }
    
}

// MARK: - Extension: collectionViewGenres
extension GameListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGenreCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
        if indexPath.row == 0 {
            // MARK: - Initializing "All" as a genre
            let genreAllJson = """
            {
                "id": 0,
                "name": "All",
                "slug": "all"
            }
            """

            let genreAll = try! JSONDecoder().decode(GenreModel.self, from: Data(genreAllJson.utf8))
            
            cell.configureCell(genre: genreAll)
        } else {
            cell.configureCell(genre: viewModel.getGenre(at: indexPath.row - 1)!)
        }
        
        return cell
    }
    
}
