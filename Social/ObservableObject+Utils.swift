//
//  ObservableObject+Utils.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import Combine

extension ObservableObject {
    
    internal func sinkError(_ completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error): debugPrint(error)
            default: break
        }
    }
    
}
