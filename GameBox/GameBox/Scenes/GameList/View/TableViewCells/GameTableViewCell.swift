//
//  GameTableViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 10.12.2022.
//

import UIKit
import ImageSlideshow

final class GameTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: GameTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var viewBackground: UIView!
    @IBOutlet private weak var imageSlideshow: ImageSlideshow!
    @IBOutlet private weak var viewGameDetailBackground: UIView!
    
    @IBOutlet private weak var lblGameName: UILabel!
    @IBOutlet private weak var lblMetacritic: UILabel!
    @IBOutlet private weak var lblRating: UILabel!
    @IBOutlet private weak var lblPlaytime: UILabel!
    @IBOutlet private weak var lblReleaseDate: UILabel!
    @IBOutlet private weak var lblParentPlatforms: UILabel!
    @IBOutlet private weak var lblTags: UILabel!
    
    // MARK: - Methods
    
    // MARK: Configuring Cell
    func configureCell(game: GameModel) {
        // MARK: Preparing Background
        viewBackground.round(with: RoundType.all, radius: 30)
        
        // MARK: Preparing Slideshow
        prepareImageInputs(gameId: game.gameId)
        imageSlideshow.slideshowInterval = 3
        imageSlideshow.contentScaleMode = UIViewContentMode.center
        
        // MARK: Preparing Card Detail
        switch game.gameId%2 {
            case 0:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
            case 1:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
            default:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
                break
        }
        lblGameName.text = game.gameName
        
        labelRatingWithImageAttachment(&lblMetacritic,
                                       ratingImageIconType: .resourceImage,
                                       imageName: "metacritic",
                                       text: " \(game.gameMetacritic)",
                                       textColor: UIColor.white)
        
        labelRatingWithImageAttachment(&lblRating,
                                       ratingImageIconType: .systemImage,
                                       imageName: "star.fill",
                                       text: "\(game.gameRating) / \(game.gameRatingTop) (\(game.gameRatingsCount))",
                                       textColor: UIColor.yellow)
        
        lblPlaytime.attributedText = propertyText(boldText: "Playtime: ", normalText: "\(String(game.gamePlaytime)) Hours")
        lblReleaseDate.attributedText = propertyText(boldText: "Release Date: ", normalText: "\(String(game.gameReleaseDate))")
        
        var parentPlatforms: String = ""
        for (index, platform) in game.gameParentPlatforms.enumerated() {
            parentPlatforms += (platform.platform?.name ?? "")
            if index != game.gameParentPlatforms.endIndex-1 {
                parentPlatforms += ", "
            }
        }
        
        lblParentPlatforms.attributedText = propertyText(boldText: "Platforms: ", normalText: parentPlatforms)
        
        var tags: String = ""
        for (index, tag) in game.gameTags[0..<10].enumerated() {
            tags += tag.name
            if index != game.gameTags[0..<10].endIndex-1 {
                tags += ", "
            }
        }
        
        lblTags.attributedText = propertyText(boldText: "Tags: ", normalText: tags)
    }
    
    // MARK: - Setting Image Inputs
    private func prepareImageInputs(gameId: Int) {
        RawGClient.getGameScreenshots(gameId: gameId) { [weak self] screenshots, error in
            guard let screenshots = screenshots,
                  let self = self
            else { return }
            
            var imageSlideshowInputSource: [InputSource] = []
            
            screenshots.results?.forEach({ screenshot in
                imageSlideshowInputSource.append(AlamofireSource(url: URL(string: screenshot.screenshotImage)!))
            })
            
            self.imageSlideshow.setImageInputs(imageSlideshowInputSource)
        }
    }
    
    // MARK: - Combining bold text and normal text at once
    private func propertyText(boldText: String, normalText: String) -> NSMutableAttributedString {
        let attributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        let boldString = NSMutableAttributedString(string: boldText, attributes: attributes)
        let normalString = NSMutableAttributedString(string: normalText)
        let resultString = NSMutableAttributedString()
        
        resultString.append(boldString)
        resultString.append(normalString)
        
        return resultString
    }
    
    // MARK: - Creating the rating label
    private func labelRatingWithImageAttachment(_ label: inout UILabel, ratingImageIconType: RatingImageIconType, imageName: String, text: String, textColor: UIColor) {
        let completeText = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        
        switch ratingImageIconType {
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

// MARK: - Enum: RatingImageIconType
enum RatingImageIconType {
    case systemImage
    case resourceImage
}
