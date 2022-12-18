//
//  GameListViewModelUnitTest.swift
//  GameBoxTests
//
//  Created by Alihan KUZUCUK on 17.12.2022.
//

import XCTest

final class GameListViewModelUnitTest: XCTestCase {
    
    // MARK: - Variables
    private var viewModel: GameListViewModel!
    
    // MARK: - TestExpectations
    private var fetchExpectationGameListViewModel: XCTestExpectation!

    // MARK: - Test Setup
    override func setUpWithError() throws {
        viewModel = GameListViewModel()
        viewModel.delegate = self
        fetchExpectationGameListViewModel = expectation(description: "fetchExpectationGameListViewModel")
    }
    
    // MARK: - Test Methods
    // MARK: testGetGameCount
    func testGetGameCount() throws {
        // Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        // When
        XCTAssertEqual(viewModel.getCurrentPage(), 1)
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGameCount(), 30)
    }
    
    // MARK: - testGetGame
    func testGetGame() throws {
        // Given
        XCTAssertNil(viewModel.getGame(at: 0)?.id)
        
        // When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGame(at: 0)?.id, 3498)
    }
    
    // MARK: - testGetGameId
    func testGetGameId() throws {
        // Given
        XCTAssertNil(viewModel.getGameId(at: 0))
        
        // When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGameId(at: 0), 3498)
    }
    
    // MARK: - testGetGenreId
    func testGetGenreId() throws {
        // Given
        XCTAssertNil(viewModel.getGenreId(at: 0))
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreId(at: 0), 4)
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
        XCTAssertNil(viewModel.getGenre(at: 0)?.id)
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenre(at: 0)?.id, 4)
    }
    
    // MARK: - testGetGenreSlug
    func testGetGenreSlug() throws {
        // Given
        XCTAssertNil(viewModel.getGenreSlug(at: 0))
        
        // When
        viewModel.fetchGenres()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGenreSlug(at: 0), "action")
    }
    
    // MARK: - testSetFilter
    func testSetFilter() throws {
        // Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        // When
        viewModel.clearFilter()
        viewModel.setFilter(filter: ["search" : "crysis 3"])
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGame(at: 0)?.name, "Crysis 3")
    }
    
    // MARK: - testAddFilter
    func testAddFilter() throws {
        // Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        // When
        viewModel.clearFilter()
        viewModel.setFilter(filter: ["search" : "crysis 3"])
        viewModel.addFilter(filter: ["ordering" : "-rating"])
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGame(at: 0)?.name, "The Witcher 3: Wild Hunt – Blood and Wine")
    }
    
    // MARK: - testRemoveFilter
    func testRemoveFilter() throws {
        // Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        
        // When
        viewModel.clearFilter()
        viewModel.setFilter(filter: ["search" : "crysis 3"])
        viewModel.addFilter(filter: ["ordering" : "-rating"])
        viewModel.removeFilter(filterKey: "ordering")
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getGame(at: 0)?.name, "Crysis 3")
    }

}

// MARK: - Extension - gameListViewModel
extension GameListViewModelUnitTest: GameListViewModelDelegate {
    
    func preFetch() {
        
    }
    
    func postFetch() {
        
    }
    
    func fetchFailed(error: Error) {
        
    }
    
    func fetchedGames() {
        fetchExpectationGameListViewModel.fulfill()
    }
    
    func fetchedGenres() {
        fetchExpectationGameListViewModel.fulfill()
    }
    
}
