//
//  Date+Extension.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 14.12.2022.
//

import Foundation

// MARK: Extension: Date
extension Date {
    
    // MARK: - format
    /// Returns date with formatted style
    /// - Parameter dateFormat: Requested date format
    /// - Returns: Date with requested format
    func format(dateFormat: String = "dd/MM/yyyy hh:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
    
    // MARK: - formatString
    /// Returns date string with formatted style
    /// - Parameter dateFormat: Requested date format
    /// - Returns: Date with requested format
    func formatString(dateFormat: String = "dd/MM/yyyy hh:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}
