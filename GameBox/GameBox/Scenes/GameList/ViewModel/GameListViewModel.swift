//
//  GameListViewModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 8.12.2022.
//

import Foundation

// MARK: - Protocols
// MARK: GameListViewModelProtocol
protocol GameListViewModelProtocol: AnyObject {
    
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
    func getGenreCount() -> Int
    func getGenre(at index: Int) -> CommonModel?
    func getGenreId(at index: Int) -> Int?
    func getGenreSlug(at index: Int) -> String?
    
    // MARK: - Filtering
    func setFilter(filter: [String:String])
    func clearFilter()
    func addFilter(filter: [String : String])
    func removeFilter(filterKey: String)
    
}

// MARK: - GameListViewModelDelegate
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
    private var genres: [CommonModel]?
    
    private var currentPage: Int = 1
    private let batchSize: Int = 30
    private var filters: [String:String] = [:]
    
    // MARK: - Methods
    
    // MARK: - Fetching Methods
    // MARK: fetchGames
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
    
    // MARK: - fetchMoreGames
    /// This method fetches the games variable with the setted filters and specific page
    /// - Parameter page: Indicates method will make a request to the which page
    func fetchMoreGames(page: Int) {
        guard self.games != nil else { return }
        
        self.delegate?.preFetch()
        
        RawGClient.getGamesInRange(page: page, pageSize: batchSize, queryFilters: filters) { [weak self] response, error in
            guard let self = self else { return }
            
            self.delegate?.postFetch()
            
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
    
    // MARK: - fetchGenres
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
    // MARK: getGameCount
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    // MARK: - getGame
    func getGame(at index: Int) -> GameModel? {
        guard let games = games else { return nil }
        guard games.count > index && index >= 0 else { return nil }
        
        return games[index]
    }
    
    // MARK: - getGameId
    func getGameId(at index: Int) -> Int? {
        guard let games = games else { return nil }
        guard games.count > index && index >= 0 else { return nil }
        
        return games[index].id
    }
    
    // MARK: - getCurrentPage
    func getCurrentPage() -> Int { currentPage }
    
    // MARK: - GenreModel Methods
    // MARK: getGenreCount
    func getGenreCount() -> Int {
        genres?.count ?? 0
    }
    
    // MARK: - getGenre
    func getGenre(at index: Int) -> CommonModel? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index]
    }
    
    // MARK: - getGenreId
    func getGenreId(at index: Int) -> Int? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index].id
    }
    
    // MARK: - getGenreSlug
    func getGenreSlug(at index: Int) -> String? {
        guard let genres = genres else { return nil }
        guard genres.count > index && index >= 0 else { return nil }
        
        return genres[index].slug
    }
    
    // MARK: - Filtering Methods
    // MARK: setFilter
    /// This method sets to filter variable which will be used while fetching
    /// - Parameter filter: Parameter array of type [Key : Value]
    func setFilter(filter: [String : String]) {
        self.filters = filter
    }
    
    // MARK: - clearFilter
    func clearFilter() {
        self.filters = [:]
    }
    
    // MARK: - addFilter
    func addFilter(filter: [String : String]) {
        if self.filters.isEmpty {
            self.filters = filter
        } else {
            filter.forEach { queryFilter in
                self.filters[queryFilter.key] = queryFilter.value
            }
        }
    }
    
    // MARK: - removeFilter
    func removeFilter(filterKey: String) {
        if !self.filters.isEmpty {
            self.filters[filterKey] = nil
        }
    }
    
}
