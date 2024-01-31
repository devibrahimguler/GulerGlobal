//
//  Card.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 20.01.2024.
//

import SwiftUI

struct Card: View {
    @Binding var selectedCompany: Company?
    @Binding var selectionTab: Tag
    var company: Companies
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Text(company.name ?? "")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                            .fill(.black.opacity(0.5))
                            .shadow(color: .black, radius: 10, y: 5)
                    }
                
                Text("P-\(company.work?.pNum ?? "")")
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                            .fill(.black.opacity(0.5))
                            .shadow(color: .black, radius: 10, y: 5)
                    }
            
            }
            .zIndex(1)
            
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        
                        WorkProperty(text: "Proje İsmi", desc: "\(company.work?.name ?? "" )", alignment: .leading)
                        
                        WorkProperty(text: "Proje Fiyatı", desc: "\(company.work?.price ?? 0) ₺", alignment: .leading)
                        
                    }
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy) {
                                let newCompany = Company(
                                    name: company.name ?? "",
                                    adress: company.adress ?? "",
                                    phone: company.phone ?? "",
                                    work: Work(
                                        pNum: company.work?.pNum ?? "",
                                        name: company.work?.name ?? "",
                                        desc: company.work?.desc ?? "",
                                        price: company.work?.price ?? 0,
                                        accept: Accept(
                                            recMoney: company.work?.accept?.recMoney ?? 0,
                                            remMoney: company.work?.accept?.remMoney ?? 0,
                                            stTime: company.work?.accept?.stTime ?? .now,
                                            fnTime: company.work?.accept?.fnTime ?? .now,
                                            isFinished: company.work?.accept?.isFinished ?? false)))
                                
                                selectedCompany = newCompany
                                selectionTab = .AddBid
                            }
                        } label: {
                            Text("ONAYLA")
                                .foregroundStyle(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }

                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy) {
                                
                            }
                        } label: {
                            Text("REDDET")
                                .foregroundStyle(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal)
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        Spacer()
                        
                    }
                    .font(.title3.bold().monospaced())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical , 20)
                .padding(.horizontal)
                .background(.BG)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            .padding(20)
            
        }
    }
}

#Preview {
    ContentView()
}
