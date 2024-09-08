//
//  AddBidView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI
import ContactsUI

struct AddBidView: View {
    private let now = Date.now
    
    @EnvironmentObject var dataModel: FirebaseDataModel
    @State private var isPhonePicker: Bool = false
    @State private var timePicker: Date = .now
    
    @Binding var tab: Tabs
    @Binding var edit: Edit
    @Binding var company: Company?
    
    var body: some View {
        VStack(spacing: 0) {
            let isEdit: Bool = edit == .EditWait
            let color: Color = isEdit ? .gray : .black
            
            HStack(spacing: 0) {
                Button {
                    withAnimation(.snappy) {
                        backAction()
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.snappy) {
                        if company != nil {
                            dataModel.workApprove = edit == .Wait ? "Wait" : "Approve"
                            dataModel.update()
                          
                        } else {
                            dataModel.workApprove = "Wait"
                            dataModel.create()
                        }
                        
                        backAction()
                    }
                } label: {
                    Text("ONAYLA")
                }
                .foregroundStyle(.green)
            }
            .font(.system(size: 25, weight: .black, design: .monospaced))
            .padding(.vertical, 5)
            .padding(.horizontal)
            
            Divider()
                .padding(.top, 5)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 2) {
                    TextProperty(title: .companyName, text: $dataModel.companyName, formTitle: $dataModel.formTitle, color: dataModel.isNewCompany ? color : .gray)
                        .disabled(!dataModel.isNewCompany || isEdit)
                        .onTapGesture {
                            if !dataModel.isNewCompany {
                                dataModel.isNewCompany = true
                            }
                        }
                    
                    
                    if dataModel.isNewCompany {
                        if let companies = dataModel.fetchCompany(value: dataModel.companyName) {
                            ForEach(companies, id: \.self) { company in
                                Button {
                                    withAnimation(.snappy) {
                                        dataModel.companyName = company.name
                                        dataModel.companyAddress = company.address
                                        dataModel.companyPhone = company.phone
                                        
                                        dataModel.isNewCompany = false
                                    }
                                } label: {
                                    HStack(spacing: 15) {
                                        Image(systemName: "storefront.fill")
                                            .font(.title2)
                                            .foregroundStyle(.gray)
                                        
                                        Text(company.name)
                                            .font(.system(size: 20, weight: .black, design: .monospaced))
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(.hWhite)
                                    .clipShape(RoundedCorner(radius: 5))
                                    .overlay {
                                        RoundedCorner(radius: 5)
                                            .stroke(style: .init(lineWidth: 3))
                                            .fill(.gray)
                                    }
                                    .padding(5)
                                    
                                }
                            }
                        }
                        
                        TextProperty(title: .companyAddress, text: $dataModel.companyAddress, formTitle: $dataModel.formTitle, color: color)
                            .disabled(isEdit)
                    }

                    HStack {
                        if dataModel.isNewCompany {
                            TextProperty(title: .companyPhone, text: $dataModel.companyPhone, formTitle: $dataModel.formTitle, keyboardType: .phonePad, color: color) {
                                CNContactStore().requestAccess(for: .contacts) { (_, _) in
                                    let status = CNContactStore.authorizationStatus(for: .contacts)
                                    
                                    switch status {
                                    case .notDetermined:
                                        print("notDetermined")
                                    case .restricted:
                                        print("restricted")
                                    case .denied:
                                        print("denied")
                                    case .authorized:
                                        isPhonePicker = true
                                    @unknown default:
                                        print("denied")
                                    }
                                    
                                    
                                }
                            }
                                .disabled(isEdit)
                        }
                        
                        TextProperty(title: .projeNumber, text: $dataModel.workPNum, formTitle: $dataModel.formTitle, keyboardType: .numberPad, color: dataModel.isPNum ? .gray : color)
                            .disabled(isEdit || dataModel.isPNum)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    if dataModel.isPNum {
                                        dataModel.isPNum = false
                                    }
                                }
                            }
                            .frame(width: 140)
                    }
                    
                    TextProperty(title: .workName, text: $dataModel.workName, formTitle: $dataModel.formTitle, color: color)
                        .disabled(isEdit)
                    
                    TextProperty(title: .workDescription, text: $dataModel.workDesc, formTitle: $dataModel.formTitle, color: color)
                        .disabled(isEdit)
                    
                    TextProperty(title: .workPrice, text: $dataModel.workPrice, formTitle: $dataModel.formTitle, keyboardType: .numberPad, color: color)
                        .disabled(isEdit)
                    
                    if isEdit || edit == .Approve {
                        Divider()
                        
                        VStack(spacing: 5) {
                            TextProperty(title: .recMoney, text: $dataModel.workRec, formTitle: $dataModel.formTitle, keyboardType: .numberPad)
                            
                            HStack(spacing: 10) {
                                Button {
                                    withAnimation(.snappy) {
                                        let newStatement = Statement(date: dataModel.workRecDate, price: dataModel.workRec.toDouble())
                                        dataModel.recList.append(newStatement)
                                        dataModel.workRec = ""
                                    }
                                } label: {
                                    Image(systemName: "plus.app")
                                }
                                .font(.system(size: 45, weight: .regular, design: .monospaced))
                                .foregroundStyle(dataModel.workRec == "" ? .gray : .blue)
                                .disabled(dataModel.workRec == "")
                                
                                DateProperty(timePicker: $timePicker, date: $dataModel.workRecDate, isPickerShower: $dataModel.isPickerShower, formTitle: $dataModel.formTitle, title: .recDate)
                                
                                
                            }
                            .padding(.vertical, 5)
                            
                           
                            
                            VStack(spacing: 5) {
                                ForEach(dataModel.recList, id: \.self) { statement in
                                    CashCard(date: statement.date , price: statement.price, isExp: false, isHaveButton: true) { isDelete in
                                        if let index = dataModel.recList.firstIndex(of: statement) {
                                            dataModel.recDateList.remove(at: index)
                                            
                                            if !isDelete {
                                                let newStatement = dataModel.createStatement(date: statement.date , price: statement.price)
                                                dataModel.workRem = "\((Double(dataModel.workRem) ?? 0) - statement.price)"
                                                dataModel.recDateList.append(newStatement)
                                            } else {
                                                dataModel.workRem = "\((Double(dataModel.workRem) ?? 0) + statement.price)"
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        Divider()
                        
                        HStack(spacing: 10) {
                            TextProperty(title: .remMoney, text: $dataModel.workRem, formTitle: $dataModel.formTitle, keyboardType: .numberPad, color: color)
                                .disabled(true)
                            
                            ZStack(alignment: .top) {
                                Text("VADE")
                                    .padding(5)
                                    .background(.white)
                                    .foregroundStyle(.gray)
                                    .clipShape(RoundedCorner(radius: 5))
                                    .overlay {
                                        RoundedCorner(radius: 5)
                                            .stroke(style: .init(lineWidth: 3))
                                            .fill(.gray)
                                    }
                                
                                Button {
                                    withAnimation(.snappy) {
                                        dataModel.isExpiry.toggle()
                                    }
                                } label: {
                                    Image(systemName: dataModel.isExpiry ? "checkmark.square" : "square")
                                }
                                .font(.largeTitle)
                                .foregroundStyle(!dataModel.expList.isEmpty ? .gray : .blue)
                                .padding(15)
                                .padding(.top, 20)
                                .disabled(!dataModel.expList.isEmpty)
                                
                            }
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                        }
                        
                        if dataModel.isExpiry {
                            Divider()
                            VStack(spacing: 5) {
                                TextProperty(title: .expMoney, text: $dataModel.workExp, formTitle: $dataModel.formTitle, keyboardType: .numberPad)
                                
                                HStack(spacing: 10) {
                                    Button {
                                        withAnimation(.snappy) {
                                            let newStatement = dataModel.createStatement(date: dataModel.workExpDate, price: dataModel.workExp.toDouble())
                                             dataModel.expList.append(newStatement)
                                             dataModel.workExp = ""
                                        }
                                    } label: {
                                        Image(systemName: "plus.app")
                                    }
                                    .font(.system(size: 45, weight: .regular, design: .monospaced))
                                    .foregroundStyle(dataModel.workExp == "" ? .gray : .blue)
                                    .disabled(dataModel.workExp == "" )
                                    
                                    DateProperty(timePicker: $timePicker, date: $dataModel.workExpDate, isPickerShower: $dataModel.isPickerShower, formTitle: $dataModel.formTitle, title: .expDate)
                                    
                                    
                                }
                                .padding(.vertical, 5)
                                
                               
                                
                                /*
                                 VStack(spacing: 5) {
                                     ForEach(dataModel.expList, id: \.self) { statement in
                                         CashCard(date: statement.date , price: statement.price, isExp: true, isHaveButton: true) { isDelete in
                                             if let index = dataModel.expList.firstIndex(of: statement) {
                                                 dataModel.expDateList.remove(at: index)
                                                 
                                                 if !isDelete {
                                                     let newStatement = dataModel.createStatement(date: statement.date , price: statement.price)
                                                     dataModel.workRem = "\((Double(dataModel.workRem) ?? 0) - statement.price)"
                                                     dataModel.recDateList.append(newStatement)
                                                 }
                                             }
                                         }
                                     }
                                 }
                                 */
                                
                            }
                            
                            Divider()
                        }
                        
                        DateProperty(timePicker: $timePicker, date: $dataModel.workStart, isPickerShower: $dataModel.isPickerShower, formTitle: $dataModel.formTitle, title: .startDate)
                        
                        DateProperty(timePicker: $timePicker, date: $dataModel.workFinished, isPickerShower: $dataModel.isPickerShower, formTitle: $dataModel.formTitle, title: .finishDate)
                        
                        Divider()
                        
                        AddProduct(timePicker: $timePicker)
                            .environmentObject(dataModel)
                        
                        
                    }
                    
                    
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $isPhonePicker ){
            PhonePickerView(pickerNumber: $dataModel.companyPhone)
        }
        .offset(y: dataModel.formTitle == .finishDate ? -300 :  dataModel.formTitle == .startDate ? -300 : 0)
        .overlay(alignment: .bottom) {
            CustomDatePicker()
                .offset(y: dataModel.isPickerShower ? 0 : 1000)
        }
        .onReceive(dataModel.$workRec) { value in
            dataModel.workRem = "\(dataModel.workPrice.toDouble() - dataModel.workRec.toDouble())"
            
            for rec in dataModel.recList {
                dataModel.workRem = "\(dataModel.workRem.toDouble() - rec.price)"
            }
        }
        .onChange(of: timePicker) { value in
            switch(dataModel.formTitle) {
            case .startDate:
                dataModel.workStart = value
            case .finishDate:
                dataModel.workFinished = value
            case .recDate:
                dataModel.workRecDate = value
            case .expDate:
                dataModel.workExpDate = value
            case .productPurchased:
                dataModel.proPurchasedDate = value
            default:
                print("None")
            }
        }
        .onChange(of: tab) { _ in
            dataModel.workPNum = dataModel.getLastPNum() ?? ""
            
            /*
             if let company = company {
                 
                 dataModel.companyName = company.name
                 dataModel.companyAddress = company.address
                 dataModel.companyPhone = company.phone
                 
                 dataModel.workStartDate = work.accept.startDate
                 dataModel.workFinishDate = work.accept.finishDate
                 
                 
                 
                 dataModel.workPNum = work.id
                 dataModel.workName = work.name
                 dataModel.workDesc = work.desc
                 dataModel.workPrice = String(work.price)
                 
                 dataModel.productList = work.product
                 
                 dataModel.isExpiry = work.accept.isExpiry
                 dataModel.recDateList = work.accept.recList
                 dataModel.expDateList = work.accept.expList
                 var totalRem = work.price
                 
                 for rec in dataModel.recDateList {
                     totalRem -= rec.price
                 }
                 
                 dataModel.workRem = String(totalRem)
             }
             */
        }
    }
    
    @ViewBuilder
    func CustomDatePicker() -> some View {
        VStack {
            Divider()
            
            DatePicker("", selection: $timePicker, displayedComponents: .date)
                .colorScheme(.light)
                .environment(\.locale, Locale.init(identifier: "tr"))
                .datePickerStyle(WheelDatePickerStyle())
                .overlay {
                    RoundedCorner(radius: 20)
                        .stroke(style: .init(lineWidth: 1))
                        .fill(.gray)
                }
                .padding([.horizontal, .top])
            
            
            Button {
                withAnimation(.snappy) {
                    dataModel.formTitle = .none
                    dataModel.isPickerShower = false
                }
            } label: {
                Text("SEÇ")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.hWhite)
                    .clipShape(RoundedCorner(radius: 20))
                    .overlay {
                        RoundedCorner(radius: 20)
                            .stroke(style: .init(lineWidth: 1))
                            .fill(.gray)
                    }
                    .padding(.horizontal)
                    .shadow(radius: 5, y: 5)
            }
            .font(.system(size: 20, weight: .black, design: .monospaced))
            .foregroundStyle(.bBlue)
            
        }
        .background(.white)
        .zIndex(100)
    }
    
    func backAction() {
        
        if edit == .Approve {
            tab = .Approved
            edit = .Wait
        } else {
            tab = .Bid
            edit = .Wait
        }
        company = nil
        dataModel.isPNum = true
        
        dataModel.isNewCompany = true
        
        dataModel.formTitle = .none
        dataModel.isPickerShower = false
        
        dataModel.workFinished = .now
        dataModel.workStart = .now
        dataModel.recList = []
        dataModel.expList = []
        dataModel.isExpiry = false
        
        dataModel.workPNum = ""
        dataModel.workName = ""
        dataModel.workDesc = ""
        dataModel.workPrice = ""
        dataModel.workRec = ""
        dataModel.workRem = ""
        dataModel.workExp = ""
        
        dataModel.companyName = ""
        dataModel.companyAddress = ""
        dataModel.companyPhone = ""

        hideKeyboard()
        UITabBar.changeTabBarState(shouldHide: false)
    }
}

struct TestAddBidView: View {
    @StateObject private var coreDataModel: FirebaseDataModel = .init()
    
    @State private var selectedCompany: Company? = nil
    @State private var tab: Tabs = .AddBid
    @State private var edit: Edit = .Approve
    
    var body: some View {
        AddBidView(tab: $tab, edit: $edit, company: $selectedCompany)
            .environmentObject(coreDataModel)
    }
}

#Preview {
    TestAddBidView()
}


