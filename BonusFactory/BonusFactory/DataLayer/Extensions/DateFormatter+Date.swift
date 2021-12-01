//
//  DateFormatter+Date.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import Foundation

extension Date {

    var dateAndTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
    
}
