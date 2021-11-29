//
//  EnumDecodable.swift
//  M2Data
//
//  Created by Petrov Anton on 1/15/20.
//  Copyright © 2020 APM. All rights reserved.
//

import UIKit

protocol EnumDecodable: RawRepresentable, Decodable {
  static var defaultDecoderValue: Self { get }
}

extension EnumDecodable where RawValue: Decodable {
  init(from decoder: Decoder) throws {
    let value = try decoder.singleValueContainer().decode(RawValue.self)
    self = Self(rawValue: value) ?? Self.defaultDecoderValue
  }
}

extension Int {
  init(from decoder: Decoder) throws {
    let value = try decoder.singleValueContainer().decode(Int.self)
    self = value
  }
}
