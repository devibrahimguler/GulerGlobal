//
//  AddBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct AddBidView: View {
    let now = Date.now
    
    @State private var workPNum: String = ""
    @State private var workName: String = ""
    @State private var workDesc: String = ""
    @State private var workPrice: String = ""
    @State private var workRec: String = ""
    @State private var workRem: String = "0"
    
    @State private var companyName: String = ""
    @State private var companyAdress: String = ""
    @State private var companyPhone: String = ""
    
    @State private var workStTime: String = ""
    @State private var workFnTime: String = ""
    @State private var timePicker: Date = .now
    
    @State private var alert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var isPickerShower: Bool = false
    @State private var pickerSelector: PickerSelector = .none
    @State private var isNewCompany: Bool = true
    
    @EnvironmentObject var companyViewModel: CompanyViewModel
    
    @Binding var selectionTab: Tag
    @Binding  var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.snappy) {
                        backAction()
                    }
                } label: {
                    Image(systemName: "arrow.left.square.fill")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.red)
                }
                
                
                Spacer()
                
                Button {
                    withAnimation(.snappy) {
                        var list = [Int: String]()

                        list[0] = companyName
                        list[1] = companyAdress
                        list[2] = companyPhone
                        list[3] = workPNum
                        list[4] = workName
                        list[5] = workDesc
                        list[6] = workPrice
                        
                        createAlert(list: list)
                        
                        let dateFormatter = DateFormatter()
                        let stDate = dateFormatter.date(from: workStTime)
                        let fnDate = dateFormatter.date(from: workFnTime)
                        
                        if !alert {
                            
                            if var company = company {
                                if let stDate = stDate {
                                    if let fnDate = fnDate {
                                        let accept = Accept(
                                            recMoney: Double(workRec) ?? 0,
                                            remMoney: Double(workRem) ?? 0,
                                            stTime: stDate,
                                            fnTime: fnDate,
                                            isFinished: false)
                                        company.work.accept = accept
                                        companyViewModel.update(company: company)
                                    }
                                }
                            } else {
                                companyViewModel.create(
                                    company: Company(
                                        name: companyName,
                                        adress: companyAdress,
                                        phone: companyPhone,
                                        work: Work(pNum: workPNum,
                                                   name: workName,
                                                   desc: workDesc,
                                                   price: Double(workPrice) ?? 0))
                                )
                                
                                backAction()
                            }
                        }
                        
                    }
                } label: {
                    
                    Text(company != nil ? "ONAYLA" : "KAYDET")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(.BG)
                        .clipShape( RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundStyle(.black)
                        }
                        .font(.title2.bold())
                        .foregroundStyle(.green)
                }
            }
            .padding(.bottom,5)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 10) {
                    
                    if company != nil {
                        HStack(spacing: 10) {
                            Property(text: $workRec, desc: "ALINAN", keyStyle: .numaric)
                            
                            Property(text: $workRem, desc: "KALAN", keyStyle: .numaric, isWorkRem: true)
                                .onChange(of: workPrice) { _ in
                                    workRem = "\((Double(workPrice) ?? 0) - (Double(workRec) ?? 0))"
                                }
                                .onChange(of: workRec) { _ in
                                    workRem = "\((Double(workPrice) ?? 0) - (Double(workRec) ?? 0))"
                                }
                        }
                        
                        Property(text: $workStTime, desc: "BAŞLAMA TARİHİ", keyStyle: .time)
                            .scaleEffect(pickerSelector == .stPicker ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    pickerSelector = .stPicker
                                    isPickerShower = true
                                }
                            }
                        Property(text: $workFnTime, desc: "TAHMİNİ BİTİŞ TARİHİ", keyStyle: .time)
                            .scaleEffect(pickerSelector == .fnPicker ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    pickerSelector = .fnPicker
                                    isPickerShower = true
                                }
                            }
                        
                    } else {
                        Property(text: $companyName, desc: "FİRMA İSMİ")
                            .disabled(!isNewCompany)
                            .onTapGesture {
                                if !isNewCompany {
                                    alert = true
                                    alertMessage = "Değişiklik yapılacak!"
                                    isNewCompany = true
                                }
                            }
                        
                        if let company = companyViewModel.fetchCompany(value: companyName) {
                            VStack(alignment: .leading) {
                                Button {
                                    withAnimation(.snappy) {
                                        companyName = company.name ?? ""
                                        companyAdress = company.adress  ?? ""
                                        companyPhone = company.phone  ?? ""
                                        
                                        isNewCompany = false
                                    }
                                } label: {
                                    HStack(spacing: 15) {
                                        Image(systemName: "storefront.fill")
                                            .font(.title2)
                                            .foregroundStyle(.gray)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(company.name ?? "")
                                                .font(.title3.bold())
                                                .foregroundStyle(.primary)
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    
                                    
                                    
                                }
                            }
                            .padding(10)
                            .background(.BG)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                        
                        if isNewCompany {
                            
                            Property(text: $companyAdress, desc: "FİRMA ADRESİ")
                            
                            Property(text: $companyPhone, desc: "FİRMA TELEFONU", keyStyle: .phone)
                        }
                        
                        Property(text: $workPNum, desc: "PROJE NUMARASI")
                        
                        Property(text: $workName, desc: "İŞ İSMİ")
                        
                        Property(text: $workDesc, desc: "İŞ AÇIKLAMA")
                        
                        Property(text: $workPrice, desc: "İŞ FİYATI", keyStyle: .numaric)
                    }
                    
                }
                .padding(.vertical, 20)
                
            }
        }
        // .scrollDismissesKeyboard(.immediately)
        .padding(.horizontal)
        .overlay(alignment: .bottom) {
            CustomDatePicker(date: $timePicker)
                .offset(y: isPickerShower ? 0 : 400)
        }
        .alert(alertMessage, isPresented: $alert) {

        }
        .onChange(of: selectionTab) { _ in
            workStTime = now.formatted(date: .long, time: .omitted)
            workFnTime = now.formatted(date: .long, time: .omitted)
            
            if let company = company {
                companyName = company.name
                companyAdress = company.adress
                companyPhone = company.phone
                workPNum = company.work.pNum
                workName = company.work.name
                workDesc = company.work.desc
                workPrice = String(company.work.price)
            }
        }
        .onChange(of: timePicker) { value in
            if pickerSelector == .stPicker {
                workStTime = value.formatted(date: .long, time: .omitted)
            } else if pickerSelector == .fnPicker {
                workFnTime = value.formatted(date: .long, time: .omitted)
            }
        }
        
    }
    
    @ViewBuilder
    func CustomDatePicker(date: Binding<Date>) -> some View {
        VStack {
            DatePicker("", selection: date, displayedComponents: .date)
                .colorScheme(.light)
                .datePickerStyle(WheelDatePickerStyle())
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                        .fill(.black.opacity(0.7))
                        .shadow(color: .black, radius: 10, y: 5)
                }
                .padding([.horizontal, .top])
            
            
            Button {
                withAnimation(.snappy) {
                    pickerSelector = .none
                    isPickerShower = false
                }
            } label: {
                Text("SEÇ")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(.BG)
                    .clipShape( RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(.black)
                    }
                    .font(.title2.bold())
            }
            .padding(.bottom)
            
        }
        .background(.white)
    }
    
    func createAlert(list: [Int: String]) {
        
        for i in list.sorted(by: { $0.key < $1.key }) {
            guard i.value != "" else {
                
                switch(i.key) {
                case 0:
                    alertMessage = "Firma ismi giriniz!"
                case 1:
                    alertMessage = "Firma adresi giriniz!"
                case 2:
                    alertMessage = "Firma telefonu giriniz!"
                case 3:
                    alertMessage = "Proje numarsını giriniz!"
                case 4:
                    alertMessage = "İş ismi giriniz!"
                case 5:
                    alertMessage = "İş açıklama giriniz!"
                case 6:
                    alertMessage = "İş fiyatını giriniz!"
                default:
                    alertMessage = "Lütfen bilgileri gözden geçirin!"
                }
                alert = true
                return
            }
        }
        
    }
    
    func backAction() {
        hideKeyboard()
        selectionTab = .Bid
        company = nil
        
        isNewCompany = true
        
        pickerSelector = .none
        isPickerShower = false
        
        alert = false
        alertMessage = ""
        
        workPNum = ""
        workName = ""
        workDesc = ""
        workPrice = ""
        workRec = ""
        workRem = "0"
        
        companyName = ""
        companyAdress = ""
        companyPhone = ""
        
    }
}

#Preview {
    ContentView()
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
