//
//  GenreCollectionViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

// MARK: - Enums
enum GenreCardBackgroundColorType: String {
    case blue, orange
}

// MARK: - GenreCollectionViewCell
final class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: GenreCollectionViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var lblGenreName: UILabel!
    @IBOutlet private weak var viewGenreBackground: UIView!

    // MARK: - Methods
    func configureCell(genre: CommonModel, backgroundColorType: GenreCardBackgroundColorType) {
        lblGenreName.text = genre.name
        
        var backgroundColor: UIColor
        switch backgroundColorType {
            case .blue:
                backgroundColor = UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
            case .orange:
                backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.00, alpha: 1.00)
        }
        
        viewGenreBackground.backgroundColor = backgroundColor
        viewGenreBackground.layer.shadowColor = backgroundColor.cgColor
        viewGenreBackground.layer.shadowOffset = .zero
        viewGenreBackground.layer.cornerRadius = 10
        viewGenreBackground.layer.shadowOpacity = 0.3
    }

}
