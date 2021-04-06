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
    
    let url = URL(string: "https://cencup.com/wp-content/uploads/2019/07/avatar-placeholder.png")!
    
    @State
    var numberOfRows = 0
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    showLoading()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: PostView(user: user)) {
                                HStack {
                                    AsyncImage(url: self.url, placeholder: {
                                        ProgressView()
                                            .frame(width: 40, height: 40, alignment: .center)
                                    })
                                    .frame(width: 40, height: 40, alignment: .center)
                                    VStack(alignment: .leading) {
                                        Text(user.name).font(.title2)
                                        Text(user.email).font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                }
             }
            .navigationTitle("Usuários")
        }
        .environmentObject(PostViewModel())
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
    
    private var list: some View {
        List(0 ..< numberOfRows, id: \.self) { _ in
            AsyncImage(url: self.url, placeholder: { Text("Carregando imagem") })
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: UserViewModel())
    }
}
