//
//  QRViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import Foundation
import Combine
import PhotosUI

class QRViewModel: QRSceneVMP {
    @Published var qrData: String = ""
    
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()

    init(services: Services) {
        self.services = services
        bind()
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        
                    } else {}
                })
            }
    }
    
    private func bind() {
        services.dataService.profile
            .compactMap { $0?.id }
            .sink { [weak self] profileId in
                guard let self = self else { return }
                self.qrData = profileId
            }
            .store(in: &cancellableSet)
    }
}
