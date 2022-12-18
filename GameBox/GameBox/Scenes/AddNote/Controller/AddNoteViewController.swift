//
//  AddNoteViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 14.12.2022.
//

import UIKit

// MARK: AddNoteViewController
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
        guard let noteText = txtFldNote.text,
                var noteModel = noteModel
        else {
            showAlert(title: "Error".localized, message: "Your note couldn't save".localized)
            return
        }
        
        guard !noteText.isEmpty else {
            showAlert(title: "Warning".localized, message: "Please fill the required fields".localized)
            return
        }
        
        // Operation is performed according to the note status
        switch noteModel.noteState {
            case .addNote:
                noteModel.date = Date().format()
                noteModel.note = noteText
                if GameBoxCoreDataManager.shared.saveNote(noteModel: noteModel) {
                    // Closing presented AddNoteViewController because new note is saved
                    showAlert(title: "Add Note".localized, message: "Your new note has been saved".localized) { [weak self] _ in
                        guard let self = self else { return }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationNames.newNote.rawValue), object: nil)
                        self.closePresentSheet();
                    }
                }
            case .editNote:
                if GameBoxCoreDataManager.shared.updateNoteBy(id: noteModel.id, updatedNote: noteText, updatedDate: Date().format()) {
                    // Closing presented AddNoteViewController because note is successfully edited
                    showAlert(title: "Edit Note".localized, message: "Your note successfully updated".localized) { [weak self] _ in
                        guard let self = self else { return }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationNames.noteUpdated.rawValue), object: nil)
                        self.closePresentSheet();
                    }
                }
            case .listNote:
                closePresentSheet()
        }
        
    }
    
}

// MARK: - Extension: Helper Methods
extension AddNoteViewController {
    
    // MARK: - prepareScene
    private func prepareScene() {
        checkNoteDetail()
        
        // Preparing NavigationItem
        switch noteModel!.noteState {
            case .addNote:
            self.navigationItem.title = "Add Note".localized
                btnSaveNote.setTitle("Add Note".localized, for: .normal)
            case .editNote:
            self.navigationItem.title = "Edit Note".localized
                btnSaveNote.setTitle("Edit Note".localized, for: .normal)
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
                                               normalText: Date().formatString())
        lblNoteHeader.text = "scene.addnote.note".localized
        txtFldNote.placeholder = "scene.addnote.typenote".localized
        
        // We are giving gestureRecognizer to the view because the keyboard will be closed no matter where is clicked except the keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - checkNoteDetail
    private func checkNoteDetail() {
        // Check model is valid or not
        guard noteModel != nil &&
                noteModel?.noteGame != nil &&
                noteModel?.noteState != .listNote
        else {
            showAlert(title: "Error".localized, message: "An error occured while saving your note".localized, btnOkHandler: { [weak self] _ in
                guard let self = self else { return }
                self.closePresentSheet();
            })
            return
        }
    }
    
    // MARK: - closePresentSheet
    private func closePresentSheet() {
        self.dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
