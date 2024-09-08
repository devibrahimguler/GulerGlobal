//
//  MainViewModel.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 8.09.2024.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    let userConnection: AuthProtocol = UserConnection()
    let dataModel: FirebaseDataModel = FirebaseDataModel()
    
    @Published var isPlaceHolder: Bool = false
    @Published var isConnected: Bool = false
    
    
    init() {
        // dataModel.fetchData()
        
        if self.userConnection.getUid != nil {
            self.isConnected = true
        }
        
    }
}
