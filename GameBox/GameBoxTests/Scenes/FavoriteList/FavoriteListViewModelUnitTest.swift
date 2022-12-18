//
//  FavoriteListViewModelUnitTest.swift
//  GameBoxTests
//
//  Created by Alihan KUZUCUK on 18.12.2022.
//

import XCTest

@testable import GameBox
final class FavoriteListViewModelUnitTest: XCTestCase {

    // MARK: - Variables
    private var viewModel: FavoriteListViewModel!
    
    // MARK: - TestExpectations
    private var fetchExpectationFavoriteListViewModel: XCTestExpectation!

    // MARK: - Test Setup
    override func setUpWithError() throws {
        viewModel = FavoriteListViewModel()
        viewModel.delegate = self
        fetchExpectationFavoriteListViewModel = expectation(description: "fetchExpectationFavoriteListViewModel")
    }
    
    // MARK: - Test Methods
    // MARK: testSaveFavoriteGame
    func testSaveFavoriteGame() throws {
        // Given
        XCTAssertEqual(viewModel.getFavoriteGameCount(), 0)
        
        // When
        GameBoxCoreDataManager.shared.saveFavoriteGame(gameId: 4397)
        viewModel.fetchFavoriteGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertTrue(GameBoxCoreDataManager.shared.checkFavoriteGameById(game: 4397))
    }
    
    // MARK: - testFetchGenres
    func testFetchGenres() throws {
        // Given
        XCTAssertEqual(viewModel.getGenreCount(), 0)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreCount(), 19)
    }
    
    // MARK: - testGetFavoriteGameCount
    func testGetFavoriteGameCount() throws {
        // Given
        XCTAssertEqual(viewModel.getFavoriteGameCount(), 0)
        
        // When
        viewModel.fetchFavoriteGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getFavoriteGameCount(), GameBoxCoreDataManager.shared.getFavorites().count)
    }
    
    // MARK: - testGetFavoriteGame
    func testGetFavoriteGame() throws {
        // Given
        XCTAssertEqual(viewModel.getFavoriteGame(at: 0)?.id, nil)
        
        // When
        GameBoxCoreDataManager.shared.saveFavoriteGame(gameId: 4397)
        viewModel.fetchFavoriteGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getFavoriteGame(at: 0)?.id, 4397)
    }
    
    // MARK: - testGetGenreCount
    func testGetGenreCount() throws {
        // Given
        XCTAssertEqual(viewModel.getGenreCount(), 0)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreCount(), 19)
    }
    
    // MARK: - testGetGenre
    func testGetGenre() throws {
        // Given
        XCTAssertEqual(viewModel.getGenre(at: 0)?.id, nil)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenre(at: 0)?.id, viewModel.getGenreId(at: 0))
    }
    
    // MARK: - testGetGenreId
    func testGetGenreId() throws {
        // Given
        XCTAssertEqual(viewModel.getGenreId(at: 0), nil)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreId(at: 0), viewModel.getGenre(at: 0)?.id)
    }
    
    // MARK: - testGetGenreSlug
    func testGetGenreSlug() throws {
        // Given
        XCTAssertEqual(viewModel.getGenreSlug(at: 0), nil)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreSlug(at: 0), viewModel.getGenre(at: 0)?.slug)
    }

}

extension FavoriteListViewModelUnitTest: FavoriteListViewModelDelegate {
    
    func preFetch() {
        
    }
    
    func postFetch() {
        
    }
    
    func fetchFailed(error: Error) {
        
    }
    
    func fetchedFavoriteGames() {
        fetchExpectationFavoriteListViewModel.fulfill()
    }
    
    func fetchedGenres() {
        fetchExpectationFavoriteListViewModel.fulfill()
    }
    
}
