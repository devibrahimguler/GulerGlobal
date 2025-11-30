//
//  CardsView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 7.02.2024.
//

import SwiftUI

struct CardsView: View {
    @EnvironmentObject var companyViewModel : CompanyViewModel
    
    var isApprove: Bool = false
    
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: EditSection
    @Binding var detailCompany: Company?
    
    var companies: [Company]
    
    var body: some View {
        ForEach(companies, id:\.self) { company in
            PeelEffect(isApprove: isApprove) {
                Card(selectedCompany: $selectedCompany, company: company, isApprove: isApprove)
            } onDelete: {
                companyViewModel.delete(company)
            } onEdit: {
                let isBidView = tab == .Bid
                
                selectedCompany = company
                tab = .AddBid
                
                edit = isApprove ? .ApproveBid : isBidView ? .AddBid : .EditBid
            } onSave: {
                selectedCompany = company
                tab = .AddBid
                
                edit = .Bid
            } onClick: {
                detailCompany = company
            }
        }
    }
}

#Preview {
    ContentView()
}
