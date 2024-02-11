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
    
    @State private var workStTime: String = ""
    @State private var workFnTime: String = ""
    
    @State private var workGetCashDay: String = ""
    @State private var recDateList: [String] = []
    
    @State private var workExpiryDay: String = ""
    @State private var expDateList: [String] = []
    @State private var timePicker: Date = .now
    
    @State private var isPickerShower: Bool = false
    @State private var pickerSelector: PickerSelector = .none
    @State private var isNewCompany: Bool = true
    
    @State private var isExpiry: Bool = false
    @EnvironmentObject var companyViewModel: CompanyViewModel
    
    @Binding var selectionTab: SelectionTab
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
                    Property(text: $companyName, desc: "FİRMA İSMİ", foregroundStyle: isEdit ? .gray : isNewCompany ? .black : .gray)
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
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    
                                }
                            }
                            .padding(10)
                            .background(.BG)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                    
                    if isNewCompany {
                        Property(text: $companyAdress, desc: "FİRMA ADRESİ", foregroundStyle: isEdit ? .gray : .black)
                            .disabled(isEdit)
                        
                        Property(text: $companyPhone, desc: "FİRMA TELEFONU", keyStyle: .phone, foregroundStyle: isEdit ? .gray : .black)
                            .disabled(isEdit)
                    }
                    
                    Property(text: $workPNum, desc: "PROJE NUMARASI", foregroundStyle: isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    Property(text: $workName, desc: "İŞ İSMİ", foregroundStyle: isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    Property(text: $workDesc, desc: "İŞ AÇIKLAMA", foregroundStyle:isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    Property(text: $workPrice, desc: "İŞ FİYATI", keyStyle: .numaric, foregroundStyle: isEdit ? .gray : .black)
                        .disabled(isEdit)
                    
                    if isEdit || edit == .ApproveBid {
                        
                        ZStack(alignment: .top) {
                            Text("VADE")
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5).stroke(style: .init(lineWidth: 1))
                                        .fill(.black.opacity(0.5))
                                        .shadow(color: .black, radius: 10, y: 5)
                                }
                                .zIndex(1)
                            
                            Button {
                                withAnimation(.snappy) {
                                    isExpiry.toggle()
                                }
                            } label: {
                                Image(systemName: isExpiry ? "checkmark.square" : "square")
                                    .font(.largeTitle)
                                    .padding(6)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(style: .init(lineWidth: 1))
                                            .fill(.black.opacity(0.5))
                                            .shadow(color: .black, radius: 10, y: 5)
                                        
                                    }
                                
                                    .padding(20)
                                    .background(.BG)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.top, 15)
                                
                                    
                            }
                            .disabled(!expDateList.isEmpty)
                           

                            
                        }
                        .font(.headline.bold().monospaced())
                        
                        Divider()
                        
                        ListAddedCard(now: now, isExpiry: false, text: $workRec, day: $workGetCashDay, list: $recDateList, isPickerShower: $isPickerShower, pickerSelector: $pickerSelector)
                        
                        Divider()
                        
                        
                        if isExpiry {
                            
                            ListAddedCard(now: now, isExpiry: true, text: $workExp, day: $workExpiryDay, list: $expDateList, isPickerShower: $isPickerShower, pickerSelector: $pickerSelector)

                            Divider()
                        }
                        
                        
                        Property(text: $workRem, desc: "KALAN", keyStyle: .numaric, isWorkRem: true)
                            .onChange(of: workRec) { value in
                                workRem = "\((Double(workPrice) ?? 0) - (Double(value) ?? 0))"
                                
                                for rec in recDateList {
                                    let price = rec.components(separatedBy: "-")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                    workRem = "\((Double(workRem) ?? 0) - (Double(price) ?? 0))"
                                    
                                }
                                
                            }
                        
                        Property(text: $workStTime, desc: "BAŞLAMA TARİHİ", keyStyle: .time)
                            .scaleEffect(pickerSelector == .stPicker ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    pickerSelector = .stPicker
                                    isPickerShower = true
                                    hideKeyboard()
                                }
                            }
                        
                        Property(text: $workFnTime, desc: "TAHMİNİ BİTİŞ TARİHİ", keyStyle: .time)
                            .scaleEffect(pickerSelector == .fnPicker ? CGSize(width: 0.9, height: 0.9) : CGSize(width: 1.0, height: 1.0))
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    pickerSelector = .fnPicker
                                    isPickerShower = true
                                    hideKeyboard()
                                }
                            }
                        
                    }
                    
                }
                .padding(20)
                
            }
            .modifier(OffsetModifier(offset: $offsetY))
           
            
        }
        .offset(y: pickerSelector == .fnPicker ? -300 :  pickerSelector == .stPicker ? -300 : 0)
        .coordinateSpace(name: "SCROLL")
        // .scrollDismissesKeyboard(.immediately)
        .overlay(alignment: .bottom) {
            CustomDatePicker(date: $timePicker)
                .offset(y: isPickerShower ? 0 : 400)
        }
        .onChange(of: selectionTab) { _ in
            workStTime = now.formatted(date: .long, time: .omitted)
            workFnTime = now.formatted(date: .long, time: .omitted)
            workGetCashDay = now.formatted(date: .long, time: .omitted)
            workExpiryDay = now.formatted(date: .long, time: .omitted)
            
            if let company = company {

                workStTime = company.work?.accept?.stTime?.formatted(date: .long, time: .omitted) ?? now.formatted(date: .long, time: .omitted)
                workFnTime = company.work?.accept?.fnTime?.formatted(date: .long, time: .omitted) ?? now.formatted(date: .long, time: .omitted)
                
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
            if pickerSelector == .stPicker {
                workStTime = value.formatted(date: .long, time: .omitted)
            } else if pickerSelector == .fnPicker {
                workFnTime = value.formatted(date: .long, time: .omitted)
            } else if pickerSelector == .getCash {
                workGetCashDay = value.formatted(date: .long, time: .omitted)
            } else if pickerSelector == .expiry {
                workExpiryDay = value.formatted(date: .long, time: .omitted)
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
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd' 'MM' 'yyyy'"
                        let stDate = dateFormatter.date(from: workStTime)
                        let fnDate = dateFormatter.date(from: workFnTime)
                        
                        if let company = company {
                            if let work =  company.work {
                                if let stDate = stDate {
                                    if let fnDate = fnDate {

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
                                        newAccept.stTime = stDate
                                        newAccept.fnTime = fnDate
                                        newAccept.isFinished = false
                                        
                                        newWork.accept = newAccept
                                        company.work = newWork
                                        companyViewModel.update()
                                    }
                                }
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
    
    func backAction() {
        hideKeyboard()
        if edit == .ApproveBid {
            selectionTab = .Approved
            edit = .AddBid
        } else {
            selectionTab = .Bid
            edit = .AddBid
        }
        company = nil
        
        isNewCompany = true
        
        pickerSelector = .none
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
    @State private var selectionTab: SelectionTab = .AddBid
    @State private var edit: EditSection = .Bid
    
    @StateObject private var companyViewModel: CompanyViewModel = .init()
    
    init() {
        /*
         companyViewModel.create(company: Company(name: "Firma İsmi 6", adress: "İnegöl Bursa", phone: "5541701635", work: Work(pNum: "001", name: "iş ismi", desc: "iş açıklama", price: 20000)))
         */
    }
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            AddBidView(selectionTab: $selectionTab, edit: $edit, company: $selectedCompany, topEdge: topEdge)
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
