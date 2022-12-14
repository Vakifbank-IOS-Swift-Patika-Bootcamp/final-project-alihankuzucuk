//
//  AddNoteViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 14.12.2022.
//

import UIKit

final class AddNoteViewController: BaseViewController {
    
    // MARK: - Constants
    static let identifier = String(describing: AddNoteViewController.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var lblNoteId: UILabel!
    @IBOutlet private weak var lblGameId: UILabel!
    @IBOutlet private weak var lblGameName: UILabel!
    @IBOutlet private weak var lblNoteDate: UILabel!
    @IBOutlet private weak var lblNoteHeader: UILabel!
    @IBOutlet private weak var txtFldNote: UITextField!
    @IBOutlet private weak var btnSaveNote: UIButton!
    
    // MARK: - Variables
    public var noteModel: NoteModel?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }

    // MARK: - Actions
    @IBAction func btnSaveNoteClicked(_ sender: Any) {
        checkNoteDetail()
        
        // Check for user input is valid or not
        guard let noteText = txtFldNote.text
        else {
            showAlert(title: "Error", message: "Your note couldn't save")
            return
        }
        
        // Operation is performed according to the note status
        switch noteModel!.noteState {
            case .addNote:
                noteModel!.date = Date().format()
                noteModel!.note = noteText
                if GameBoxCoreDataManager.shared.saveNote(noteModel: noteModel!) == true {
                    // Closing presented AddNoteViewController because new note is saved
                    showAlert(title: "Add Note", message: "Your new note has been saved") { [weak self] _ in
                        guard let self = self else { return }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationNames.newNote.rawValue), object: nil)
                        self.closePresentSheet();
                    }
                }
            case .editNote:
                noteModel!.date = Date().format()
                noteModel!.note = noteText
                // TODO: Note will be edited here
            case .listNote:
                closePresentSheet()
        }
        
    }
    
}

// MARK: - Extension: Helper Methods
extension AddNoteViewController {
    
    private func prepareScene() {
        checkNoteDetail()
        
        // Preparing NavigationItem
        switch noteModel!.noteState {
            case .addNote:
                self.navigationItem.title = "Add Note"
                btnSaveNote.setTitle("Add Note", for: .normal)
            case .editNote:
                self.navigationItem.title = "Edit Note"
                btnSaveNote.setTitle("Edit Note", for: .normal)
                txtFldNote.text = noteModel!.note
            case .listNote:
                closePresentSheet()
        }
        
        // Setting appearance of NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colors.PageColors.green
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Setting Labels
        ViewUtility.labelWithBoldAndNormalText(&lblNoteId, boldText: "Note Id: ", normalText: noteModel!.id.uuidString)
        ViewUtility.labelWithBoldAndNormalText(&lblGameId, boldText: "Game Id: ", normalText: String(noteModel!.gameId))
        ViewUtility.labelWithBoldAndNormalText(&lblGameName, boldText: "Game Name: ", normalText: String(noteModel!.noteGame!.name))
        ViewUtility.labelWithBoldAndNormalText(&lblNoteDate, boldText: "Note Date: ", normalText: Date().formatString())
    }
    
    private func checkNoteDetail() {
        // Check model is valid or not
        guard noteModel != nil &&
                noteModel?.noteGame != nil &&
                noteModel?.noteState != .listNote
        else {
            showAlert(title: "Error", message: "An error occured while saving your note", btnOkHandler: { [weak self] _ in
                guard let self = self else { return }
                self.closePresentSheet();
            })
            return
        }
    }
    
    private func closePresentSheet() {
        self.dismiss(animated: true)
    }
    
}
