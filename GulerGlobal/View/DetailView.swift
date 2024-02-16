//
//  DetailView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 14.02.2024.
//

import SwiftUI

struct DetailView: View {
    @State private var isFinished: Bool = false
    
    var company: Company
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                Text(company.name ?? "")
                    .propartyTextFieldBack()
                    .multilineTextAlignment(.center)
                    .font(.title.bold().monospaced())
                    .foregroundStyle(.black)
                    .padding(.bottom, 5)
                
                Divider()
 
                Property(text: "ADDRESS", desc: company.adress ?? "")
                
                Property(text: "TELEFON", desc: company.phone ?? "")
                
                Property(text: "PROJE NUMARASI", desc: company.work?.pNum ?? "")
                
                Property(text: "İŞ İSMİ", desc: company.work?.name ?? "")
                
                Property(text: "İŞ AÇIKLAMASI", desc: company.work?.desc ?? "")
                
                Property(text: "İŞ FİYATI", desc: "\(company.work?.price ?? 0)")
                
                HStack {
                    Property(text: "İŞ KALAN PARA", desc: "\(company.work?.accept?.remMoney ?? 0)")
           
                    
                    if company.work?.accept?.remMoney == 0 {
                        ZStack(alignment: .top) {
                            Text("İş Bitti")
                                .propartyTextdBack()
                            
                            Button {
                                withAnimation(.snappy) {
                                    isFinished.toggle()
                                }
                            } label: {
                                Image(systemName: isFinished ? "checkmark.square" : "square")
                                    .font(.title3)
                               
                            }
                            .propartyTextFieldBack()
                            
                        }
                        .font(.headline.bold().monospaced())
                        .foregroundStyle(.black)
                    }
                }
                
                
                if let recList = company.work?.accept?.recDate as? Set<Statement> {
                    if recList.count > 0 {
                        VStack {
                            Text("Alınan Paralar")
                                .propartyTextdBack()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(recList.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { rec in
                                        Property(text:"\((rec.date ?? .now).formatted(date: .long, time: .omitted))" , desc: "\(rec.price) ₺")
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        .foregroundStyle(.black)
                    }
                }
                
                if let isExp = company.work?.accept?.isExpiry {
                    if isExp {
                        if let expiryDay = company.work?.accept?.expiryDay as? Set<Statement> {
                            if expiryDay.count > 0 {
                                VStack {
                                    Text("Alınacak Paralar")
                                        .propartyTextdBack()
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(expiryDay.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { exp in
                                                Property(text:"\((exp.date ?? .now).formatted(date: .long, time: .omitted))" , desc: "\(exp.price) ₺")
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                                .foregroundStyle(.black)
                            }
                        }
                    }
                }
                
                if let stTime = company.work?.accept?.stTime {
                    Property(text: "İş Başlama Tarihi", desc: stTime.formatted(date: .long, time: .omitted))
                }
                
                if let fnTime = company.work?.accept?.fnTime {
                    Property(text: "İş Tahmini Bitiş Tarihi", desc: fnTime.formatted(date: .long, time: .omitted))
                }
                
            }
            .padding(.horizontal)
            
        }
    }
    
    @ViewBuilder
    func Property(text: String, desc: String) -> some View {
        ZStack(alignment: .topLeading) {
            
            Text(text)
                .propartyTextdBack()
                .foregroundStyle(.blue)
            
            
            Text(desc)
                .frame(maxWidth: .infinity)
                .propartyTextFieldBack()
            
        }
        .font(.headline.bold().monospaced())
        .foregroundStyle(.black)
        .padding(.vertical, 5)
    }
}

struct TestDetailView: View {
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    
    var body: some View {
        if let company = companyViewModel.companies.first {
            DetailView(company: company)
        }
    }
}

#Preview {
    TestDetailView()
}
