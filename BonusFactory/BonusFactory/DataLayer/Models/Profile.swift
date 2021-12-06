//
//  BFUser.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation

struct Profile: Codable {
    let id: String
    var first: String?
    var last: String?
    var dateOfBirth: Date?
    var city: String?
    var gender: String?
    var phone: String
    var email: String?
    let points: Int

    init(
        id: String,
        first: String? = nil,
        last: String? = nil,
        dateOfBirth: Date? = nil,
        city: String? = nil,
        gender: String? = nil,
        phone: String,
        email: String? = nil,
        points: Int = 0
    ) {
        self.id = id
        self.first = first
        self.last = last
        self.dateOfBirth = dateOfBirth
        self.city = city
        self.gender = gender
        self.phone = phone
        self.email = email
        self.points = points
    }
}

extension Profile {
    var fullname: String {
        if let first = first, let last = last {
            return "\(first) \(last)"
        } else if let first = first {
            return "\(first)"
        } else if let last = last {
            return "\(last)"
        } else {
            return "No name"
        }
    }
}
