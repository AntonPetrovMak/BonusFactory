//
//  QRViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import Foundation
import Combine

class QRViewModel: QRSceneVMP {
    @Published var qrData: String = "1234"
    
    private let services: Services

    init(services: Services) {
        self.services = services
        bind()
    }
    
    private func bind() {

    }
}
