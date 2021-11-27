//
//  ConfirmSMSScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 26.11.2021.
//

import SwiftUI

protocol ConfirmSMSVMP: ObservableObject {
    var code: String { get set }

    func onNext()
}

struct ConfirmSMSScene<ViewModel: ConfirmSMSVMP>: View {

    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Enter verification code")
            TextField("00 00 00", text: $viewModel.code)
                .keyboardType(.phonePad)
            Button("Next", action: viewModel.onNext)
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle(Text("Confirmation"))
    }
}
