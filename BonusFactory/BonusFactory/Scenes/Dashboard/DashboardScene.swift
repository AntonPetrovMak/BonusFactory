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
    var activityItems: [ActivityItemView.Config] { get }

    func onAddNews()
    func onAddActivity()
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
                HStack(spacing: 10) {
                    Button("ADD NEWS", action: viewModel.onAddNews)
                    Button("ADD ACTIVITY", action: viewModel.onAddActivity)
                }
                ScrollView {
                    HStack(alignment: .top, spacing: 10)  {
                        newsView
                        activitiesView
                    }
                }
                //Spacer()
            }
            .navigationBarTitle(Text("Home"), displayMode: .automatic)
            .padding()
        }
    }

    private var newsView: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.newsItems.indices, id: \.self) { index in
                let newsConfig = viewModel.newsItems[index]
                NewsItemView(config: newsConfig)
            }
        }
    }

    private var activitiesView: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.activityItems.indices, id: \.self) { index in
                let activityConfig = viewModel.activityItems[index]
                ActivityItemView(config: activityConfig)
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

struct ActivityItemView: View {

    struct Config {
        let title: String
        let description: String
    }

    var config: Config

    var body: some View {
        ZStack {
            VStack {
                Text(config.title)
                    .font(.system(size: 20))
                Text(config.description)
                    .font(.system(size:16))
            }
            .padding(10)
        }
        .background(Color.blue.opacity(0.2))
    }
}
