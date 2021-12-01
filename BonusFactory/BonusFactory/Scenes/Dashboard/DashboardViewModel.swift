//
//  DashboardViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import Foundation
import Combine

class DashboardViewModel: DashboardVMP {

    @Published var points: String = ""
    @Published var userName: String = ""
    @Published var companyName: String = ""
    @Published var newsItems: [NewsItemView.Config] = []
    
    private let services: Services
    private var cancellableSet = Set<AnyCancellable>()

    init(services: Services) {
        self.services = services
        bind()
    }

    private func bind() {
        services.dataService.currentUser
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.points = Int(user.points).description
                self?.userName = user.name
            }
            .store(in: &cancellableSet)

        services.organizationService.organization
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] organization in
                self?.companyName = organization.abount.name
            }
            .store(in: &cancellableSet)

        services.newsService.news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                guard let self = self else { return }
                self.newsItems = news.map { item in
                    let description =
                        "Desc: \(item.source.description)\n" +
                        "Likes: \(item.likes)\n" +
                        "Date: \(item.date)"
                    
                    return .init(image: nil, title: item.source.title, description: description)
                }
            }
            .store(in: &cancellableSet)
    }

    func onAddNews() {
        let source = NewsSimple(
            title: "Lorem ipsum",
            description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam",
            image: ""
        )
        let news = News(date: Date(), likes: 2, source: source)
        services.newsService.createNews(news) { (error) in
            Logger.error(error)
        }
    }
}

