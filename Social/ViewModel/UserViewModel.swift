//
//  UserViewModel.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import Foundation
import Combine


class UserViewModel: ObservableObject {
    
    //BOV = Bateu o Olho e Viu!
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    
    @Published
    private(set) var loading = false
    
    @Published
    private(set) var users = [User]() {
        didSet {
            loading = false
        }
    }
    private var usersCancellationToken: AnyCancellable?
    
    
    
    
    func newFetchUsers() {
        usersCancellationToken?.cancel()
        
        if let url = URL(string: "\(kBaseURL)/users") {
            let session = URLSession.shared

            let request = URLRequest(url: url)
            loading = true
            usersCancellationToken = session.dataTaskPublisher(for: request)
                .tryMap(session.map(_:))
                .decode(type: [User].self, decoder: JSONDecoder())
                .breakpointOnError()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: sinkError(_:)) { self.users = $0 }

            
        }
    }
    
    func fetchUsers() {
        // Main Queue
        // Grand Central Dispatch (GCD)
        
        let session = URLSession.shared
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/users") {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let resp = response as? HTTPURLResponse,
                   resp.statusCode >= 200,
                   resp.statusCode < 300,
                   let json = data {
                    DispatchQueue.main.async {
                        self.users = try! JSONDecoder().decode([User].self, from: json)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
}
