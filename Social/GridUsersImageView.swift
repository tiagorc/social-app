//
//  GridUsersImageView.swift
//  Social
//
//  Created by Euler Carvalho on 06/04/21.
//

import Foundation
import SwiftUI

struct GridUsersImageView: View {
    
    @ObservedObject
    var viewModel: GridUsersImageViewModel
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if viewModel.isLoading {
                    showLoading()
                } else {
                    List(viewModel.images) { image in
                        HStack {
                            let width = geometry.size.width * 0.8
                            Spacer()
                            if let url = URL(string: image.thumbnailURL) {
                                AsyncImage(url: url, placeholder: { ProgressView().frame(width: width, height: width, alignment: .center)
                                })
                                .frame(width: width, height: width, alignment: .center)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear{
            viewModel.fetchUserImages()
        }
    }
    
    func showLoading() -> some View {
        return
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Text("Carregando imagens...")
                    Spacer()
                }
                Spacer()
            }
    }
}
