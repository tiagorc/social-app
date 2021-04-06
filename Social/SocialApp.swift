//
//  SocialApp.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import SwiftUI

@main
struct SocialApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: UserViewModel())
        }
    }
}
