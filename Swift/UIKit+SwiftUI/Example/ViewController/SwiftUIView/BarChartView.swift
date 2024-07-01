//
//  BarChartView.swift
//  Example
//
//  Created by William.Weng on 2024/7/1.
//

import SwiftUI
import Charts

struct BarChartView: View {
    
    private let weekdays = Calendar.current.shortWeekdaySymbols
    
    @State var steps = [10531, 6019, 7300, 8311, 7403, 6503, 9230]
    
    var stepsBlock: () -> [Int]
    
    var body: some View {
        Chart {
            ForEach(weekdays.indices, id: \.self) { index in
                BarMark(
                    x: .value("Steps", steps[index]),
                    y: .value("Day", weekdays[index])
                )
                .foregroundStyle(by: .value("Day", weekdays[index]))
                .lineStyle(StrokeStyle(lineWidth: 4.0))
            }
        }
        
        Button(action: {
            steps = stepsBlock()
        }) {
          Text("SwiftUI")
            .padding()
            .foregroundColor(.white)
            .background(.orange)
            .cornerRadius(20)
        }
    }
}

#Preview {
    BarChartView(stepsBlock: {
        return [111, 222, 333, 444, 555, 666, 777]
    })
}
