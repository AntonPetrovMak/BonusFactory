//
//  Organization.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation

struct Organization: Codable {
    var abount: About
    let links: [ContactLink]
    let phones: [String]
    let institutions: [Institution]
    let staff: [Staff]

    static let empty = Organization(abount: About(name: "", paragraphs: [], logo: ""), links: [], phones: [], institutions: [], staff: [])
}

// MARK: - Abount
struct About: Codable {
    var name: String
    let paragraphs: [Paragraphs]
    let logo: String
}

struct Paragraphs: Codable {
    var title: String
    let text: String
    let order: Int
}

// MARK: - Links
enum ContactLinkType: String, Encodable, EnumDecodable {
    static var defaultDecoderValue: ContactLinkType = .website

    case website
    case instagram
    case facebook
}

struct ContactLink: Codable {
    let type: ContactLinkType
    let url: String
}

// MARK: - Institution
struct Institution: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: Staff
enum StaffPosition: String, Encodable, EnumDecodable {
    static var defaultDecoderValue: StaffPosition = .teller

    case owner
    case admin
    case teller
}

struct Staff: Codable {
    let position: StaffPosition
    let userId: String
}
