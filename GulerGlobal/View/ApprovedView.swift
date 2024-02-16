//
//  ApprovedView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 30.01.2024.
//

import SwiftUI

struct ApprovedView: View {
    @EnvironmentObject var companyViewModel : CompanyViewModel
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: EditSection
    @Binding var detailCompany: Company?
    
    @State private var offsetY: CGFloat = 0
    var topEdge: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(header: "Onaylanan Teklifler")
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                CardsView(isApprove: true, selectedCompany: $selectedCompany, tab: $tab, edit: $edit, detailCompany: $detailCompany, companies: companyViewModel.approveCompanies)
                    .environmentObject(companyViewModel)
                    .padding(.vertical, 5)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
