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
    func configureCell(game: GameModel, gameCardColor: UIColor) {
        // Preparing Background
        viewBackground.round(with: RoundType.all, radius: 30)
        
        // Preparing Slideshow
        ViewUtility.setImageInputs(&imageSlideshow, gameId: game.id)
        
        // Preparing Card Detail
        viewGameDetailBackground.backgroundColor = gameCardColor
        
        lblGameName.text = game.name
        
        ViewUtility.labelWithImageAttachment(&lblMetacritic, imageIconType: .resourceImage, imageName: "metacritic", text: " \(game.metacritic)", textColor: UIColor.white)
        
        ViewUtility.labelWithImageAttachment(&lblRating, imageIconType: .systemImage, imageName: "star.fill", text: "\(game.rating) / \(game.ratingTop) (\(game.ratingsCount))", textColor: UIColor.yellow)
        
        ViewUtility.labelWithBoldAndNormalText(&lblPlaytime, boldText: "Playtime: ", normalText: "\(String(game.playtime)) Hours")
        ViewUtility.labelWithBoldAndNormalText(&lblReleaseDate, boldText: "Release Date: ", normalText: "\(String(game.releaseDate))")
        
        GameDetailSceneUtility.setParentPlatforms(&lblParentPlatforms, game: game)
        GameDetailSceneUtility.setGameTags(&lblTags, game: game, tagShowingType: .between0And10)
    }
    
    override func prepareForReuse() {
        // imageSlideshow pictures have been temporarily deleted
        imageSlideshow.setImageInputs([])
    }
    
}
