//
//  ImageView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 5.1.25..
//

//import SwiftUI
//
//struct ImageView: View {
//    let url: URL?
//    
//    @State private var image: Image? = nil
//    @State private var isLoading = false
//    
//    var body: some View {
//        ZStack {
//            if let image = image {
//                image
//                    .resizable()
//                    .scaledToFit()
//            } else if isLoading {
//                ProgressView()
//            } else {
//                Color.gray.opacity(0.3)
//            }
//        }
//        .onAppear() {
//            loadImage()
//        }
//        
//        private func loadImage() {
//            guard let url = url else { return }
//            isLoading = true
//            
//            Task {
//                let data 
//            }
//            
//            ImageLoader.loadImage(from: url) { image in
//                DispatchQueue.main.async {
//                    self.image = image
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ImageView()
//}
