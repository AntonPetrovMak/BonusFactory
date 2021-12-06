//
//  UsePointsScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 06.12.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

protocol UsePointsSceneVMP: ObservableObject {
    var userName: String { get }
    var totalPoints: String { get }
    var selectedIndex: Int { get set }
    var amount: String { get set }
    var isLoadingButton: Bool { get }
    
    var scannedCode: String? { get set }
    var simulatedData: String? { get }
    var isLoadingUser: Bool { get }
    
    func onNext()
}

struct UsePointsScene<ViewModel: UsePointsSceneVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var isPresentingScanner = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            if viewModel.scannedCode != nil && !viewModel.isLoadingUser {
                usePointsView
            } else {
                scanView
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle(Text("Use points"))
    }
    
    private var scanView: some View {
        VStack(spacing: 10) {
            if viewModel.isLoadingUser {
                ProgressView()
            } else {
                Button("Scan Code") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
                Text("Scan a QR code to begin")
            }
        }
    }
    
    private var usePointsView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Имя: \(viewModel.userName)")
                Text("Баланс: \(viewModel.totalPoints)")
            }

            Picker("", selection: $viewModel.selectedIndex) {
                Text("Зачислить").tag(0)
                Text("Снять").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())

            TextField(viewModel.selectedIndex == 0 ? "Сумма покупки" : "Кол-во бонусов", text: $viewModel.amount)
                .keyboardType(.phonePad)
            
            BFButton(title: viewModel.selectedIndex == 0 ? "Зачислить" : "Снять",
                     isSpinning: viewModel.isLoadingButton,
                     action: !viewModel.amount.isEmpty ? viewModel.onNext : nil)
        }
    }
    
    private var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.qr],
            showViewfinder: true,
            simulatedData: viewModel.simulatedData ?? "",
            completion: { result in
                if case let .success(code) = result {
                    self.viewModel.scannedCode = code
                    self.isPresentingScanner = false
                }
            }
        )
    }
}
