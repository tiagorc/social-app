//
//  GridUsersImageViewModel.swift
//  Social
//
//  Created by Euler Carvalho on 06/04/21.
//

import Foundation
import Combine

class GridUsersImageViewModel: ObservableObject {
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com/photos/"
    
    @Published
    private(set) var isLoading: Bool = false
    
    @Published
    private(set) var images = [UserImage]() {
        didSet {
            isLoading = false
        }
    }
    
    private var userImagesCancellationToken: AnyCancellable?
    
    func fetchUserImages() {
        userImagesCancellationToken?.cancel()
        
        guard let url = URL(string: "\(kBaseURL)\(user.id)/photos") else { return }
        isLoading = true
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        userImagesCancellationToken = session.dataTaskPublisher(for: request)
            .tryMap(session.map(_:))
            .decode(type: [UserImage].self, decoder: JSONDecoder())
            .breakpointOnError()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: sinkError(_:)) {
                self.images = $0.take(50)
            }
    }
}

extension Array {
    func take(_ elementsCount: Int) -> [Element] {
        let min = Swift.min(elementsCount, count)
        return Array(self[0..<min])
    }
}
