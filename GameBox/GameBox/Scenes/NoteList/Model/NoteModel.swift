//
//  NoteModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import Foundation

// MARK: - NoteModel
struct NoteModel: Codable {
    let id: UUID
    let gameId: Int
    let note: String
    
    var noteGame: GameModel?
}
