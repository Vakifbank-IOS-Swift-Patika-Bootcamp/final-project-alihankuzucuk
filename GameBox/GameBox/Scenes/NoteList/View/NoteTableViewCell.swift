//
//  NoteTableViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 14.12.2022.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {

    // MARK: - Constants
    static let identifier = String(describing: NoteTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var viewNoteCellBackground: UIView!
    
    @IBOutlet private weak var lblNoteId: UILabel!
    @IBOutlet private weak var lblGameId: UILabel!
    @IBOutlet private weak var lblGameName: UILabel!
    @IBOutlet private weak var lblNoteDate: UILabel!
    @IBOutlet private weak var lblNoteHeader: UILabel!
    @IBOutlet private weak var lblNote: UILabel!
    
    func configureCell(note: NoteModel) {
        
        // Preparing View Background
        viewNoteCellBackground.round(with: .all, radius: 15)
        viewNoteCellBackground.backgroundColor = Constants.Colors.BackgroundColors.green
        
        // Preparing Labels
        ViewUtility.labelWithBoldAndNormalText(&lblNoteId, boldText: "Note Id: ", normalText: note.id.uuidString)
        ViewUtility.labelWithBoldAndNormalText(&lblGameId, boldText: "Game Id: ", normalText: String(note.gameId))
        ViewUtility.labelWithBoldAndNormalText(&lblGameName, boldText: "Game Name: ", normalText: String(note.noteGame!.name))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteDate, boldText: "Note Date: ", normalText: String(note.date!.formatString()))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteHeader, boldText: "Note:", normalText: "")
        lblNote.text = note.note
        
    }
    
}
