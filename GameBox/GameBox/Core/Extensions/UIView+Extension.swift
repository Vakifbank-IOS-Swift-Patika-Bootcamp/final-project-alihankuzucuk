//
//  UIView+Extension.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 10.12.2022.
//

import UIKit

// MARK: - Enums
// MARK: RoundType
enum RoundType {
    case top
    case none
    case bottom
    case all
}

// MARK: - Extensions
// MARK: Extension: UIView
extension UIView {
    
    // MARK: - round
    /// Provides radius on which view it is used
    /// - Parameters:
    ///   - type: Type of which corners you want to give radius
    ///   - radius: Value of radius
    func round(with type: RoundType, radius: CGFloat) {
        var corners: UIRectCorner
        
        switch type {
            case .none:
                corners = []
            case .top:
                corners = [.topLeft, .topRight]
            case .bottom:
                corners = [.bottomLeft, .bottomRight]
            case .all:
                corners = [.allCorners]
        }
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
}
