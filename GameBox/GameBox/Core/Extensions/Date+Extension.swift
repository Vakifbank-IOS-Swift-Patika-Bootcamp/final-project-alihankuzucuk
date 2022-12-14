//
//  Date+Extension.swift
//  GameBox
//
//  Created by Alihan KUZUCUK on 14.12.2022.
//

import Foundation

// MARK: Extension: Date
extension Date {
    
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
    
    func formatString(dateFormat: String = "dd/MM/yyyy hh:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}
