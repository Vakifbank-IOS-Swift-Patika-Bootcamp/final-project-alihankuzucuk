//
//  GameDetailSceneUtility.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit

// MARK: - Enums
// MARK: TagShowingType
enum TagShowingType {
    case all
    case between0And10
}

// MARK: - GameDetailSceneUtility
final class GameDetailSceneUtility {
    
    /// Sets parent platforms to the given label
    /// - Parameter label: Current label of you want to use
    static func setParentPlatforms(_ label: inout UILabel, game: GameModel?) {
        guard let game = game
        else {
            label.text = ""
            return
        }
        
        var parentPlatforms: String = ""
        for (index, platform) in game.parentPlatforms.enumerated() {
            parentPlatforms += (platform.platform?.name ?? "")
            if index != game.parentPlatforms.endIndex-1 {
                parentPlatforms += ", "
            }
        }
        
        ViewUtility.labelWithBoldAndNormalText(&label, boldText: "Platforms: ", normalText: parentPlatforms)
    }
    
    /// Sets game tags to the given label
    /// - Parameter label: Current label of you want to use
    static func setGameTags(_ label: inout UILabel, game: GameModel?, tagShowingType: TagShowingType) {
        guard let game = game
        else {
            label.text = ""
            return
        }
        
        var tags: String = ""
        var maximumShowedGameTags: Int = 0
        
        if game.tags.count > 0 {
            switch tagShowingType {
                case .all:
                    maximumShowedGameTags = game.tags.count
                case .between0And10:
                    maximumShowedGameTags = game.tags.count >= 10 ? 10 : game.tags.count >= 5 ? 5 : game.tags.count >= 3 ? 3 : 0
            }
        }
        
        for (index, tag) in game.tags[0..<maximumShowedGameTags].enumerated() {
            tags += tag.name
            if index != game.tags[0..<maximumShowedGameTags].endIndex-1 {
                tags += ", "
            }
        }
        
        ViewUtility.labelWithBoldAndNormalText(&label, boldText: "Tags: ", normalText: tags)
    }
    
    /// Sets genres to the given label
    /// - Parameter label: Current label of you want to use
    static func setGenres(_ label: inout UILabel, game: GameModel?) {
        guard let game = game
        else {
            label.text = ""
            return
        }
        
        var genres: String = ""
        for (index, genre) in game.genres.enumerated() {
            genres += (genre.name)
            if index != game.genres.endIndex-1 {
                genres += ", "
            }
        }
        
        ViewUtility.labelWithBoldAndNormalText(&label, boldText: "Genres: ", normalText: genres)
    }
    
}
