//
//  ImageLoader.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private let storageManager: StorageManager
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        self.storageManager = AppStorageManager()
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }

        self.onStart()
        Self.imageProcessingQueue.async { [weak self] in
            guard let self = self else { return }
            self.storageManager.download(url: self.url, progress: nil) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case let .success(data):
                        if let image =  UIImage(data: data) {
                            self.cache(image)
                            self.image = image
                        }
                        self.onFinish()
                    case .failure:
                        self.onFinish()
                    }
                }
            }
        }
        
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: nil)
//            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
//                          receiveOutput: { [weak self] in self?.cache($0) },
//                          receiveCompletion: { [weak self] _ in self?.onFinish() },
//                          receiveCancel: { [weak self] in self?.onFinish() })
//            .subscribe(on: Self.imageProcessingQueue)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}
