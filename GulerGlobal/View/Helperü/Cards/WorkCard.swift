//
//  WorkCard.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 20.01.2024.
//

import SwiftUI

struct WorkCard: View {
    @State private var index = 0
    
    var works: [Work]?
    
    var body: some View {
        
        HStack {
            
            Button {
                withAnimation(.snappy) {
                    if let count = works?.count {
                        if count > 0 {
                            if index > 0 {
                                index -= 1
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "arrowshape.backward.fill")
                    .padding(10)
                    .background(.BG)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            Spacer()
            
            VStack(spacing: 5) {
                WorkInfo(text: "iŞ İSMİ", desc: "\(works?[index].name ?? "")", alignment: .center)
                
                Divider()
                
                WorkInfo(text: "iŞ AÇIKLAMA", desc: "\(works?[index].desc ?? "")", alignment: .center)
                
                Divider()
                
                WorkInfo(text: "İŞ FİYATI", desc: "\(works?[index].price ?? 0)", alignment: .center)
                
                Divider()
                
                HStack {
                    Spacer()
                    
                    WorkInfo(text: "ALINAN", desc: "\(works?[index].recMoney ?? 0)", alignment: .center)
                    
                    Spacer()
                    
                    Divider()
                    
                    Spacer()
                    
                    WorkInfo(text: "KALAN", desc: "\(works?[index].recMoney ?? 0)", alignment: .center)
                    
                    Spacer()
                }
                
                WorkInfo(text: "BAŞLAMA TARİHİ", desc: works?[index].stTime.formatted(date: .long, time: .omitted) ?? "" , alignment: .center)
                
                WorkInfo(text: "TAHMİNİ BİTİŞ TARİHİ", desc: works?[index].fnTime?.formatted(date: .long, time: .omitted) ?? "", alignment: .center)
                
            }
            .padding(10)
            .background(.BG)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Spacer()
            
            Button {
                withAnimation(.snappy) {
                    if let count = works?.count {
                        if count > 0 {
                            if index < count - 1 {
                                index += 1
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "arrowshape.forward.fill")
                    .padding(10)
                    .background(.BG)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            
            
        }
    }
}

#Preview {
    TestHome()
}
