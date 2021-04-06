//
//  PostViewModel.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com/posts"
    
    @Published
    private(set) var isLoading: Bool = false
    
    @Published
    private(set) var posts = [Post]() {
        didSet {
            isLoading = false
        }
    }
    private var postsCancellationToken: AnyCancellable?
    
    func fetchPosts(user: User) {
        postsCancellationToken?.cancel()
        
        guard let url = URL(string: "\(kBaseURL)/\(user.id)/posts") else { return }
        isLoading = true
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        postsCancellationToken = session.dataTaskPublisher(for: request)
            .tryMap(session.map(_:))
            .decode(type: [Post].self, decoder: JSONDecoder())
            .breakpointOnError()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: sinkError(_:)) { self.posts = $0 }
    }
    
    
}
