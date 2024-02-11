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
    @Binding var selectionTab: SelectionTab
    @Binding var edit: EditSection
    
    var companies: [Company]
    
    var body: some View {
        ForEach(companies, id:\.self) { company in
            PeelEffect(isApprove: isApprove) {
                Card(selectedCompany: $selectedCompany, selectionTab: $selectionTab, company: company)
            } onDelete: {
                companyViewModel.delete(company)
            } onEdit: {
                let isBidView = selectionTab == .Bid
                selectedCompany = company
                selectionTab = .AddBid
                
                edit = isApprove ? .ApproveBid : isBidView ? .AddBid : .EditBid
            } onSave: {
                selectedCompany = company
                selectionTab = .AddBid
                
                edit = .Bid
            }
        }
    }
}

#Preview {
    ContentView()
}
