//
//  EntryViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

final class EntryViewModel: ObservableObject {
    
    var userConnection : AuthProtocol
    
    @Binding var isPlaceHolder: Bool
    @Binding var isConnected : Bool
    
    @Published var isLogin : Bool = true
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    init(userConnection : AuthProtocol, isPlaceHolder: Binding<Bool>, isConnected : Binding<Bool>) {
        self.userConnection = userConnection
        self._isPlaceHolder = isPlaceHolder
        self._isConnected = isConnected
    }
    
    func loginUser() {
        
        if self.username == "" { return }
        if self.password == "" { return }
        
        self.isPlaceHolder = true
        DispatchQueue.main.async {
            
            self.userConnection.loginUser(email: self.username + "@gulermetsan.com", password: self.password) { result in
                switch result {
                    
                case .failure(_):
                    
                    print("Hata !")
                    self.userConnection.logout { result in }
                    self.isPlaceHolder = false
                    
                case .success(_):
                    self.isConnected = true
                    
                    self.username = ""
                    self.password = ""
                    
                    self.isPlaceHolder = false
      
                }
            }
        }
    }
    
    func registerUser() {
        
        if self.username == "" { return }
        if self.password == "" { return }
        
        self.isPlaceHolder = true
        DispatchQueue.main.async {
             
            self.userConnection.registerUser(email: self.username + "@gulermetsan.com", password: self.password) { result in
                switch result {
                    
                case .failure(_):
                    
                    print("Hata !")
                    self.userConnection.logout { result in }
                    self.isPlaceHolder = false
                    
                case .success(_):
                    self.isConnected = true
                    
                    self.username = ""
                    self.password = ""
                    
                    self.isPlaceHolder = false
                    
                }
            }
            
        }
        
    }
}
