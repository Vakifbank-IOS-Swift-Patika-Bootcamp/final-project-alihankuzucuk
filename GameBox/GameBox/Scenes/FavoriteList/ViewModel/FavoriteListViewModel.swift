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
    func fetchedGenres()
    
}

// MARK: - FavoriteListViewModel
final class FavoriteListViewModel: FavoriteListViewModelProtocol {
    
    // MARK: Delegates
    weak var delegate: FavoriteListViewModelDelegate?
    
    // MARK: Variables
    private var favoriteGames: [FavoriteGameModel] = []
    private var genres: [CommonModel]?
    
    private var filterSearch: String = ""
    private var filterGenre: String = ""
    
    // MARK: - Methods
    
    /// This method fetches the favorite games from GameBoxCoreDataManager
    func fetchFavoriteGames() {
        favoriteGames = []
        
        let dispatchGroup = DispatchGroup()
        
        self.delegate?.preFetch()
        
        let favoriteGameList = GameBoxCoreDataManager.shared.getFavorites()
        
        if favoriteGameList.count > 0 {
            for index in 0..<(favoriteGameList.count) {
                dispatchGroup.enter()
                RawGClient.getGameDetail(gameId: Int(favoriteGameList[index].gameId)) { [weak self] detailedGame, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    guard let self = self,
                          let detailedGame = detailedGame
                    else { return }
                    
                    let favoriteGame = FavoriteGameModel(favoriteGameId: favoriteGameList[index].id!, favoriteGame: detailedGame)
                    
                    self.favoriteGames.append(favoriteGame)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [self] in
            self.delegate?.postFetch()
            self.delegate?.fetchedFavoriteGames()
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
            switch (filterSearch, filterGenre) {
                case ("",""):
                    return true
                case ("",let filteredGenre):
                    return favoriteGame.favoriteGame.genres.filter { commonModel in
                        if commonModel.slug.contains(filteredGenre) {
                            return true
                        }
                        return false
                    }.count > 0 ? true : false
                case (let filteredSearch, let filteredGenre):
                    if favoriteGame.favoriteGame.name.contains(filteredSearch) {

                        return favoriteGame.favoriteGame.genres.filter { commonModel in
                            if commonModel.slug.contains(filteredGenre) || filteredGenre == "" {
                                return true
                            }
                            return false
                        }.count > 0 ? true : false

                    }
                    return false
            }
        }.count
    }
    
    func getFavoriteGame(at index: Int) -> GameModel? {
        guard !favoriteGames.isEmpty &&
                favoriteGames.count > index &&
                index >= 0
        else { return nil }
        
        return favoriteGames.filter { favoriteGame in
            switch (filterSearch, filterGenre) {
                case ("",""):
                    return true
                case ("",let filteredGenre):
                    return favoriteGame.favoriteGame.genres.filter { commonModel in
                        if commonModel.slug.contains(filteredGenre) {
                            return true
                        }
                        return false
                    }.count > 0 ? true : false
                case (let filteredSearch, let filteredGenre):
                    if favoriteGame.favoriteGame.name.contains(filteredSearch) {

                        return favoriteGame.favoriteGame.genres.filter { commonModel in
                            if commonModel.slug.contains(filteredGenre) || filteredGenre == "" {
                                return true
                            }
                            return false
                        }.count > 0 ? true : false

                    }
                    return false
            }
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
