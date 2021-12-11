//
//  ManageNewsViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import Foundation
import Combine

class ManageNewsViewModel: ManageNewsSceneVMP {
    var newsTitle: String = "'"
    var newsDescription: String = ""
    @Published var imageData: ImageData?
    
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()

    init(services: Services) {
        self.services = services
        #if DEBUG
        newsTitle = "Lorem ipsum"
        newsDescription = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam"
        #endif
        bind()
    }
    
    private func bind() {

    }
    
    func onCreate() {
        services.newsService.createNews(title: newsTitle, description: newsDescription, imageURL: imageData?.imageURL) { (error) in
            Logger.error(error)
        }
    }
}
