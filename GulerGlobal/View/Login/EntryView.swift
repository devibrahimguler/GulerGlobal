//
//  EntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct EntryView: View {
    
    // @ObservedObject var viewModel: EntryViewModel
    @EnvironmentObject var viewModel: EntryViewModel
    
    var body: some View {
        ZStack {
            BasicEntry(
                username: $viewModel.username,
                password: $viewModel.password,
                complationText: "Giriş Yap") { viewModel.loginUser() }
        }
    }
}
