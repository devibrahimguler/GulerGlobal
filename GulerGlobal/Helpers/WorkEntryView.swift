//
//  WorkEntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 11/23/24.
//

import SwiftUI


struct WorkEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    @State private var activeField: FormTitle = .none
    @State private var hiddingAnimation: Bool = false
    
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 8) {
            CompanyPickerView(title: .companyName, activeField: $activeField, hiddingAnimation: $hiddingAnimation, company: $company)
            
            CustomTextField(
                title: .projeNumber,
                text: $viewModel.workDetails.id,
                formTitle: $activeField,
                keyboardType: .numberPad,
                color: viewModel.workDetails.isChangeProjeNumber ? .black : .gray
            )
            .disabled(!viewModel.workDetails.isChangeProjeNumber)
            .onTapGesture {
                withAnimation(.snappy) {
                    viewModel.workDetails.isChangeProjeNumber.toggle()
                }
            }
            
            CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $activeField)
            
            CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $activeField)
            
            CustomTextField(title: .workPrice, text: $viewModel.workDetails.totalCost, formTitle: $activeField, keyboardType: .numberPad)
            
            Button("Onayla") {
                handleWorkSubmission()
            }
            .foregroundColor(.yazi)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(10)
            .background(.uRenk, in: .rect(cornerRadius: 10))
            .padding(5)
        }
        .animation(.linear, value: hiddingAnimation)
        .padding(10)
        .background(.background, in: .rect(cornerRadius: 20))
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2))
        .onAppear {
            viewModel.workDetails.id = viewModel.generateUniqueID()
        }
        .animation(.snappy, value: activeField)
        .onDisappear {
            activeField = .none
        }
    }
    
    private func handleWorkSubmission() {
        guard let company = company,
              !viewModel.workDetails.id.isEmpty,
              !viewModel.workDetails.name.isEmpty,
              !viewModel.workDetails.description.isEmpty,
              !viewModel.workDetails.totalCost.isEmpty else { return }
        
        viewModel.workDetails.approve = .pending
        
        let newWork = Work(
            id: viewModel.workDetails.id,
            workName: viewModel.workDetails.name,
            workDescription: viewModel.workDetails.description,
            totalCost: viewModel.workDetails.totalCost.toDouble(),
            approve: viewModel.workDetails.approve,
            remainingBalance: viewModel.workDetails.totalCost.toDouble(),
            statements: [],
            startDate: .now,
            endDate: .now,
            productList: [])
        
        viewModel.createWork(companyId: company.id, work: newWork)
        dismiss()
    }
}


struct Test_WorkEntryView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var company: Company?
    var body: some View {
        WorkEntryView(company: $company)
            .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkEntryView()
}

struct CompanyPickerView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var text: String = "Firma seçin"
    
    var title: FormTitle
    @Binding var activeField: FormTitle
    @Binding var hiddingAnimation: Bool
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text(text)
                    .foregroundStyle(Color.accentColor)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.accentColor)
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        if isHidden {
                            activeField = title
                        } else {
                            activeField = .none
                        }
                       
                        isHidden.toggle()
                        hiddingAnimation.toggle()
                    }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.companyList, id: \.self) { c in
                        Text("- \(c.companyName)")
                            .padding(10)
                            .onTapGesture {
                                text = c.companyName
                                company = c
                            }
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(height: isHidden ? 0 : 100)
        }
        .frame(maxWidth: .infinity)
        .font(.caption)
        .fontWeight(.semibold)
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedCorner(radius: 10, corners: .allCorners))
        .overlay {
            RoundedCorner(radius: 10, corners: .allCorners)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .fill(activeField == title ? Color.accentColor.gradient : Color.iRenk.gradient)
        }
        .padding(.horizontal, 5)
        .animation(.linear, value: isHidden)
    }
}
