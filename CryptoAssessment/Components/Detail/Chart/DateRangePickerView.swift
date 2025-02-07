//
//   DateRangePickerView.swift
//  CryptoAssessment
//
//  Created by ikorobov on 14.1.25..
//

import SwiftUI

struct DateRangePickerView: View {
    @Binding var selectedRange: DateInterval
    let maxRange: DateInterval
    
    var body: some View {
        HStack {
            Button {
                move(by: -7)
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(canShiftRange(by: -7) ? .blue : .gray)
            }
            .disabled(!canShiftRange(by: -7))

            Text("\(formattedDate(selectedRange.start)) - \(formattedDate(selectedRange.end))")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Button {
                move(by: 7)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(canShiftRange(by: 7) ? .blue : .gray)
            }
            .disabled(!canShiftRange(by: 7))
        }
        .padding(.horizontal)
    }
    
    
    private func move(by days: Int) {
        let calendar = Calendar.current
        let newStart = calendar.date(byAdding: .day, value: days, to: selectedRange.start) ?? selectedRange.start
        let newEnd = calendar.date(byAdding: .day, value: days, to: selectedRange.end) ?? selectedRange.end
        
        if maxRange.contains(newStart) && maxRange.contains(newEnd) {
            selectedRange = DateInterval(start: newStart, end: newEnd)
        }
    }
    
    private func canShiftRange(by days: Int) -> Bool {
            let calendar = Calendar.current
            let newStart = calendar.date(byAdding: .day, value: days, to: selectedRange.start) ?? selectedRange.start
            let newEnd = calendar.date(byAdding: .day, value: days, to: selectedRange.end) ?? selectedRange.end
            return maxRange.contains(newStart) && maxRange.contains(newEnd)
        }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    struct DateRangePickerView_Preview: View {
        @State private var selectedRange: DateInterval
        
        init() {
            let end = Date()
            let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
            _selectedRange = State(initialValue: DateInterval(start: start, end: end))
        }
        
        var body: some View {
            let maxRange: DateInterval = {
                let end = Date()
                let start = Calendar.current.date(byAdding: .day, value: -30, to: end) ?? end
                return DateInterval(start: start, end: end)
            }()
            
            DateRangePickerView(
                selectedRange: $selectedRange,
                maxRange: maxRange
            )
        }
    }
    
    return DateRangePickerView_Preview()
}
