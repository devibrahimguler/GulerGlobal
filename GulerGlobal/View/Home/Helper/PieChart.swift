//
//  PieChart.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct PieChart: View {
    @State var slices: [(Double, Color)]
    @State var trimTo: Double = 0.0
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Canvas { context, size in
            // Add these lines to display as Donut
            //Start Donut
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            //End Donut
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle + Angle(degrees: 4) / 2 , endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                   
                }
                    
                    .trimmedPath(from: 0.0, to: trimTo)
             
                    
                pieContext.fill(path, with: .color(color))
                
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { date in
            trimTo += 0.001
            if trimTo >= 1.0 {
                self.timer.upstream.connect().cancel()
            }
        }
        .padding(2)
        .overlay {
            RoundedCorner(radius: 300)
                .stroke(style: .init(lineWidth: 5))
                .fill(.hWhite)
     
        }
        .padding()
    }
}

#Preview {
    PieChart(slices: [
        (2, .red),
        (3, .orange),
        (4, .yellow),
        (1, .green),
        (5, .blue),
        (4, .indigo),
        (2, .purple)
    ])
}
