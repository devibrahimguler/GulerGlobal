//
//  BasicEntry.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 25.07.2024.
//

import SwiftUI

struct BasicEntry: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimation = false
    
    @Binding var username : String
    @Binding var password : String
    
    // var loginActionText : String
    var complationText: String
    
    var complation : () -> ()
    // var isLoginAction : () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .center) {
                
                Spacer()
                
                CustomPlaceHolder(distance: 1)
                
                Spacer()
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "person.fill")
                            .frame(width: 44, height: 44)
                            .glassEffect(in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.leading)
                        
                        TextField("", text: $username)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding(.leading)
                            .frame(height: 44)
                            .placeholder(when: username.isEmpty) {
                                    Text("Kullanıcı Adı".uppercased())
                            }
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .frame(width: 44, height: 44)
                            .glassEffect(in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.leading)
                        
                        SecureField("", text: $password)
                            .autocorrectionDisabled(true)
                            .keyboardType(.default)
                            .padding(.leading)
                            .frame(height: 44)
                            .placeholder(when: password.isEmpty) {
                                    Text("Şifre".uppercased())
                            }
                    }
                }
                .frame(height: 136)
                .frame(maxWidth: 712)
                .glassEffect(in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
                
                Button(action: {
                    withAnimation(.snappy) {
                        complation()
                    }
                }) {
                    Text(complationText.uppercased())
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .padding(.horizontal, 20)
                .glassEffect(in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
           
                
                /*
                 Button(action: {
                     withAnimation(.snappy) {
                         isLoginAction()
                     }
                 }) {
                     Text(loginActionText)
                 }
                 .font(.system(size: 13, weight: .black))
                 .foregroundStyle(colorScheme == .light ? .black : .white)
                 .frame(maxWidth: .infinity,alignment: .center)
                 */

            }
            .font(.system(size: 15, weight: .black))
            .foregroundStyle(colorScheme == .light ? .black.opacity(0.65) : .white.opacity(0.65))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding()
            .onAppear {
                self.isAnimation.toggle()
            }
            
        }
    }
}

struct TestBasicEntry: View {
    
    @State var username : String = ""
    @State var password : String = ""
    @State var isLogin : Bool = true
    
    var body: some View {
        BasicEntry(username: $username, password: $password,
                   // loginActionText: "Kayıt Olmak için tıklayın !",
                   complationText: "Giriş Yap") {
            print("Complation")
        }
        // isLoginAction: { print("Giriş Yapıldı") }
    }
}

#Preview {
    TestBasicEntry()
}
