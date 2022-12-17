//
//  OnboardingCollectionViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 15.12.2022.
//

import UIKit

// MARK: OnboardingCollectionViewCell
final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var imgVSlide: UIImageView!
    @IBOutlet private weak var lblSlideTitle: UILabel!
    @IBOutlet private weak var lblSlideDescription: UILabel!
    
    func configureCell(_ slide: OnboardingModel, titleColorIndex: Int) {
        imgVSlide.image = slide.image
        lblSlideTitle.text = slide.title
        lblSlideDescription.text = slide.description
        
        switch titleColorIndex {
            case 0:
                lblSlideTitle.textColor = Constants.Colors.BackgroundColors.blue
            case 1:
                lblSlideTitle.textColor = Constants.Colors.BackgroundColors.orange
            case 2:
                lblSlideTitle.textColor = Constants.Colors.BackgroundColors.green
            default:
                lblSlideTitle.textColor = UIColor.black
                break
        }
    }
    
}
