//
//  GameBoxCoreDataManager.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 12.12.2022.
//

import UIKit
import CoreData

// MARK: - Protocols
// MARK: GameBoxCoreDataProtocol
protocol GameBoxCoreDataProtocol {
    static var shared: GameBoxCoreDataManager { get }
    
    // MARK: - Favorites Entity Methods
    func saveFavoriteGame(gameId: Int) -> Bool
    func getFavorites() -> [Favorites]
    func deleteFavoriteBy(gameId: Int) -> Bool
    func checkFavoriteGameById(game gameId: Int) -> Bool
    
    // MARK: - Notes Entity Methods
    func saveNote(noteModel: NoteModel) -> Bool
    func getNotes() -> [Notes]
    func deleteNoteBy(id noteId: UUID) -> Bool
}

// MARK: - Enums
// MARK: GameBoxCoreDataKeys
struct GameBoxCoreDataKeys {
    enum Entities: String {
        case favorites = "Favorites"
        case notes = "Notes"
    }
    
    enum FavoritesDataKeys: String {
        case id, gameId
    }
    
    enum NotesDataKeys: String {
        case id, gameId, note, date
    }
}

// MARK: - GameBoxCoreDataManager
final class GameBoxCoreDataManager: GameBoxCoreDataProtocol {
    
    // MARK: - Variables
    static let shared = GameBoxCoreDataManager()
    private let managedContext: NSManagedObjectContext!
        
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Methods
    @discardableResult
    func saveFavoriteGame(gameId: Int) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: GameBoxCoreDataKeys.Entities.favorites.rawValue, in: managedContext)!
        
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        favorite.setValue(UUID(), forKey: GameBoxCoreDataKeys.FavoritesDataKeys.id.rawValue)
        favorite.setValue(gameId, forKeyPath: GameBoxCoreDataKeys.FavoritesDataKeys.gameId.rawValue)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    func getFavorites() -> [Favorites] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GameBoxCoreDataKeys.Entities.favorites.rawValue)
        do {
            let favorites = try managedContext.fetch(fetchRequest)
            return favorites as! [Favorites]
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return []
    }
    
    @discardableResult
    func deleteFavoriteBy(gameId: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GameBoxCoreDataKeys.Entities.favorites.rawValue)
        fetchRequest.predicate = NSPredicate(format: "gameId = %@", String(gameId))
        
        fetchRequest.returnsObjectsAsFaults = false // It provides speed when reading large data
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                managedContext.delete(result)

                do  {
                    try managedContext.save()
                    return true
                } catch {
                    print("Could not save. \(error)")
                }
                break
            }
        } catch {
            print("Could not delete. \(error)")
        }
        
        return false
    }
    
    func checkFavoriteGameById(game gameId: Int) -> Bool {
        guard getFavorites() != [] else { return false }
        var isFavorite: Bool = false
        
        getFavorites().forEach { favorite in
            if favorite.gameId == gameId {
                isFavorite = true
            }
        }
        
        return isFavorite
    }
    
    @discardableResult
    func saveNote(noteModel: NoteModel) -> Bool {
        guard noteModel.date != nil &&
                noteModel.noteState == .addNote
        else { return false }
        
        let entity = NSEntityDescription.entity(forEntityName: GameBoxCoreDataKeys.Entities.notes.rawValue, in: managedContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(noteModel.id, forKey: GameBoxCoreDataKeys.NotesDataKeys.id.rawValue)
        note.setValue(noteModel.gameId, forKeyPath: GameBoxCoreDataKeys.NotesDataKeys.gameId.rawValue)
        note.setValue(noteModel.note, forKeyPath: GameBoxCoreDataKeys.NotesDataKeys.note.rawValue)
        note.setValue(noteModel.date, forKeyPath: GameBoxCoreDataKeys.NotesDataKeys.date.rawValue)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    func getNotes() -> [Notes] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: GameBoxCoreDataKeys.Entities.notes.rawValue)
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Notes]
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return []
    }
    
    @discardableResult
    func deleteNoteBy(id noteId: UUID) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GameBoxCoreDataKeys.Entities.notes.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %@", noteId.uuidString)
        
        fetchRequest.returnsObjectsAsFaults = false // It provides speed when reading large data
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                managedContext.delete(result)

                do  {
                    try managedContext.save()
                    return true
                } catch {
                    print("Could not save. \(error)")
                }
                break
            }
        } catch {
            print("Could not delete. \(error)")
        }
        
        return false
    }
    
}
