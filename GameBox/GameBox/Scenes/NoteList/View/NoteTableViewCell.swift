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
    @IBOutlet private weak var viewNoteCellContentBackground: UIView!
    
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
        viewNoteCellContentBackground.backgroundColor = Constants.Colors.BackgroundColors.green
        
        // Preparing Labels
        ViewUtility.labelWithBoldAndNormalText(&lblNoteId,
                                               boldText: String(format: NSLocalizedString("scene.addnote.noteid", comment: ""),"\n"),
                                               normalText: note.id.uuidString)
        ViewUtility.labelWithBoldAndNormalText(&lblGameId,
                                               boldText: String(format: NSLocalizedString("scene.addnote.gameid", comment: ""),""),
                                               normalText: String(note.gameId))
        ViewUtility.labelWithBoldAndNormalText(&lblGameName,
                                               boldText: String(format: NSLocalizedString("scene.addnote.gamename", comment: ""),""),
                                               normalText: String(note.noteGame!.name))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteDate,
                                               boldText: String(format: NSLocalizedString("scene.addnote.notedate", comment: ""),""),
                                               normalText: String(note.date!.formatString()))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteHeader, boldText: "scene.addnote.note".localized, normalText: "")
        lblNote.text = note.note
        
    }
    
}
