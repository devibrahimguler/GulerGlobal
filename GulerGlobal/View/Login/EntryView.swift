//
//  EntryView.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import SwiftUI

struct EntryView: View {
    
    @ObservedObject var dataModel: EntryViewModel
    
    init(userConnection : AuthProtocol, isPlaceHolder: Binding<Bool>, isConnected: Binding<Bool>) {
        self.dataModel = EntryViewModel(userConnection: userConnection, isPlaceHolder: isPlaceHolder, isConnected: isConnected)
    }
    
    var body: some View {
        ZStack {
            BasicEntry(
                username: $dataModel.username,
                password: $dataModel.password,
                // loginActionText: "Kayıt olmak için tıkla!",
                complationText: "Giriş Yap") { dataModel.loginUser() }
                // isLoginAction: { dataModel.isLogin = false }
            .offset(x:dataModel.isLogin ? 0 : getRect().width * 2)
            
            /*
             BasicEntry(
                 username: $dataModel.username,
                 password: $dataModel.password,
                 loginActionText: "Giriş yapmak için tıklayın!",
                 complationText: "Kayıt Ol") {
                 dataModel.registerUser()
             } isLoginAction: {
                 dataModel.isLogin = true
             }
             .offset(x:dataModel.isLogin ? -getRect().width * 2 : 0)
             */
        }
        .animation(.easeInOut, value: dataModel.isLogin)
    }
}
