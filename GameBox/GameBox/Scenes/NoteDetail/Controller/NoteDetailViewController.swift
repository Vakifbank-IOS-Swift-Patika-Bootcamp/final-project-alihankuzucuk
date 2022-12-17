//
//  NoteDetailViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 16.12.2022.
//

import UIKit

// MARK: NoteDetailViewController
final class NoteDetailViewController: BaseViewController {
    
    // MARK: - Constants
    static let identifier = String(describing: NoteDetailViewController.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var lblNoteId: UILabel!
    @IBOutlet private weak var lblGameId: UILabel!
    @IBOutlet private weak var lblGameName: UILabel!
    @IBOutlet private weak var lblNoteDate: UILabel!
    @IBOutlet private weak var lblNoteHeader: UILabel!
    @IBOutlet private weak var lblNote: UILabel!
    @IBOutlet private weak var viewNoteDetailBackground: UIView!
    
    // MARK: - Variables
    public var noteModel: NoteModel?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }

}

// MARK: - Extension: Helper Methods
extension NoteDetailViewController {
    
    // MARK: - prepareScene
    private func prepareScene() {
        checkNoteDetail()
        
        viewNoteDetailBackground.backgroundColor = Constants.Colors.BackgroundColors.green
        // Setting Labels
        ViewUtility.labelWithBoldAndNormalText(&lblNoteId,
                                               boldText: String(format: NSLocalizedString("scene.addnote.noteid", comment: ""),"\n"),
                                               normalText: noteModel!.id.uuidString)
        ViewUtility.labelWithBoldAndNormalText(&lblGameId,
                                               boldText: String(format: NSLocalizedString("scene.addnote.gameid", comment: ""),"\n"),
                                               normalText: String(noteModel!.gameId))
        ViewUtility.labelWithBoldAndNormalText(&lblGameName,
                                               boldText: String(format: NSLocalizedString("scene.addnote.gamename", comment: ""),"\n"),
                                               normalText: String(noteModel!.noteGame!.name))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteDate,
                                               boldText: String(format: NSLocalizedString("scene.addnote.notedate", comment: ""),"\n"),
                                               normalText: noteModel!.date!.formatString())
        lblNoteHeader.text = "scene.addnote.note".localized
        lblNote.text = noteModel?.note
    }
    
    // MARK: - checkNoteDetail
    private func checkNoteDetail() {
        // Check model is valid or not
        guard noteModel != nil &&
                noteModel?.noteGame != nil &&
                noteModel?.noteState == .listNote
        else {
            showAlert(title: "Error".localized, message: "error.unknown".localized, btnOkHandler: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            return
        }
    }
    
}
