//
//  GenreCollectionViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

// MARK: GenreCollectionViewCell
final class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: GenreCollectionViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var lblGenreName: UILabel!
    @IBOutlet private weak var viewGenreBackground: UIView!

    // MARK: - Methods
    func configureCell(genre: CommonModel, genreBackgroundColor: UIColor) {
        lblGenreName.text = genre.name
        
        viewGenreBackground.backgroundColor = genreBackgroundColor
        viewGenreBackground.layer.shadowColor = genreBackgroundColor.cgColor
        viewGenreBackground.layer.shadowOffset = .zero
        viewGenreBackground.layer.cornerRadius = 10
        viewGenreBackground.layer.shadowOpacity = 0.3
    }

}
