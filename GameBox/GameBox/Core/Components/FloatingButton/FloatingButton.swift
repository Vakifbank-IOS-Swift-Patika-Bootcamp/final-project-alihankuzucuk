//
//  FloatingButton.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 13.12.2022.
//

import UIKit

// MARK: - FloatingButton
final class FloatingButton {
    
    static func getFloatingButton(systemImage: String, size: Int, backgroundColor: UIColor) -> UIButton {
        let floatingButton: UIButton = {
            let button = UIButton(
                frame: CGRect(x: 0,
                              y: 0,
                              width: size,
                              height: size))
            button.backgroundColor = backgroundColor
            
            let floatingButtonImage = UIImage(systemName: systemImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
            button.setImage(floatingButtonImage, for: .normal)
            button.tintColor = .white
            button.setTitleColor(.white, for: .normal)
            
            button.layer.shadowRadius = 10
            button.layer.shadowOpacity = 0.3
            
            // button.layer.masksToBounds = true // If you active this line, button will clip shadow
            button.layer.cornerRadius = CGFloat(size / 2)
            
            return button
        }()
        
        return floatingButton
    }
    
}
