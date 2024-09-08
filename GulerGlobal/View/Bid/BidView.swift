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
                ForEach(dataModel.waitWorks, id: \.self) { work in
                    LazyVStack(spacing: 0){
                        NavigationLink {
                            /*
                             DetailView(company: <#Company#>)
                                 .environmentObject(dataModel)
                                 .onDisappear {
                                     UITabBar.changeTabBarState(shouldHide: false)
                                 }
                             */
                        } label: {
                            Card(work: work, isApprove: false)
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    .swipeActions {
                        
                        Button {
                            withAnimation(.snappy) {
                                /*
                                 selectedCompany = company
                                 */
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
                                /*
                                 selectedCompany = company
                                 */
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
                                /*
                                 dataModel.companyName = company.name
                                 dataModel.companyAddress = company.address
                                 dataModel.companyPhone = company.phone
                                 */
                                
                                dataModel.workPNum = work.id
                                dataModel.workName = work.name
                                dataModel.workDesc = work.desc
                                dataModel.workPrice = "\(work.price)"
                                dataModel.workApprove = "Unapprove"
                                
                                dataModel.workRem = "\(work.accept.remMoney)"
                                dataModel.isExpiry = work.accept.isExpiry
                                dataModel.recList = work.accept.recList
                                dataModel.expList = work.accept.expList
                                dataModel.workStart = work.accept.start
                                dataModel.workFinished = work.accept.finished
                                
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
