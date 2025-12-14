//
//  EntryViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

final class EntryViewModel: ObservableObject {
    
    private var authService : AuthProtocol = UserConnection()
    var isConnected: Bool = false
    var isLoading: Bool = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    init() {
        self.isConnected = authService.getUid != nil
    }
    
    func loginUser() {
        guard
            username == "",
            password == ""
        else { return }
        
        self.isLoading = true
        DispatchQueue.main.async {
            
            self.authService.loginUser(email: self.username + "@gulermetsan.com", password: self.password) { result in
                switch result {
                    
                case .failure(_):
                    
                    print("Hata !")
                    self.authService.logout { result in }
                    self.isLoading = false
                    
                case .success(_):
                    self.isConnected = true
                    
                    self.username = ""
                    self.password = ""
                    
                    self.isLoading = false
                    
                }
            }
        }
    }
}
