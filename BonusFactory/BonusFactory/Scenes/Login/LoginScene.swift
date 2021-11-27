//
//  LoginScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import SwiftUI

protocol LoginVMP: ObservableObject {
    var phone: String { get set }
    
    func onNext()
}

struct LoginScene<ViewModel: LoginVMP>: View {

    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Enter phone number")
            TextField("+38 (093) 000 00 00", text: $viewModel.phone)
                .keyboardType(.phonePad)
            Button("Next", action: viewModel.onNext)
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle(Text("Welcome!"))
    }
}
