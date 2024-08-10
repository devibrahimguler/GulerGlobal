//
//  ContentView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataModel: FirebaseDataModel = .init()
    
    var body: some View {
        if dataModel.isPlaceHolder {
            CustomPlaceHolder()
        } else if dataModel.isConnected {
            MainView()
            .environmentObject(dataModel)
        } else {
            EntryView(userConnection: dataModel.userConnection, isPlaceHolder: $dataModel.isPlaceHolder, isConnected: $dataModel.isConnected)
                .environmentObject(dataModel)
            
        }
    }
}

#Preview {
    ContentView()
}
