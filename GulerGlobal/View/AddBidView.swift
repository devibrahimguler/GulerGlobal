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
    @State private var workRem: String = ""
    @State private var workExp: String = ""
    
    @State private var companyName: String = ""
    @State private var companyAdress: String = ""
    @State private var companyPhone: String = ""
    
    @State private var workStartDate: Date = .now
    @State private var workFinishDate: Date = .now
    
    @State private var workRecDay: Date = .now
    @State private var recDateList: [String] = []
    
    @State private var workExpiryDay: Date = .now
    @State private var expDateList: [String] = []
    @State private var timePicker: Date = .now
    
    @State private var isPickerShower: Bool = false
    @State private var dateSection: DateSection = .none
    @State private var isNewCompany: Bool = true
    
    @State private var isExpiry: Bool = false
    @EnvironmentObject var companyViewModel: CompanyViewModel
    
    @Binding var tab: Tabs
    @Binding var edit: EditSection
    @Binding  var company: Company?
    
    var topEdge: CGFloat
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let isEdit: Bool = edit == .Bid

            VStack(spacing: 0) {
                HeaderView()
                    .zIndex(1000)
                    .frame(height: 40 + topEdge)
                    .offset(y: -offsetY)
                

                VStack(spacing: 10) {
                    TextProperty(text: $companyName, desc: "FİRMA İSMİ", color: isEdit ? .gray : isNewCompany ? .black : .gray)
                        .disabled(!isNewCompany || isEdit)
                        .onTapGesture {
                            if !isNewCompany {
                                isNewCompany = true
                            }
                        }
                      
                    
                    if isNewCompany {
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
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    
                                }
                            }
                            .padding(10)
                            .background(.BG)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                    
                    if isNewCompany {
                        TextProperty(text: $companyAdress, desc: "FİRMA ADRESİ", color: isEdit ? .gray : .black)
                            .disabled(isEdit)
                        
                        TextProperty(text: $companyPhone, desc: "FİRMA TELEFONU", keyboardType: .phonePad, color: isEdit ? .gray : .black)
                            .disabled(isEdit)
                    }
                    
                    TextProperty(text: $workPNum, desc: "PROJE NUMARASI", keyboardType: .numberPad, color: isEdit ? .gray : .black)
                        .disabled(isEdit)
                
                    TextProperty(text: $workName, desc: "İŞ İSMİ", color: isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    TextProperty(text: $workDesc, desc: "İŞ AÇIKLAMA", color: isEdit ? .gray : .black)
                        .disabled(isEdit)

                    TextProperty(text: $workPrice, desc: "İŞ FİYATI", keyboardType: .numberPad, color: isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    if isEdit || edit == .ApproveBid {
                        
                        ZStack(alignment: .top) {
                            Text("VADE")
                                .propartyTextdBack()
                            
                            Button {
                                withAnimation(.snappy) {
                                    isExpiry.toggle()
                                }
                            } label: {
                                Image(systemName: isExpiry ? "checkmark.square" : "square")
                                    .font(.largeTitle)
                                    .propartyTextFieldBack()
                            }
                            .disabled(!expDateList.isEmpty)
   
                        }
                        .font(.headline.bold().monospaced())
                        
                        Divider()
                        
                        ListAddedCard(text: $workRec, date: $workRecDay, list: $recDateList, isPickerShower: $isPickerShower, dateSection: $dateSection, section: .rec, textDesc: "ALINAN PARA", dateDesc: "PARA ALINMA TARİHİ")
                        
                        Divider()
                        
                        
                        if isExpiry {
                            
                            ListAddedCard(text: $workExp, date: $workExpiryDay, list: $expDateList, isPickerShower: $isPickerShower, dateSection: $dateSection, section: .expiry, textDesc: "ALINACAK PARA", dateDesc: "PARA ALINACAK TARİHİ")

                            Divider()
                        }
                        
                        TextProperty(text: $workRem, desc: "KALAN", keyboardType: .numberPad, color: isEdit ? .gray : .black)
                            .onChange(of: workRec) { value in
                                workRem = "\((Double(workPrice) ?? 0) - (Double(value) ?? 0))"
                                
                                for rec in recDateList {
                                    let price = rec.components(separatedBy: "-")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                    workRem = "\((Double(workRem) ?? 0) - (Double(price) ?? 0))"
                                    
                                }
                            }
                            .disabled(true)
                        
                        DateProperty(date: $workStartDate, dateSection: $dateSection, isPickerShower: $isPickerShower, section: .start, desc: "BAŞLAMA TARİHİ")
                    
                        DateProperty(date: $workFinishDate, dateSection: $dateSection, isPickerShower: $isPickerShower, section: .finish, desc: "TAHMİNİ BİTİŞ TARİHİ")
                        
                    }
                    
                }
                .padding(20)
                
            }
            .modifier(OffsetModifier(offset: $offsetY))
           
            
        }
        .offset(y: dateSection == .finish ? -300 :  dateSection == .start ? -300 : 0)
        .coordinateSpace(name: "SCROLL")
        // .scrollDismissesKeyboard(.immediately)
        .overlay(alignment: .bottom) {
            CustomDatePicker(date: $timePicker)
                .offset(y: isPickerShower ? 0 : 400)
        }
        .onChange(of: tab) { _ in
            
            if let company = company {

                workStartDate = company.work?.accept?.stTime ?? now
                workFinishDate = company.work?.accept?.fnTime ?? now
                
                companyName = company.name ?? ""
                companyAdress = company.adress ?? ""
                companyPhone = company.phone ?? ""
                
                workPNum = company.work?.pNum ?? ""
                workName = company.work?.name ?? ""
                workDesc = company.work?.desc ?? ""
                workPrice = String(company.work?.price ?? 0)
                
                if let exp =  company.work?.accept?.isExpiry {
                    isExpiry = exp
                }

                if let recList =  company.work?.accept?.recDate {
                    recDateList = recList
                }
                
                if let expList = company.work?.accept?.expiryDay {
                    expDateList = expList
                }
   
                
            }
        }
        .onChange(of: timePicker) { value in
            switch(dateSection) {
            case .start:
                workStartDate = value
            case .finish:
                workFinishDate = value
            case .rec:
                workRecDay = value
            case .expiry:
                workExpiryDay = value
            case .none:
                print("None")
            }
        }
        
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(.regularMaterial)
            
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
                        
                        if let company = company {
                            if let work =  company.work {
                                let newAccept = Accept(context: companyViewModel.container.viewContext)
                                let newWork = Work(context: companyViewModel.container.viewContext)

                                company.name = companyName
                                company.adress = companyAdress
                                company.phone = companyPhone
                                
                                newWork.id = work.id
                                newWork.pNum = workPNum
                                newWork.name = workName
                                newWork.desc = workDesc
                                newWork.price = Double(workPrice) ?? 0
                                newWork.approve = edit == .AddBid ? "Wait" : "Approve"
                                
                                newAccept.remMoney = Double(workRem) ?? 0
                                newAccept.isExpiry = isExpiry
                                newAccept.recDate = recDateList
                                newAccept.expiryDay = expDateList
                                newAccept.stTime = workStartDate
                                newAccept.fnTime = workFinishDate
                                newAccept.isFinished = false
                                
                                newWork.accept = newAccept
                                company.work = newWork
                                companyViewModel.update()
                            }
                        } else {
                            let newCompany = Company(context: companyViewModel.container.viewContext)
                            let newWork = Work(context: companyViewModel.container.viewContext)
                            newCompany.id = UUID()
                            newCompany.name = companyName
                            newCompany.adress = companyAdress
                            newCompany.phone = companyPhone
                            
                            newWork.id = UUID()
                            newWork.pNum = workPNum
                            newWork.name = workName
                            newWork.desc = workDesc
                            newWork.price = Double(workPrice) ?? 0
                            newWork.approve = "Wait"
                         
                            newCompany.work = newWork
                            companyViewModel.create()
                        
                        }
                        
                        backAction()
                        
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
            .padding(.bottom,10)
            .padding(.horizontal)
            
            
            
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
                    dateSection = .none
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
    
    func backAction() {
        hideKeyboard()
        if edit == .ApproveBid {
            tab = .Approved
            edit = .AddBid
        } else {
            tab = .Bid
            edit = .AddBid
        }
        company = nil
        
        isNewCompany = true
        
        dateSection = .none
        isPickerShower = false
        
        recDateList = []
        expDateList = []
        isExpiry = false
        
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

struct TestAddBidView: View {
    @State private var selectedCompany: Company? = nil
    @State private var tab: Tabs = .AddBid
    @State private var edit: EditSection = .AddBid
    
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    
    init() {
        /*
         companyViewModel.create(company: Company(name: "Firma İsmi 6", adress: "İnegöl Bursa", phone: "5541701635", work: Work(pNum: "001", name: "iş ismi", desc: "iş açıklama", price: 20000)))
         */
    }
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            AddBidView(tab: $tab, edit: $edit, company: $selectedCompany, topEdge: topEdge)
                .environmentObject(companyViewModel)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

#Preview {
    TestAddBidView()
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
