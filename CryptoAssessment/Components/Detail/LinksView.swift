//
//  CoinLinksView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 11.1.25..
//

import SwiftUI

struct LinksView: View {
    let coinLinks: CoinDetails.Links?
    
    var body: some View {
        HStack {
            LinkButton(imageName: "house", url: coinLinks?.homepage.first ?? "")
            LinkButton(imageName: "xmark.square", url: coinLinks?.twitterScreenName.map { "https://twitter.com/\($0)" } ?? "")
            LinkButton(imageName: "person.circle", url: coinLinks?.facebookUsername.map { "https://facebook.com/\($0)" } ?? "")
        }
    }
}

#Preview {
    LinksView(coinLinks: MockData().coinDetail.links)
}
