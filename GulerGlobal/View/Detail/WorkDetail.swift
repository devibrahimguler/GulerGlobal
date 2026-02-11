//
//  WorkDetail.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 22.09.2024.
//

import SwiftUI

struct WorkDetail: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MainViewModel
    
    @State private var startConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var endConfig: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    
    @State private var isEditWork: Bool = false
    @State private var formTitle: FormTitle = .none
    
    @State private var hiddingAnimation: Bool = false
    @State private var openMenu: Bool = false
    
    let work: Work
    let company: Company
    var products: [WorkProduct] {
        viewModel.getWorkProductsById(work.id)
    }
    
    init(work: Work, company: Company) {
        self.work = work
        self.company = company
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                
                VStack(spacing: 0) {
                    CustomTextField(title: .workName, text: $viewModel.workDetails.name, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    CustomTextField(title: .workDescription, text: $viewModel.workDetails.description, formTitle: $formTitle)
                        .disabled(!isEditWork)
                    
                    CustomTextField(title: .workPrice, text: $viewModel.workDetails.cost, formTitle: $formTitle)
                        .disabled(!isEditWork)
                }
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
                .padding(.top, 25)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                
                VStack(spacing: 0) {
                    CustomDatePicker(dateConfig: $startConfig, title: .startDate, formTitle: $formTitle)
                    
                    CustomDatePicker(dateConfig: $endConfig, title: .finishDate, formTitle: $formTitle)
                }
                .foregroundStyle(.isText)
                .disabled(!isEditWork)
                .scaleEffect(x: isEditWork ? 0.97 : 1, y: isEditWork ? 0.97 : 1)
                .animation(isEditWork ? .easeInOut(duration: 0.5).repeatForever() : .easeInOut(duration: 0.5), value: isEditWork)
                .padding(.top, 15)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                
                VStack(spacing: 5) {
                    
                    WorkProductList(
                        title: "Malzeme Listesi",
                        list: products,
                        workId: work.id,
                        isSupplier: false,
                        hiddingAnimation: $hiddingAnimation
                    )
                    
                }
                .opacity(
                    products.isEmpty ||
                    isEditWork ||
                    work.status == .pending ? 0 : 1)
                .animation(.linear, value: hiddingAnimation)
                
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(company.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2))
        .blur(radius: openMenu ? 5 : 0)
        .disabled(openMenu)
        .overlay(alignment: .bottom) {
            WorkMenu(
                isEdit: $isEditWork,
                formTitle: $formTitle,
                openMenu: $openMenu,
                hiddingAnimation: $hiddingAnimation,
                startConfig: $startConfig,
                endConfig: $endConfig,
                tuple: TupleModel(company: company, work: work)
            )
            .environmentObject(viewModel)
            .offset(y: openMenu ? 0 : 1000)
        }
        .animation(.linear, value: openMenu)
        .navigationBarBackButtonHidden(openMenu || isEditWork)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    hideKeyboard()
                    openMenu.toggle()
                } label: {
                    Image(systemName: openMenu ? "xmark" : "filemenu.and.selection")
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .offUp.wholeSymbol), options: .nonRepeating))
                }
            }
        }
        .onAppear {
            viewModel.updateWorkDetails(with: work)
            startConfig = viewModel.workDetails.startDate.dateToConfig()
            endConfig = viewModel.workDetails.endDate.dateToConfig()
        }
        .onDisappear {
            viewModel.updateWorkDetails(with: nil)
        }
    }
}

struct Test_WorkDetailView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        WorkDetail(
            work: example_Work,
            company: example_Company
        )
        .environmentObject(viewModel)
    }
}

#Preview {
    Test_WorkDetailView()
}
