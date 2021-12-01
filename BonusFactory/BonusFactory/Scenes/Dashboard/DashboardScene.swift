//
//  DashboardScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 29.11.2021.
//

import SwiftUI

protocol DashboardVMP: ObservableObject {
    var points: String { get }
    var userName: String { get }
    var companyName: String { get }
    var newsItems: [NewsItemView.Config] { get }

    func onAddNews()
}

struct DashboardScene<ViewModel: DashboardVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Points: \(viewModel.points)")
                Text("User name: \(viewModel.userName)")
                Text("Organization name: \(viewModel.companyName)")
                .font(.system(size: 16))
                Button("ADD NEWS", action: viewModel.onAddNews)
                ScrollView {
                    newsView
                }
                //Spacer()
            }
            .navigationBarTitle(Text("Home"), displayMode: .automatic)
            .padding()
        }
    }

    var newsView: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.newsItems.indices, id: \.self) { index in
                let newsConfig = viewModel.newsItems[index]
                NewsItemView(config: newsConfig)
            }
        }
    }
}

struct NewsItemView: View {

    struct Config {
        let image: UIImage?
        let title: String
        let description: String
    }

    var config: Config

    var body: some View {
        ZStack {
            if let image = config.image {
                Image(uiImage: image)
            }
            VStack {
                Text(config.title)
                    .font(.system(size: 20))
                Text(config.description)
                    .font(.system(size:16))
            }
            .padding(10)
        }
        .background(Color.gray.opacity(0.2))
    }
}
