//
//  GameDetailViewModel.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 11.12.2022.
//

import UIKit
import ImageSlideshow

// MARK: - Protocols
// MARK: GameDetailViewModelProtocol
protocol GameDetailViewModelProtocol {
    // MARK: Variables
    var game: GameModel? { get set }
    
    // MARK: Methods
    // Methods with Specific Type
    func setImageInputs(_ imageSlideshow: inout ImageSlideshow, gameId: Int)
    func setParentPlatforms(_ label: inout UILabel)
    func setGameTags(_ label: inout UILabel, tagShowingType: TagShowingType)
    func setGenres(_ label: inout UILabel)
    
    // Methods with Dynamic Type
    func labelWithBoldAndNormalText(_ label: inout UILabel, boldText: String, normalText: String)
    func labelWithImageAttachment(_ label: inout UILabel, imageIconType: ImageIconType, imageName: String, text: String, textColor: UIColor)
}

// MARK: - Enums
// MARK: ImageIconType
enum ImageIconType {
    case systemImage
    case resourceImage
}

enum TagShowingType {
    case all
    case between0And10
}

// MARK: - GameDetailViewModel
final class GameDetailViewModel: GameDetailViewModelProtocol {
    // MARK: Variables
    var game: GameModel?
    
    // MARK: Methods
    /// Sets Image Inputs to the given imageSlideshow
    /// - Parameters:
    ///   - imageSlideshow: Current imageSlideshow of you want to use
    ///   - gameId: Id of the game which game's screenshot will be showed
    func setImageInputs(_ imageSlideshow: inout ImageSlideshow, gameId: Int) {
        RawGClient.getGameScreenshots(gameId: gameId) { [weak imageSlideshow] screenshots, error in
            guard let screenshots = screenshots else { return }
            
            var imageSlideshowInputSource: [InputSource] = []
            
            screenshots.results?.forEach({ screenshot in
                imageSlideshowInputSource.append(AlamofireSource(url: URL(string: screenshot.image)!))
            })
            
            imageSlideshow!.setImageInputs(imageSlideshowInputSource)
            imageSlideshow!.slideshowInterval = 3
            imageSlideshow!.contentScaleMode = UIViewContentMode.center
        }
    }
    
    /// Sets parent platforms to the given label
    /// - Parameter label: Current label of you want to use
    func setParentPlatforms(_ label: inout UILabel) {
        guard let game = self.game
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
        
        self.labelWithBoldAndNormalText(&label, boldText: "Platforms: ", normalText: parentPlatforms)
    }
    
    /// Sets game tags to the given label
    /// - Parameter label: Current label of you want to use
    func setGameTags(_ label: inout UILabel, tagShowingType: TagShowingType) {
        guard let game = self.game
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
        
        self.labelWithBoldAndNormalText(&label, boldText: "Tags: ", normalText: tags)
    }
    
    /// Sets genres to the given label
    /// - Parameter label: Current label of you want to use
    func setGenres(_ label: inout UILabel) {
        guard let game = self.game
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
        
        self.labelWithBoldAndNormalText(&label, boldText: "Genres: ", normalText: genres)
    }
    
    /// Combines bold text and normal text at once for properties
    /// - Parameters:
    ///   - label: Current label of you want to use
    ///   - boldText: Bold text
    ///   - normalText: Normal text
    func labelWithBoldAndNormalText(_ label: inout UILabel, boldText: String, normalText: String) {
        let attributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let boldString = NSMutableAttributedString(string: boldText, attributes: attributes)
        let normalString = NSMutableAttributedString(string: normalText)
        let resultString = NSMutableAttributedString()
        
        resultString.append(boldString)
        resultString.append(normalString)
        
        label.attributedText = resultString
    }
    
    /// Creates label with image attachment
    /// - Parameters:
    ///   - label: Current label of you want to use
    ///   - imageIconType: Type of where the code will search image
    ///   - imageName: Name of image
    ///   - text: Text of label
    ///   - textColor: Color of text
    func labelWithImageAttachment(_ label: inout UILabel, imageIconType: ImageIconType, imageName: String, text: String, textColor: UIColor) {
        let completeText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        
        switch imageIconType {
            case .systemImage:
                imageAttachment.image = UIImage(systemName: imageName)?.withTintColor(textColor)
            case .resourceImage:
                imageAttachment.image = UIImage(named: imageName)
        }
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 30, height: 30)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        completeText.append(attachmentString)
        
        let textAfterIconAttributes = [NSAttributedString.Key.foregroundColor : textColor,
                                       NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let textAfterIcon = NSAttributedString(string: text, attributes: textAfterIconAttributes)
        
        completeText.append(textAfterIcon)
        
        label.textAlignment = .center
        label.attributedText = completeText
    }
}
