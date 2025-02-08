//
//  CustomDatePicker.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 26.10.2024.
//

import SwiftUI

// MARK: - CustomDatePicker
struct CustomDatePicker: View {
    @Environment(\.colorScheme) var scheme
    @FocusState private var isFocused: Bool
    @Binding var dateConfig: DateConfig
    
    var title: FormTitle
    @Binding var activeTitle: FormTitle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DatePickerHeader(title: title)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                .overlay(borderOverlay(for: [.topLeft, .topRight]))
            Group {
                if activeTitle == title {
                    DatePickerOptionsSection(config: $dateConfig)
                } else {
                    CollapsedDateView(config: dateConfig) {
                        withAnimation(.snappy) {
                            activeTitle = title
                            hideKeyboard()
                        }
                    }
                }
            }
            .padding(.vertical, 5)
            .background(.white)
            .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight, .topRight]))
            .overlay(borderOverlay(for: [.bottomLeft, .bottomRight, .topRight]))
        }
        .frame(height: activeTitle == title ? 150 : 65)
        .padding(5)
    }
    
    private func borderOverlay(for corners: UIRectCorner) -> some View {
        RoundedCorner(radius: 10, corners: corners)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .fill(activeTitle == title ? Color.accentColor.gradient : Color.iRenk.gradient)
    }
}

// MARK: - HeaderView
struct DatePickerHeader: View {
    var title: FormTitle
    var body: some View {
        Text(title.rawValue)
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.white)
            .foregroundStyle(.black)
    }
}

// MARK: - DatePickerOptionsSection
struct DatePickerOptionsSection: View {
    @Binding var config: DateConfig
    var dayOptions = Array(1...30).map(String.init)
    var monthOptions = Array(1...12).compactMap { getMonthName(for: $0) }
    var yearOptions = Array(2000...2050).map(String.init)
    
    var body: some View {
        HStack {
            DatePickerColumn(title: "Gün", options: dayOptions, selectedValue: $config.selectedDay)
            DatePickerColumn(title: "Ay", options: monthOptions, selectedValue: $config.selectedMonth)
            DatePickerColumn(title: "Yıl", options: yearOptions, selectedValue: $config.selectedYear)
        }
    }
}

struct DatePickerColumn: View {
    var title: String
    var options: [String]
    @Binding var selectedValue: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding(.vertical, 5)
            
            Divider().padding(.horizontal)
            
            CustomPicker(options: options, selectedValue: $selectedValue)
        }
    }
}

// MARK: - CollapsedDateView
struct CollapsedDateView: View {
    var config: DateConfig
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(config.selectedDay)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("-")
                
                Text(config.selectedMonth)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("-")
                
                Text(config.selectedYear)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(5)
        }
    }
}

// MARK: - CustomPicker
fileprivate struct CustomPicker: View {
    var options: [String]
    @Binding var selectedValue: String
    
    @State private var activeValue: String?
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(options, id: \.self) { value in
                        PickerCard(value, size: size)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.bottom, size.height * 0.6)
            .scrollPosition(id: $activeValue, anchor: .top)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            
        }
        .task {
            /// Doing actions only for the first time.
            guard activeValue == nil else { return }
            activeValue = selectedValue
        }
        .onChange(of: activeValue) { oldValue, newValue in
            if let newValue {
                selectedValue = newValue
            }
        }
    }
    
    /// PickerCard
    @ViewBuilder
    private func PickerCard(_ value: String, size: CGSize) -> some View {
        GeometryReader { proxy in
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(selectedValue == value ? .accent : .gray)
                .scaleEffect(calculateScale(value), anchor: .center)
                .animation(.interactiveSpring, value: calculateScale(value))
                .opacity(calculateOpacity(proxy, size))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 25)
        .lineLimit(1)
    }
    
    private func calculateScale(_ text: String) -> CGSize {
        let defaultScale = CGSize(width: 0.5, height: 0.5)
        let activeScale = CGSize(width: 1.3, height: 1.3)
        let adjacentScale = CGSize(width: 0.7, height: 0.7)
        
        func isAdjacentOrEqual(_ value: Int, to activeValue: Int) -> Bool {
            return value == activeValue || value == activeValue + 1 || value == activeValue - 1
        }
        
        if let index = Int(text), let activeIndex = Int(activeValue ?? "0"), isAdjacentOrEqual(index, to: activeIndex) {
            return index == activeIndex ? activeScale : adjacentScale
        }
        
        if let monthIndex = getMonthIndex(for: text),
           let activeMonthIndex = getMonthIndex(for: activeValue ?? "1"),
           isAdjacentOrEqual(monthIndex, to: activeMonthIndex) {
            return monthIndex == activeMonthIndex ? activeScale : adjacentScale
        }
        
        return defaultScale
    }
    
    private func calculateOpacity(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = size.height * 0.3
        let progress = (minY / height) * 0.2
        /// Eliminating Negative Opacity
        let opacity = progress < 0 ? 1 + progress : 1 - progress
        return opacity
    }
    
    
    private func scale2(_ text: String) -> CGSize {
        var scale: CGSize = CGSize(width: 0.5, height: 0.5)
        if let index = Int(text) {
            if let newIndex = Int(activeValue ?? "0") {
                if index == newIndex {
                    scale = CGSize(width: 1.3, height: 1.3)
                } else if (newIndex + 1) == index || (newIndex - 1) == index  {
                    scale = CGSize(width: 0.7, height: 0.7)
                }
            }
        }
        
        if let mIndex = getMonthIndex(for: text) {
            if let mNewIndex = getMonthIndex(for: activeValue ?? "1") {
                if mIndex == mNewIndex {
                    scale = CGSize(width: 1.3, height: 1.3)
                } else if (mNewIndex + 1) == mIndex || (mNewIndex - 1) == mIndex  {
                    scale = CGSize(width: 0.7, height: 0.7)
                }
            }
        }
        
        return scale
    }
}

// MARK: - DateConfig Yapısı ve Yardımcı Fonksiyonlar
struct DateConfig {
    var selectedDay: String
    var selectedMonth: String
    var selectedYear: String
}

/// Verilen ay numarasına göre ay adını döner.
/// - Parameter month: 1 ile 12 arasında bir ay numarası.
/// - Returns: Türkçe ay adı veya geçersiz giriş durumunda boş bir string.
func getMonthName(for month: Int) -> String {
    guard (1...12).contains(month) else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "tr_TR")
    return dateFormatter.monthSymbols[month - 1]
}

/// Verilen Türkçe ay adına göre ay numarasını döner.
/// - Parameter monthName: Türkçe bir ay adı (örneğin: "Ocak", "Şubat").
/// - Returns: Ay numarası (1-12) veya geçersiz giriş durumunda `nil`.
func getMonthIndex(for monthName: String) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "tr_TR")
    let monthSymbols = dateFormatter.monthSymbols.map { $0.lowercased() }
    return monthSymbols.firstIndex(of: monthName.lowercased()).map { $0 + 1 }
}

struct TestCustomOption: View {
    @State private var config: DateConfig = DateConfig(
        selectedDay: "1",
        selectedMonth: getMonthName(for: 1),
        selectedYear: "2020")
    @State private var formTitle: FormTitle = .none
    
    var body: some View {
        CustomDatePicker(dateConfig: $config, title: .expDate, activeTitle: $formTitle)
    }
}

#Preview {
    VStack {
        TestCustomOption()
        TestCustomOption()
    }
}
