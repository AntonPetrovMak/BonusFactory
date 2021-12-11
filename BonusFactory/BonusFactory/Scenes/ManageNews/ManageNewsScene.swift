//
//  ManageNewsScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import SwiftUI

protocol ManageNewsSceneVMP: ObservableObject {
    var newsTitle: String { get set }
    var newsDescription: String { get set }
    var imageData: ImageData? { get set }

    func onCreate()
}


struct ManageNewsScene<ViewModel: ManageNewsSceneVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var isShowPicker: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button("Выбрать фото") {
                isShowPicker.toggle()
            }

            Text("Заголовок")
            ZStack {
                TextEditor(text: $viewModel.newsTitle)
                Text(viewModel.newsTitle).opacity(0).padding(.all, 8)
            }
            .shadow(radius: 1)

            Text("Описание")
            ZStack {
                TextEditor(text: $viewModel.newsDescription)
                Text(viewModel.newsDescription).opacity(0).padding(.all, 8)
            }
            .shadow(radius: 1)

            BFButton(title: "Создать", action: viewModel.newsTitle.isEmpty ? nil : viewModel.onCreate)
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(imageData: $viewModel.imageData)
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle(Text("Manage News"))
    }
}
