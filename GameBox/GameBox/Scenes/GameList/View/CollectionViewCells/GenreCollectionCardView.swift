//
//  GenreCollectionCardView.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 9.12.2022.
//

import UIKit

final class GenreCollectionCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.shadowColor = UIColor.blue.cgColor
        layer.backgroundColor = CGColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00)
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.3
    }
    
}
