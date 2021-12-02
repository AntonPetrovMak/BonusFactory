//
//  Activity.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import Foundation

struct Activity: Codable {
    let id: String
    let userId: String
    let type: String
    let source: HistoryCashbackItem
    let createdAt: Date
    let authorId: String
}

struct HistoryCashbackItem: Codable {
    let reason: String
    let amount: Int
    let points: Int
}
