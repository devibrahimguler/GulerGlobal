//
//  BidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct BidView: View {
    @EnvironmentObject var dataModel: FirebaseDataModel
    @Binding var selectedCompany: Company?
    @Binding var tab: Tabs
    @Binding var edit: Edit
    
    @State var bgColor: Color = .white
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataModel.waitCompanies, id: \.self) { company in
                    LazyVStack(spacing: 0){
                        NavigationLink {
                            DetailView(company: company)
                                .environmentObject(dataModel)
                                .onDisappear {
                                    UITabBar.changeTabBarState(shouldHide: false)
                                }
                        } label: {
                            Card(company: company, isApprove: false)
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        
                        Button {
                            withAnimation(.snappy) {
                                selectedCompany = company
                                tab = .AddBid
                                edit = .EditWait
                                
                            }
                        } label: {
                            Image(systemName: "checkmark.square")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .contentShape(Rectangle())
                        }
                        .tint(.green)
                        
                        Button {
                            withAnimation(.snappy) {
                                selectedCompany = company
                                tab = .AddBid
                                edit = .Wait
                            }
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .contentShape(Rectangle())
                        }
                        .tint(.yellow)
                        
                        Button {
                            withAnimation(.snappy) {
                                dataModel.companyName = company.name
                                dataModel.companyAddress = company.address
                                dataModel.companyPhone = company.phone
                                
                                dataModel.workPNum = company.work.id
                                dataModel.workName = company.work.name
                                dataModel.workDesc = company.work.desc
                                dataModel.workPrice = "\(company.work.price)"
                                dataModel.workApprove = "Unapprove"
                                
                                dataModel.workRem = "\(company.work.accept.remMoney)"
                                dataModel.isExpiry = company.work.accept.isExpiry
                                dataModel.recDateList = company.work.accept.recList
                                dataModel.expDateList = company.work.accept.expList
                                dataModel.workStartDate = company.work.accept.startDate
                                dataModel.workFinishDate = company.work.accept.finishDate
                                
                                dataModel.update()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                                .contentShape(Rectangle())
                        }
                        .tint(.red)
                    }
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("Teklifler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct TestBidView: View {
    @StateObject private var dataModel: FirebaseDataModel = .init()
    @State private var selectedCompany: Company? = nil
    
    @State private var tab: Tabs = .Bid
    @State private var edit: Edit = .Wait
    
    var body: some View {
        BidView(selectedCompany: $selectedCompany, tab: $tab, edit: $edit)
            .environmentObject(dataModel)
            .tabItem { Image(systemName: "rectangle.stack") }
            .tag(Tabs.Bid)
    }
}

#Preview {
    TestBidView()
}
