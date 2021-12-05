//
//  BFButton.swift
//  Wirex
//
//  Created by Ihor Tkach on 22.07.2021.
//  Copyright © 2021 Wirex Limited. All rights reserved.
//

import SwiftUI

struct BFButton: View {

    let title: String
    let font: Font
    let action: VoidHandler?
    let isSpinning: Bool

    private var isUserInteractionEnabled: Bool {
        return action != nil && !isSpinning
    }

    // MARK: Initializing Methods
    init(title: String, font: Font = .medium17, isSpinning: Bool = false, action: VoidHandler?) {
        self.title = title
        self.font = font
        self.isSpinning = isSpinning
        self.action = action
    }

    // MARK: Public Properties
    var body: some View {
        Button(action: startAction, label: {
            if isSpinning {
                ProgressView()
            } else {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .font(font)
            }
        })
        .disabled(action == nil)
        .allowsHitTesting(isUserInteractionEnabled)
        .frame(minWidth: 40, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
        .foregroundColor(Color.white)
        .background(action != nil ? Color(.purple) : Color(.gray))
        .clipShape(Capsule())
    }

    // MARK: - Private Methods
    private func startAction() {
        guard let action = action else { return }
        action()
    }
}
