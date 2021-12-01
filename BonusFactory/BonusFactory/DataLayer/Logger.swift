//
//  Logger.swift
//  Router
//
//  Created by David.Wood on 17/07/21.
//

import Foundation

public enum Logger {
    public static func print(_ string: String) {
        Swift.print(string)
    }

    public static func error(_ error: Error?) {
        guard let error = error else { return }
        print("❌ \(error.localizedDescription)")
    }
}
