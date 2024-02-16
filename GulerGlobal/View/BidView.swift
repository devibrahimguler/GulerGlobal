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
    @Binding var detailCompany: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(header: "Proje Teklifleri")
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                CardsView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit, detailCompany: $detailCompany, companies: companyViewModel.waitCompanies)
                    .environmentObject(companyViewModel)
                    .padding(.vertical, 5)
            }
        }
        
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
