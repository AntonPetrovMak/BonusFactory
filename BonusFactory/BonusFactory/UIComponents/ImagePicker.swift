//
//  ImagePicker.swift
//  BonusFactory
//
//  Created by Petrov Anton on 11.12.2021.
//

import SwiftUI

struct ImageData {
    let imageURL: URL
    let imageData: Data
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    var presentationMode

    @Binding var imageData: ImageData?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var presentationMode: PresentationMode
        @Binding var imageData: ImageData?
        
        init(presentationMode: Binding<PresentationMode>, imageData: Binding<ImageData?>) {
            _presentationMode = presentationMode
            _imageData = imageData
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage,
                let dataImage = uiImage.pngData(),
                let urlImage = info[.imageURL] as? URL {
                 imageData = .init(imageURL: urlImage,
                                   imageData: dataImage)
            } else if let uiImage = info[.originalImage] as? UIImage,
               let dataImage = uiImage.pngData(),
               let urlImage = info[.imageURL] as? URL {
                imageData = .init(imageURL: urlImage,
                                  imageData: dataImage)
            }

            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, imageData: $imageData)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
