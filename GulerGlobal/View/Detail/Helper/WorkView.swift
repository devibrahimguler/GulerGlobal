//
//  WorkView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 18.08.2024.
//

import SwiftUI

struct WorkView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataModel: FirebaseDataModel
    @State private var isEditCompany: Bool = false
    
    @Binding var isFinished: Bool
    @Binding var formTitle: FormTitle
    
    var work: Work
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            if work.name != "" {
                TextProperty(title: .workName, text: $dataModel.workName, formTitle: $formTitle)
                    .disabled(!isEditCompany)
            }
            
            if work.desc != "" {
                TextProperty(title: .workDescription, text: $dataModel.workDesc, formTitle: $formTitle)
                    .disabled(!isEditCompany)
            }
            
            HStack {
                TextProperty(title: .workPrice, text: $dataModel.workPrice, formTitle: $formTitle)
                    .disabled(!isEditCompany)
                
                if !(work.approve == "Finished") && work.accept.remMoney == 0 {
                    ZStack(alignment: .topLeading) {
                        Text("Bitti".uppercased())
                            .foregroundStyle(.black)
                            .padding(5)
                            .background(.white)
                            .foregroundStyle(.gray)
                            .clipShape( RoundedCorner(radius: 5, corners: [.topLeft, .topRight]))
                            .overlay {
                                RoundedCorner(radius: 5, corners: [.topLeft, .topRight])
                                    .stroke(style: .init(lineWidth: 3))
                                    .fill(.gray)
                            }
                            .zIndex(1)
                            .padding(.horizontal, 5)
                        
                        VStack {
                            Button {
                                withAnimation(.snappy) {
                                    isFinished = true
                                    
                                    /*
                                     dataModel.companyName = company.name
                                     dataModel.companyAddress = company.address
                                     dataModel.companyPhone = company.phone
                                     */
                                    
                                    dataModel.workPNum = work.id
                                    dataModel.workName = work.name
                                    dataModel.workDesc = work.desc
                                    dataModel.workPrice = "\(work.price)"
                                    dataModel.workApprove = "Finished"
                                    
                                    dataModel.workRem = "\(work.accept.remMoney)"
                                    dataModel.isExpiry = work.accept.isExpiry
                                    dataModel.recList = work.accept.recList
                                    dataModel.expList = work.accept.expList
                                    dataModel.workStart = work.accept.start
                                    dataModel.workFinished = work.accept.finished
                                    
                                    dataModel.update()
                                }
                            } label: {
                                Image(systemName: isFinished ? "checkmark.square" : "square")
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(.hWhite)
                        .clipShape(RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight]))
                        .multilineTextAlignment(.center)
                        .overlay {
                            RoundedCorner(radius: 5, corners: [.bottomLeft, .bottomRight, .topRight])
                                .stroke(style: .init(lineWidth: 3))
                                .fill(.gray)
                        }
                        .zIndex(0)
                        .padding(.top, 17)
                        .padding(5)
                        
                        
                    }
                    .padding(.horizontal, 5)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    
                    
                } else if !(work.approve == "Finished") {
                    
                    TextProperty(title: .remMoney, text: $dataModel.workRem, formTitle: $formTitle, color: .red)
                        .disabled(!isEditCompany)
                }
                
            }
            
            if work.accept.recList.count > 0 {
                VStack(spacing: 5) {
                    Text("Alınan Paralar".uppercased())
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .foregroundStyle(.white)
                        .background(.green)
                        .clipShape(RoundedCorner(radius: 5))
                        .overlay {
                            RoundedCorner(radius: 5)
                                .stroke(style: .init(lineWidth: 3))
                                .fill(.gray)
                        }
                    
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(work.accept.recList, id: \.self) { rec in
                                
                                CashCard(date: rec.date, price: rec.price, color: .green)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                            }
                        }
                        .padding(5)
                    }
                }
                .padding(.top, 5)
                .foregroundStyle(.black)
            }
            
            if work.accept.isExpiry {
                if work.accept.expList.count > 0 {
                    VStack(spacing: 5) {
                        Text("Alınacak Paralar".uppercased())
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 5)
                            .foregroundStyle(.black)
                            .background(.yellow)
                            .clipShape(RoundedCorner(radius: 5))
                            .overlay {
                                RoundedCorner(radius: 5)
                                    .stroke(style: .init(lineWidth: 3))
                                    .fill(.gray)
                                
                            }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(work.accept.expList, id: \.self) { exp in
                                    CashCard(date: exp.date, price: exp.price, color: .yellow)
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                                }
                            }
                            .padding(5)
                        }
                    }
                    .padding(.top, 5)
                    .foregroundStyle(.black)
                }
            }
            
            HStack {
                
                
                /*
                 DetailCard(title: .startDate ,text: "Başlama Tarihi", desc: company.work.accept.startDate.formatted(date: .long, time: .omitted))
                 
                 
                 DetailCard(title: .finishDate ,text: "Bitiş Tarihi", desc: company.work.accept.finishDate.formatted(date: .long, time: .omitted))
                 
                 */
            }
        }
        .padding(.vertical, 5)
        .background(colorScheme == .dark ? .black : .white)
        .clipShape(RoundedCorner(radius: 8))
        .onAppear {
            dataModel.workName = work.name
            dataModel.workDesc = work.desc
            dataModel.workPrice = work.price.customDouble()
            dataModel.workRem = work.accept.remMoney.customDouble()
            /*
             dataModel.recDateList = company.work.accept.recList
             dataModel.expDateList = company.work.accept.expList
             */
        }
    }
}

struct TestWorkView: View {
    @StateObject private var dataModel: FirebaseDataModel = .init()
    @State private var isFinished: Bool = false
    @State private var formTitle: FormTitle = .none
    
    var body: some View {
        if let work = dataModel.works.last {
            WorkView(isFinished: $isFinished, formTitle: $formTitle, work: work)
                .environmentObject(dataModel)
        }
    }
}

#Preview {
    TestWorkView()
}
