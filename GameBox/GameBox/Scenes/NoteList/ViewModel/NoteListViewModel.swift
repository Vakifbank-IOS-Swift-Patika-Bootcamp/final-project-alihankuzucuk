//
//  NoteListViewModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import Foundation

// MARK: - Protocols
// MARK: - NoteListViewModel
protocol NoteListViewModelProtocol: AnyObject {
    
    // MARK: Delegates
    var delegate: NoteListViewModelDelegate? { get set }
    
    // MARK: Fetching
    func fetchNotes()
    
    // MARK: Note Methods
    func getNoteCount() -> Int
    func getNote(at index: Int) -> NoteModel?
    
    // MARK: Filtering
    func changeFilterSearch(filter: String)
    
}

// MARK: - NoteListViewModelDelegate
protocol NoteListViewModelDelegate: AnyObject {
    
    // MARK: Indicator
    func preFetch()
    func postFetch()
    
    // MARK: Fetching
    func fetchFailed(error: Error)
    func fetchedNotes()
    
}

// MARK: - NoteListViewModel
final class NoteListViewModel: NoteListViewModelProtocol {
    
    // MARK: - Delegates
    weak var delegate: NoteListViewModelDelegate?
    
    // MARK: - Variables
    private var notes: [NoteModel] = []
    
    private var filterSearch: String = ""
    
    // MARK: - Methods
    
    // MARK: - Fetching Methods
    // MARK: fetchNotes
    func fetchNotes() {
        notes = []
        
        let dispatchGroup = DispatchGroup()
        
        self.delegate?.preFetch()
        
        let noteList = GameBoxCoreDataManager.shared.getNotes()
        
        if noteList.count > 0 {
            for index in 0..<(noteList.count) {
                dispatchGroup.enter()
                RawGClient.getGameDetail(gameId: Int(noteList[index].gameId)) { [weak self] detailedGame, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    guard let self = self,
                          let detailedGame = detailedGame
                    else { return }
                    
                    let note = NoteModel(id: noteList[index].id!, gameId: Int(noteList[index].gameId), date: noteList[index].date!, note: noteList[index].note!, noteGame: detailedGame, noteState: .listNote)
                    
                    self.notes.append(note)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.postFetch()
            self.delegate?.fetchedNotes()
        }
    }
    
    // MARK: - Note Methods
    // MARK: getNoteCount
    func getNoteCount() -> Int {
        return notes.filter { note in
            if filterSearch == "" {
                return true
            }
            return note.note.lowercased().contains(filterSearch.lowercased()) ? true : false
        }.count
    }
    
    // MARK: - getNote
    func getNote(at index: Int) -> NoteModel? {
        guard !notes.isEmpty &&
                notes.count > index &&
                index >= 0
        else { return nil }
        
        return notes.filter { note in
            if filterSearch == "" {
                return true
            }
            return note.note.lowercased().contains(filterSearch.lowercased()) ? true : false
        }[index]
    }
    
    // MARK: - Filtering Methods
    // MARK: changeFilterSearch
    func changeFilterSearch(filter: String) {
        filterSearch = filter
    }
    
}
