//
//  NewsService.swift
//  BonusFactory
//
//  Created by Petrov Anton on 01.12.2021.
//

import Combine

protocol NewsService {
    var news: CurrentValueSubject<[News], Never> { get }

    func createNews(_ news: News, _ completion: @escaping ErrorHandler)
    func deleteNews(_ newsId: String, _ completion: @escaping ErrorHandler)
}

class AppNewsService: NewsService {

    var news: CurrentValueSubject<[News], Never>

    private let dataManager: DataManager
    private let networkManager: NetworkManager
    private var cancellableSet = Set<AnyCancellable>()
    
    init(dataManager: DataManager, networkManager: NetworkManager) {
        self.dataManager = dataManager
        self.networkManager = networkManager
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
    
    func createNews(_ news: News, _ completion: @escaping ErrorHandler) {
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
