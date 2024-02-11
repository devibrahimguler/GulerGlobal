//
//  BidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct BidView: View {
    @EnvironmentObject var companyViewModel : CompanyViewModel
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: EditSection
    
    @State private var offsetY: CGFloat = 0
    var topEdge: CGFloat
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                HeaderView(header: "Proje Teklifleri")
                    .zIndex(1000)
                    .frame(height: 40 + topEdge)
                    .offset(y: -offsetY)
                    .padding(.bottom,10)
                
                CardsView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, companies: companyViewModel.waitCompanies)
                    .environmentObject(companyViewModel)
                
            }
            .modifier(OffsetModifier(offset: $offsetY))
            
        }
        .coordinateSpace(name: "SCROLL")
        
    }
}

#Preview {
    ContentView()
}

enum DateSection {
    case none
    case rec
    case expiry
    case start
    case finish
}
