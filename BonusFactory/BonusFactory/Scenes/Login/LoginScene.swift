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
            Images.signinLogo
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.top, 20)
            Text("Введите номер телефона для входа в приложение")
                .font(.regular12)
                .padding(.vertical, 20)
            
            VStack(spacing: 15) {
                TextField("+38 (093) 000 00 00", text: $viewModel.phone)
                    .font(.regular16)
                    .keyboardType(.phonePad)
                    .frame(minWidth: 40, maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                BFButton(title: "Продолжить", isSpinning: false, action: viewModel.onNext)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .navigationBarHidden(true)
        //.navigationTitle(Text("Welcome!"))
    }
}

private struct LoginScene_Previews: PreviewProvider {
    
    class PreviewVM: LoginVMP {
        var phone: String = ""
        func onNext() { }
    }
    
    static var previews: some View {
        LoginScene(viewModel: PreviewVM())
    }
}
