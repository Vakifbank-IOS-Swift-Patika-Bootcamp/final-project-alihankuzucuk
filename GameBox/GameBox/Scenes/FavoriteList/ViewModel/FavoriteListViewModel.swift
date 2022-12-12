//
//  FavoriteListViewModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 12.12.2022.
//

import Foundation

// MARK: - Protocols
// MARK: FavoriteListViewModelProtocol
protocol FavoriteListViewModelProtocol: AnyObject {
    // MARK: Delegates
    var delegate: FavoriteListViewModelDelegate? { get set }
    
    // MARK: Fetching
    func fetchFavoriteGames()
    func fetchGenres()
    
    // MARK: FavoriteGame Methods
    func getFavoriteGameCount() -> Int
    func getFavoriteGame(at index: Int) -> GameModel?
    
    // MARK: GenreModel Methods
    func getGenreCount() -> Int
    func getGenre(at index: Int) -> CommonModel?
    func getGenreId(at index: Int) -> Int?
    func getGenreSlug(at index: Int) -> String?
    
    // MARK: Filtering
    func changeFilterSearch(filter: String)
    func changeFilterGenre(filter: String)
}

// MARK: FavoriteListViewModelDelegate
protocol FavoriteListViewModelDelegate: AnyObject {
    // MARK: Indicator
    func preFetch()
    func postFetch()
    
    // MARK: Fetching
    func fetchFailed(error: Error)
    func fetchedFavoriteGames()
    func fetchGenres()
    func fetchedGenres()
    
}

// MARK: - FavoriteListViewModel
final class FavoriteListViewModel: FavoriteListViewModelProtocol {
    
    // MARK: Delegates
    weak var delegate: FavoriteListViewModelDelegate?
    
    // MARK: Variables
    private var favoriteGames: [FavoriteGameModel] = []
    private var genres: [CommonModel]?
    
    private var filterGenre: String = ""
    private var filterSearch: String = ""
    
    // MARK: - Methods
    
    /// This method fetches the favorite games from GameBoxCoreDataManager
    func fetchFavoriteGames() {
        self.delegate?.preFetch()
        
        GameBoxCoreDataManager.shared.getFavorites().forEach { favorite in
            RawGClient.getGameDetail(gameId: Int(favorite.gameId)) { [weak self, weak favorite] detailedGame, error in
                guard let self = self,
                      let favorite = favorite,
                      let detailedGame = detailedGame
                else { return }
                
                self.delegate?.postFetch()
                
                var favoriteGame = FavoriteGameModel(favoriteGameId: favorite.id!, favoriteGame: detailedGame)
                
                self.favoriteGames.append(favoriteGame)
                
                self.delegate?.fetchedFavoriteGames()
            }
        }
    }
    
    /// This method fetches the genres variable
    func fetchGenres() {
        RawGClient.getAllGenres { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.fetchFailed(error: error)
            } else {
                guard let response = response else { return }
                
                self.genres = response.results
                self.delegate?.fetchedGenres()
            }
        }
    }
    
    // MARK: - FavoriteGame Methods
    func getFavoriteGameCount() -> Int {
        return favoriteGames.filter { favoriteGame in
            if favoriteGame.favoriteGame.name.contains(filterSearch) {
                
                return favoriteGame.favoriteGame.genres.filter { commonModel in
                    if commonModel.slug == filterGenre {
                        return true
                    }
                    return false
                }.count > 0 ? true : false
                
            }
            return false
        }.count
    }
    
    func getFavoriteGame(at index: Int) -> GameModel? {
        guard !favoriteGames.isEmpty &&
                favoriteGames.count > index &&
                index >= 0
        else { return nil }
        
        return favoriteGames.filter { favoriteGame in
            if favoriteGame.favoriteGame.name.contains(filterSearch) {
                
                return favoriteGame.favoriteGame.genres.filter { commonModel in
                    if commonModel.slug == filterGenre {
                        return true
                    }
                    return false
                }.count > 0 ? true : false
                
            }
            return false
        }[index].favoriteGame
    }
    
    // MARK: - GenreModel Methods
    func getGenreCount() -> Int {
        genres?.count ?? 0
    }
    
    func getGenre(at index: Int) -> CommonModel? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index]
    }
    
    func getGenreId(at index: Int) -> Int? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index].id
    }
    
    func getGenreSlug(at index: Int) -> String? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index].slug
    }
    
    // MARK: - Filtering
    /// This method changes the filterSearch variable which will be used for favoriteGames list
    /// - Parameter filter: Value of search
    func changeFilterSearch(filter: String) {
        filterSearch = filter
    }
    
    /// This method changes the filterGenre variable which will be used for favoriteGames list
    /// - Parameter filter: Value of genre
    func changeFilterGenre(filter: String) {
        filterGenre = filter == "all" ? "" : filter
    }
    
}
