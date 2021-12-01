//
//  BFUser.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation

struct Profile: Codable {
    var name: String
    let points: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case points
    }
}
