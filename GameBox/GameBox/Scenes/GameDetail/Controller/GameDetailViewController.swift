//
//  GameDetailViewController.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 11.12.2022.
//

import UIKit
import ImageSlideshow

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
    @IBOutlet private weak var lblDescriptionText: UILabel!
    
    // MARK: - Variables
    public var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
    }
    
    // MARK: - Actions
    @IBAction func btnGoToGameWebsiteClicked(_ sender: Any) {
        RawGClient.getGameDetail(gameId: viewModel.game!.id) { detailedGame, error in
            if let url = URL(string: detailedGame?.website ?? ""), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
        }
    }
    
    @objc func rightBarBtnFavoriteClicked() {
        switch (GameBoxCoreDataManager.shared.checkFavoriteByGameId(game: viewModel.game!.id)) {
            case true:
                if GameBoxCoreDataManager.shared.deleteFavoriteBy(gameId: viewModel.game!.id) == true {
                    setRightBarBtnFavoriteImage()
                }
            case false:
                if GameBoxCoreDataManager.shared.favoriteGame(gameId: viewModel.game!.id) == true {
                    setRightBarBtnFavoriteImage()
                }
        }
    }
    
}

// MARK: - Extension: Helper Methods
extension GameDetailViewController {
    
    private func prepareScreen() {
        // Preparing NavigationItem
        self.navigationItem.title = "Game Detail"
        
        setRightBarBtnFavoriteImage()
        
        // Setting Background Color
        switch viewModel.game!.id%2 {
            case 0:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.00)
            case 1:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
            default:
                viewGameDetailBackground.backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
                break
        }
        
        // Setting ImageSlideshow & Label with Images
        viewModel.setImageInputs(&imageSlideshow, gameId: viewModel.game!.id)
        lblGameName.text = viewModel.game!.name
        viewModel.labelWithImageAttachment(&lblMetacritic, imageIconType: .resourceImage, imageName: "metacritic", text: " \(viewModel.game!.metacritic)", textColor: UIColor.white)
        viewModel.labelWithImageAttachment(&lblRating, imageIconType: .systemImage, imageName: "star.fill", text: "\(viewModel.game!.rating) / \(viewModel.game!.ratingTop) (\(viewModel.game!.ratingsCount))", textColor: UIColor.yellow)
        
        // Setting Property Labels
        viewModel.labelWithBoldAndNormalText(&lblPlaytime, boldText: "Playtime: ", normalText: "\(String(viewModel.game!.playtime)) Hours")
        viewModel.labelWithBoldAndNormalText(&lblReleaseDate, boldText: "Release Date: ", normalText: "\(String(viewModel.game!.releaseDate))")
        
        viewModel.setParentPlatforms(&lblParentPlatforms)
        viewModel.setGameTags(&lblTags, tagShowingType: .all)
        viewModel.setGenres(&lblGenres)
        
        viewModel.labelWithBoldAndNormalText(&lblAgeRating, boldText: "Age Rating: ", normalText: viewModel.game!.esrbRating!.name)
        
        RawGClient.getGameDetail(gameId: viewModel.game!.id) { [weak self] detailedGame, error in
            guard let self = self else { return }
            self.lblDescriptionText.text = detailedGame?.descriptionRaw
        }
    }
    
    /// Sets rightBarButtonItem's image according to game is favorite or not
    private func setRightBarBtnFavoriteImage() {
        switch (GameBoxCoreDataManager.shared.checkFavoriteByGameId(game: viewModel.game!.id)) {
            case true:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(rightBarBtnFavoriteClicked))
            case false:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightBarBtnFavoriteClicked))
        }
    }
    
}
