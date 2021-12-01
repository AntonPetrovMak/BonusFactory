//
//  QRScene.swift
//  BonusFactory
//
//  Created by Petrov Anton on 02.12.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

protocol QRSceneVMP: ObservableObject {
    var qrData: String { get }
}


struct QRScene<ViewModel: QRSceneVMP>: View {
    
    @ObservedObject var viewModel: ViewModel
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Покажите код кассиру для начисления кэшбека")
            Image(uiImage: generateQRCode(from: viewModel.qrData))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 230)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
        .navigationTitle(Text("QR"))
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

