//
//  GameListViewModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - Protocols
protocol GameListViewModelProtocol {
    // MARK: - Delegates
    var delegate: GameListViewModelDelegate? { get set }
    
    // MARK: - Fetching
    func fetchGames()
    func fetchMoreGames(page: Int)
    func fetchGenres()
    
    // MARK: - GameModel Methods
    func getGameCount() -> Int
    func getGame(at index: Int) -> GameModel?
    func getGameId(at index: Int) -> Int?
    func getCurrentPage() -> Int
    
    // MARK: - GenreModel Methods
    func getGenre(at index: Int) -> GenreModel?
    func getGenreId(at index: Int) -> Int?
    func getGenreSlug(at index: Int) -> String?
    
    // MARK: - Filtering
    func setFilter(filter: [String:String])
    func clearFilter()
}

protocol GameListViewModelDelegate: AnyObject {
    // MARK: - Indicator
    func preFetch()
    func postFetch()
    
    // MARK: - Fetching
    func fetchFailed(error: Error)
    func fetchedGames()
    func fetchedGenres()
}

// MARK: - GameListViewModel
final class GameListViewModel: GameListViewModelProtocol {
    // MARK: - Delegates
    weak var delegate: GameListViewModelDelegate?
    
    // MARK: - Variables
    private var games: [GameModel]?
    private var genres: [GenreModel]?
    
    private var currentPage: Int = 1
    private let batchSize: Int = 30
    private var filters: [String:String] = [:]
    
    // MARK: - Fetching Methods
    /// This method fetches the games variable with the setted filters which default value is empty
    func fetchGames() {
        currentPage = 1
        self.delegate?.preFetch()
        
        RawGClient.getGamesInRange(page: currentPage, pageSize: batchSize, queryFilters: filters) { [weak self] response, error in
            guard let self = self else { return }
            
            self.delegate?.postFetch()
            
            if let error = error {
                self.delegate?.fetchFailed(error: error)
            } else {
                guard let response = response else { return }
                
                self.games = response.results
                self.delegate?.fetchedGames()
            }
        }
    }
    
    /// This method fetches the games variable with the setted filters and specific page
    /// - Parameter page: Indicates method will make a request to the which page
    func fetchMoreGames(page: Int) {
        guard self.games != nil else { return }
        
        RawGClient.getGamesInRange(page: page, pageSize: batchSize, queryFilters: filters) { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.fetchFailed(error: error)
            } else {
                guard let response = response else { return }
                
                self.currentPage = page
                self.games! += response.results!
                
                self.delegate?.fetchedGames()
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
    
    // MARK: - GameModel Methods
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> GameModel? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games?[index].gameId
    }
    
    func getCurrentPage() -> Int { currentPage }
    
    // MARK: - GenreModel Methods
    func getGenre(at index: Int) -> GenreModel? {
        genres?[index]
    }
    
    func getGenreId(at index: Int) -> Int? {
        genres?[index].genreId
    }
    
    func getGenreSlug(at index: Int) -> String? {
        genres?[index].genreSlug
    }
    
    // MARK: - Filtering
    /// This method sets to filter variable which will be used while fetching
    /// - Parameter filter: Parameter array of type [Key : Value]
    func setFilter(filter: [String : String]) {
        self.filters = filter
    }
    
    func clearFilter() {
        self.filters = [:]
    }
}
