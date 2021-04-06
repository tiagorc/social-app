//
//  ImageLoader.swift
//  Social
//
//  Created by Euler Carvalho on 06/04/21.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published
    var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        let session = URLSession.shared
        cancellable = session.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data )}
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0}
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?) {
        image.map{ cache?[url] = $0 }
    }
}

struct AsyncImage<P: View> : View {
    @StateObject
    private var loader: ImageLoader
    private let placeholder: P
    
    init(url: URL, @ViewBuilder placeholder: () -> P) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    private var content: some View {
        Group {
            if loader.image != nil,
               let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

//MARK: Caching images

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(url: URL) -> UIImage? {
        get { cache.object(forKey: url as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: url as NSURL) : cache.setObject(newValue!, forKey: url as NSURL)}
    }
}

// MARK: Add cache to environment
struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey].self = newValue }
    }
}
