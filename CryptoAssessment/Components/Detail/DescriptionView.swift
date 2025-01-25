//
//  CoinDetailOverviewView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 7.1.25..
//

import SwiftUI

struct DescriptionView: View {
    @State private var isExpanded: Bool = false
    
    let attributedDescription: AttributedString?
    private let maxLines: Int = 3
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let attributedDescription = attributedDescription {
                Text(attributedDescription)
                    .font(.body)
                    .foregroundStyle(Color.gray)
                    .lineLimit(isExpanded ? nil : maxLines)
                
                if attributedDescription.characters.count > 100 {
                    Button {
                        toggleExpanded()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundStyle(.blue)
                                .padding(.horizontal)
                        }
                    }
                    .buttonStyle(.plain)
                    
                }
            } else {
                Text("No description available")
                    .font(.body)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func toggleExpanded() {
        print("Button tapped")
        isExpanded.toggle()
        print("isExpanded: \(isExpanded)")
    }
}

#Preview {
    DescriptionView(attributedDescription: "<p>This is a <a href=\"https://example.com\">link</a> in the description. This is additional text to test truncation. This is additional text to test truncation. This is additional text to test truncation.</p><p>This is a <a href=\"https://example.com\">link</a> in the description. This is additional text to test truncation. This is additional text to test truncation. This is additional text to test truncation.</p><p>This is a <a href=\"https://example.com\">link</a> in the description. This is additional text to test truncation. This is additional text to test truncation. This is additional text to test truncation.</p>")
}
