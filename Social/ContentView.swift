//
//  ContentView.swift
//  Social
//
//  Created by Pedro Henrique on 05/04/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    var viewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    showLoading()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: PostView()) {
                                VStack(alignment: .leading) {
                                    Text(user.name).font(.title2)
                                    Text(user.email).font(.subheadline)
                                }
                            }
                        }
                    }
                }
             }
            .navigationTitle("Usuários")
            .environmentObject(PostViewModel())
        }
        .onAppear {
            viewModel.newFetchUsers()
        }
    }
    
    private func showLoading() -> some View {
        return VStack {
            ProgressView()
            Text("Aguarde! Carregando..")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: UserViewModel())
    }
}
