//
//  SortingMenu.swift
//  CryptoAssessment
//
//  Created by ikorobov on 12.1.25..
//

import SwiftUI

struct SortingMenu: View {
    @Binding var selectedOption: CoinListViewModel.SortingOption
    let onOptionChange: (CoinListViewModel.SortingOption) -> Void
    
    var body: some View {
        Menu {
            Button {
                toggleSorting(option: .nameAscending, opposite: .nameDescending)
            } label: {
                HStack {
                    Text("Name")
                    Spacer()
                    if selectedOption == .nameAscending {
                        Image(systemName: "arrow.up")
                    } else if selectedOption == .nameDescending {
                        Image(systemName: "arrow.down")
                    }
                }
            }
            
            Button {
                toggleSorting(option: .priceAscending, opposite: .priceDescending)
            } label: {
                HStack {
                    Text("Price")
                    Spacer()
                    if selectedOption == .priceAscending {
                        Image(systemName: "arrow.up")
                    } else if selectedOption == .priceDescending {
                        Image(systemName: "arrow.down")
                    }
                }
            }
            
            Button {
                toggleSorting(option: .change24hAscending, opposite: .change24hDescending)
            } label: {
                HStack {
                    Text("24h Change")
                    Spacer()
                    if selectedOption == .change24hAscending {
                        Image(systemName: "arrow.up")
                    } else if selectedOption == .change24hDescending {
                        Image(systemName: "arrow.down")
                    }
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
                .font(.headline)
        }
    }
    
    private func toggleSorting(option: CoinListViewModel.SortingOption, opposite: CoinListViewModel.SortingOption) {
        selectedOption = (selectedOption == option) ? opposite : option
        onOptionChange(selectedOption)
    }
}

#Preview {
    @Previewable @State var selectedOption: CoinListViewModel.SortingOption = .nameAscending

        SortingMenu(selectedOption: $selectedOption) { newOption in
            print("Selected sorting option: \(String(describing: newOption))")
            selectedOption = newOption
        }
}
