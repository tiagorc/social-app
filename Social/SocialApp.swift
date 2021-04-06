//
//  SocialApp.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import SwiftUI

@main
struct SocialApp: App {
    
    init() {
//        let user = User(id: 1, name: "Pedro", username: "pedro.figueiredo", email: "pedro.figueiredo@iesb.br")
//
//        if let json = try? JSONEncoder().encode(user) {
//            let jsonString = String(data: json, encoding: .utf8)
//            print(jsonString)
//
//
//            do {
//                let sameUser = try JSONDecoder().decode(User.self, from: json)
//                print(sameUser)
//            }catch (let error) {
//                debugPrint(error)
//            }
//
//        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: UserViewModel())
        }
    }
}
