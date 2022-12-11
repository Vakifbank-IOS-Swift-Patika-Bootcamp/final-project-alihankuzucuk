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
    func configureCell(gameDetail: GameDetailViewModel) {
        // MARK: Preparing Background
        viewBackground.round(with: RoundType.all, radius: 30)
        
        // MARK: Preparing Slideshow
        gameDetail.setImageInputs(&imageSlideshow, gameId: gameDetail.game!.id)
        
        // MARK: Preparing Card Detail
        switch gameDetail.game!.id%2 {
            case 0:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
            case 1:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
            default:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
                break
        }
        lblGameName.text = gameDetail.game!.name
        
        gameDetail.labelWithImageAttachment(&lblMetacritic, imageIconType: .resourceImage, imageName: "metacritic", text: " \(gameDetail.game!.metacritic)", textColor: UIColor.white)
        
        gameDetail.labelWithImageAttachment(&lblRating, imageIconType: .systemImage, imageName: "star.fill", text: "\(gameDetail.game!.rating) / \(gameDetail.game!.ratingTop) (\(gameDetail.game!.ratingsCount))", textColor: UIColor.yellow)
        
        gameDetail.labelWithBoldAndNormalText(&lblPlaytime, boldText: "Playtime: ", normalText: "\(String(gameDetail.game!.playtime)) Hours")
        gameDetail.labelWithBoldAndNormalText(&lblReleaseDate, boldText: "Release Date: ", normalText: "\(String(gameDetail.game!.releaseDate))")
        
        gameDetail.setParentPlatforms(&lblParentPlatforms)
        gameDetail.setGameTags(&lblTags, tagShowingType: .between0And10)
    }
    
}
