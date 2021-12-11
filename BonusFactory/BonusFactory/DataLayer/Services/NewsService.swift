//
//  NewsService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 01.12.2021.
//

import Foundation
import Combine

protocol NewsService {
    var news: CurrentValueSubject<[News], Never> { get }

    func createNews(title: String, description: String, imageURL: URL?, completion: @escaping ErrorHandler)
    func deleteNews(_ newsId: String, _ completion: @escaping ErrorHandler)
}

class AppNewsService: NewsService {

    var news: CurrentValueSubject<[News], Never>

    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private let uploadManager: UploadManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager, uploadManager: UploadManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
        self.uploadManager = uploadManager
        self.news = .init([])
    }

    fileprivate func subscribeOnNews() {
        networkManager.subscribeOnNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(models):
                self.news.send(models)
            case let .failure(error):
                Logger.error(error)
            }
        }
    }
    
    func createNews(title: String, description: String, imageURL: URL?, completion: @escaping ErrorHandler) {
        if let imageURL = imageURL {
            uploadManager.upload(localFile: imageURL, progress: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(fullPath):
                    self.createNews(title: title, description: description, imagePath: fullPath, completion: completion)
                case let .failure(error):
                    Logger.error(error)
                }
            }
        } else {
            createNews(title: title, description: description, completion: completion)
        }
    }

    private func createNews(title: String,
                    description: String,
                    imagePath: String? = nil,
                    completion: @escaping ErrorHandler) {
        let source = NewsSimple(title: title, description: description, image: imagePath)
        let news = News(id: UUID().uuidString, createdAt: Date(), likes: 0, source: source)
        networkManager.addNews(news, completion)
    }
    
    func deleteNews(_ newsId: String, _ completion: @escaping ErrorHandler) {
        networkManager.deleteNews(newsId, completion)
    }
}

extension AppNewsService: Sychronizable {
    func authSync(userId: String) {
        subscribeOnNews()
    }
}
