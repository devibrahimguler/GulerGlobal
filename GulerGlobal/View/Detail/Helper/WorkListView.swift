//
//  WorkListView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.10.2025.
//

import SwiftUI

struct WorkListView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isHidden: Bool = true
    @State private var isReset: Bool = true
    
    var title: String
    var list: [Work]
    var company: Company
    @Binding var hiddingAnimation: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: isHidden ? 180 : 0))
                    .onTapGesture {
                        isHidden.toggle()
                        hiddingAnimation.toggle()
                    }
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .circular))
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(list, id: \.self) { work in
                        if work.id != "0000" {
                        SwipeAction(cornerRadius: 20, direction: .trailing, isReset: $isReset) {
                            WorkCard(company: company , work: work)
                                .background(work.status == .finished ? .green : work.status == .pending ? .yellow : work.status == .rejected ? .red : .clear)
                        }
                        actions: {
                            Action(tint: .red, icon: "trash.fill") {
                                withAnimation(.snappy) {
                                    viewModel.deleteWork(workId: work.id)
                                }
                            }
                        }
                        .padding(5)
                    }
                     }
                }
                .padding(10)
              
            }
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .clipShape(.rect(cornerRadius: 30, style: .continuous))
            .frame(height: isHidden ? 0 : 400)
           
        }
        .animation(.linear, value: isHidden)
    }
}

struct Test_WorkListView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @State private var hiddingAnimation: Bool = false
    
    var body: some View {
        WorkListView(
            title: "İş Listesi",
            list: example_WorkList,
            company: example_Company,
            hiddingAnimation: $hiddingAnimation
        )
        .environmentObject(viewModel)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        
    }
}

#Preview {
    Test_WorkListView()
}
