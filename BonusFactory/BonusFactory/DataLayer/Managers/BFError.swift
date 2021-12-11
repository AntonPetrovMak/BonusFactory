//
//  BFError.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import Foundation

enum BFError: Error, LocalizedError {
    case somethingWentWrong
    case noOrganizations
    case encodeModel
    case decodeModel
    
    public var errorDescription: String? {
      switch self {
      case .somethingWentWrong,
           .noOrganizations,
           .encodeModel,
           .decodeModel:
        return "Something Went Wrong"
      }
    }
}
