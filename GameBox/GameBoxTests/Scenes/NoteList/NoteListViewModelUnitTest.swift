//
//  NoteListViewModelUnitTest.swift
//  GameBoxTests
//
//  Created by Alihan KUZUCUK on 18.12.2022.
//

import XCTest

@testable import GameBox
final class NoteListViewModelUnitTest: XCTestCase {

    // MARK: - Variables
    private var viewModel: NoteListViewModel!
    
    // MARK: - TestExpectations
    private var fetchExpectationNoteListViewModel: XCTestExpectation!

    // MARK: - Test Setup
    override func setUpWithError() throws {
        viewModel = NoteListViewModel()
        viewModel.delegate = self
        fetchExpectationNoteListViewModel = expectation(description: "fetchExpectationNoteListViewModel")
    }
    
    // MARK: - Test Methods
    // MARK: testSaveNote
    func testSaveNote() throws {
        // Given
        XCTAssertEqual(viewModel.getNoteCount(), 0)
        
        // When
        GameBoxCoreDataManager.shared.saveNote(noteModel: NoteModel(id: UUID(), gameId: 4397, note: "This is a test note", noteState: .addNote))
        viewModel.fetchNotes()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getNoteCount(), GameBoxCoreDataManager.shared.getNotes().count)
    }
    
    // MARK: - testGetNoteCount
    func testGetNoteCount() throws {
        // Given
        XCTAssertEqual(viewModel.getNoteCount(), 0)
        
        // When
        viewModel.fetchNotes()
        waitForExpectations(timeout: 10)
        
        // Then
        XCTAssertEqual(viewModel.getNoteCount(), GameBoxCoreDataManager.shared.getNotes().count)
    }

}

extension NoteListViewModelUnitTest: NoteListViewModelDelegate {
    
    func preFetch() {
        
    }
    
    func postFetch() {
        
    }
    
    func fetchFailed(error: Error) {
        
    }
    
    func fetchedNotes() {
        fetchExpectationNoteListViewModel.fulfill()
    }
    
}
