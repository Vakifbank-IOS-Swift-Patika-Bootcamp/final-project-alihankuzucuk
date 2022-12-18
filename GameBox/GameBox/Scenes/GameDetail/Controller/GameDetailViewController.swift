//
//  GameDetailViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 11.12.2022.
//

import UIKit
import ImageSlideshow

// MARK: - GameDetailViewController
final class GameDetailViewController: BaseViewController {
    
    // MARK: - Constants
    static let identifier = String(describing: GameDetailViewController.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var viewGameDetailBackground: UIView!
    @IBOutlet private weak var imageSlideshow: ImageSlideshow!
    
    @IBOutlet private weak var lblGameName: UILabel!
    @IBOutlet private weak var lblMetacritic: UILabel!
    @IBOutlet private weak var lblRating: UILabel!
    @IBOutlet private weak var lblPlaytime: UILabel!
    @IBOutlet private weak var lblReleaseDate: UILabel!
    @IBOutlet private weak var lblParentPlatforms: UILabel!
    @IBOutlet private weak var lblTags: UILabel!
    @IBOutlet private weak var lblGenres: UILabel!
    @IBOutlet private weak var lblAgeRating: UILabel!
    @IBOutlet private weak var lblDescriptionHeader: UILabel!
    @IBOutlet private weak var lblDescriptionText: UILabel!
    
    @IBOutlet private weak var btnGoToGameWebsite: UIButton!
    
    // MARK: - Variables
    public var gameDetail: GameModel?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScene()
    }
    
    // MARK: - Actions
    
    // MARK: - btnGoToGameWebsiteClicked
    @IBAction func btnGoToGameWebsiteClicked(_ sender: Any) {
        RawGClient.getGameDetail(gameId: gameDetail!.id) { detailedGame, error in
            if let url = URL(string: detailedGame?.website ?? ""), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
        }
    }
    
    // MARK: - rightBarBtnFavoriteClicked
    @objc func rightBarBtnFavoriteClicked() {
        switch (GameBoxCoreDataManager.shared.checkFavoriteGameById(game: gameDetail!.id)) {
            case true:
                if GameBoxCoreDataManager.shared.deleteFavoriteBy(gameId: gameDetail!.id) == true {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationNames.gameDeletedFromFavorites.rawValue), object: nil)
                    setRightBarBtnFavoriteImage()
                    showAlert(title: "Favorites".localized, message: String(format: NSLocalizedString("messages.unfavoriteGame", comment: ""),"\(gameDetail!.name)"))
                }
            case false:
                if GameBoxCoreDataManager.shared.saveFavoriteGame(gameId: gameDetail!.id) == true {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationNames.newFavoriteGame.rawValue), object: nil)
                    setRightBarBtnFavoriteImage()
                    showAlert(title: "Favorites".localized, message: String(format: NSLocalizedString("messages.newFavoriteGame", comment: ""), "\(gameDetail!.name)"))
                }
        }
    }
    
}

// MARK: - Extension: Helper Methods
extension GameDetailViewController {
    
    // MARK: - prepareScene
    private func prepareScene() {
        // Preparing NavigationItem
        self.navigationItem.title = "Game Detail".localized
        
        setRightBarBtnFavoriteImage()
        
        // Setting Background Color
        viewGameDetailBackground.backgroundColor = Constants.Colors.BackgroundColors.gray
        
        // Setting ImageSlideshow & Label with Images
        ViewUtility.setImageInputs(&imageSlideshow, gameId: gameDetail!.id)
        lblGameName.text = gameDetail!.name
        ViewUtility.labelWithImageAttachment(&lblMetacritic, imageIconType: .resourceImage, imageName: "metacritic", text: " \(gameDetail!.metacritic)", textColor: UIColor.white)
        ViewUtility.labelWithImageAttachment(&lblRating, imageIconType: .systemImage, imageName: "star.fill", text: "\(gameDetail!.rating) / \(gameDetail!.ratingTop) (\(gameDetail!.ratingsCount))", textColor: UIColor.yellow)
        
        // Setting Property Labels
        ViewUtility.labelWithBoldAndNormalText(&lblPlaytime,
                                               boldText: "Playtime: ".localized,
                                               normalText: String(format: NSLocalizedString("scene.gamedetail.playtime", comment: ""), gameDetail!.playtime))
        ViewUtility.labelWithBoldAndNormalText(&lblReleaseDate, boldText: "Release Date: ".localized, normalText: "\(String(gameDetail!.releaseDate))")
        
        GameDetailSceneUtility.setParentPlatforms(&lblParentPlatforms, game: gameDetail!)
        GameDetailSceneUtility.setGameTags(&lblTags, game: gameDetail!, tagShowingType: .all)
        GameDetailSceneUtility.setGenres(&lblGenres, game: gameDetail!)
        
        ViewUtility.labelWithBoldAndNormalText(&lblAgeRating, boldText: "Age Rating: ".localized, normalText: gameDetail!.esrbRating!.name)
        
        lblDescriptionHeader.text = "Description:".localized
        btnGoToGameWebsite.setTitle("Go to Game Website".localized, for: .normal)
        
        RawGClient.getGameDetail(gameId: gameDetail!.id) { [weak self] detailedGame, error in
            guard let self = self else { return }
            self.lblDescriptionText.text = detailedGame?.descriptionRaw
        }
    }
    
    // MARK: - setRightBarBtnFavoriteImage
    /// Sets rightBarButtonItem's image according to game is favorite or not
    private func setRightBarBtnFavoriteImage() {
        switch (GameBoxCoreDataManager.shared.checkFavoriteGameById(game: gameDetail!.id)) {
            case true:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(rightBarBtnFavoriteClicked))
            case false:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightBarBtnFavoriteClicked))
        }
    }
    
}
