//
//  GenreCollectionViewCell.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

final class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static let identifier = String(describing: GenreCollectionViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet private weak var lblGenreName: UILabel!

    // MARK: - Methods
    func configureCell(genre: GenreModel) {
        lblGenreName.text = genre.genreName
    }

}
