//
//  NoteModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import Foundation

// MARK: - Enums
enum NoteModelState {
    case addNote, editNote, listNote
}

// MARK: - NoteModel
struct NoteModel {
    let id: UUID
    let gameId: Int
    var date: Date?
    var note: String
    
    var noteGame: GameModel?
    
    var noteState: NoteModelState
}
