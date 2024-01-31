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
    @Binding var selectionTab: Tag
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Proje Teklifleri")
                   
                
                Spacer()
                
                Text("Aktif Projeler")
            }
            .font(.title2)
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(companyViewModel.companies, id:\.self) { company in
                    Card(selectedCompany: $selectedCompany, selectionTab: $selectionTab, company: company)
                }
                .padding(.top)
            }
            
            
        }

    }
}

#Preview {
    ContentView()
}

enum KeyboardStyle {
    case numaric
    case text
    case phone
    case time
}

enum PickerSelector {
    case none
    case stPicker
    case fnPicker
}
