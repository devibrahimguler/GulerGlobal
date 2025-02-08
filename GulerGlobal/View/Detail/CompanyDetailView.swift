//
//  DetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct CompanyDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var isEditCompany: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var addType: ListType = .none
    @State private var isAdd: Bool = false
    @State private var isReset: Bool = false
    
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
           
                VStack(spacing: 0) {
                    CustomTextField(title: .companyName, text: $viewModel.companyDetails.name, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyAddress, text: $viewModel.companyDetails.address, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                    
                    CustomTextField(title: .companyPhone, text: $viewModel.companyDetails.contactNumber, formTitle: $formTitle)
                        .disabled(!isEditCompany)
                }
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 20))
                
      
               VStack(spacing: 10) {
                   
                   Text("Durum Raporu")
                       .font(.title)
                       .fontWeight(.semibold)
                       .frame(maxWidth: .infinity)
                       .padding(.vertical, 10)
                       .background(.background, in: .rect(cornerRadius: 20))
                     
                   
                   VStack(spacing: 5) {
                       ForEach(company.workList, id: \.self) { work in
                           let approved = work.approve == .approved ? true : false
                           SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                               WorkCard(companyName: company.companyName , work: work, isApprove: approved, color: .bRenk)
                           } actions: {
                               Action(tint: .red, icon: "trash.fill") {
                                   withAnimation(.snappy) {
                                       viewModel.deleteWork(companyId: company.id, workId: work.id)
                                   }
                               }
                           }
                           
                       }
                   }
                   .padding(10)
                   .background(.background)
                   .clipShape(RoundedRectangle(cornerRadius: 20))


               }
               .opacity(isEditCompany || company.workList.isEmpty ? 0 : 1)
          
            }
            .navigationTitle("Guler Global")
            .navigationBarTitleDisplayMode(.inline)
            .blur(radius: isAdd ? 5 : 0)
        }
        .padding(.horizontal, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .toolbar(content: {
            Button {
                withAnimation(.spring) {
                    
                    if isEditCompany {
                        let updateArea = [
                            "companyName": viewModel.companyDetails.name,
                            "companyAddress": viewModel.companyDetails.address,
                            "contactNumber": viewModel.companyDetails.contactNumber
                        ]
                        
                        viewModel.updateCompany(companyId: company.id, updateArea: updateArea)
                    }
                    
                    formTitle = .none
                    isEditCompany.toggle()
                }
            } label: {
                Text(isEditCompany ? "Kaydet" : "Düzenle")
                    .foregroundStyle(isEditCompany ? .green : .yellow)
                    .font(.system(size: 14, weight: .black, design: .monospaced))
            }
            
        })
        .onAppear {
            viewModel.updateCompanyDetails(with: company)
        }
        .onDisappear {
            viewModel.updateCompanyDetails(with: nil)
        }
            
    }
}

struct TestDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        CompanyDetailView(company: example_TupleModel.company)
            .environmentObject(viewModel)
    }
}

#Preview {
    TestDetailView()
}

extension View {
    func customBorder(_ color: Color = .red) -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .font(.system(size: 15, weight: .black, design: .monospaced))
            .foregroundStyle(.white)
            .padding(10)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
        
    }
    
    func customAddBorder(_ color: Color = .red) -> some View {
        return self
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .font(.system(size: 15, weight: .black, design: .monospaced))
            .foregroundStyle(.white)
        
    }
    
    func customAddTwoBorder(_ color: Color = .red) -> some View {
        return self
            .padding(10)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(style: .init(lineWidth: 3))
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 20))
        
    }
}
