//
//  EntryViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

final class EntryViewModel: ObservableObject {
    private var authService : AuthProtocol = UserConnection()
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var isConnected: Bool = false

    
    func loginUser() {
        guard
            !username.isEmpty,
            !password.isEmpty
        else { return }
        
       isLoading = true
        self.authService.loginUser(email: self.username + "@gulermetsan.com", password: self.password) { result in
            switch result {
                
            case .failure(_):
                
                print("Hata !")
                self.authService.logout { result in }
                isLoading = false
                
            case .success(_):
                self.isConnected = true
                
                self.username = ""
                self.password = ""
                
                self.isLoading = false
                
            }
        }
    }
}
