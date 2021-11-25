//
//  Router.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

enum Scene {
    case start
    case login
    case tabBar
}

protocol Router: AnyObject {
    func push(_ scene: Scene)
}
