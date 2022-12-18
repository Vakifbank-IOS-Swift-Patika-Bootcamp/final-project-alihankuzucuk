//
//  String+Extension.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 16.12.2022.
//

import Foundation

// MARK: Extension: String
extension String {
    /// Returns string as localized
    var localized: String { NSLocalizedString(self, comment: "") }
}
