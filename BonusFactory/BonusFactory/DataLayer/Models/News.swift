//
//  News.swift
//  BonusFactory
//
//  Created by Petrov Anton on 30.11.2021.
//

import Foundation
import FirebaseFirestore

struct News: Codable {
    //var type: String
    let id: String
    let createdAt: Date
    let likes: Int
    let source: NewsSimple
}

struct NewsSimple: Codable {
    let title: String
    let description: String
    let image: String?
}
