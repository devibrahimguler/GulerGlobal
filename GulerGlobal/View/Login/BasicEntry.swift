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
    
    var loginActionText : String
    var complationText: String
    
    var complation : () -> ()
    var isLoginAction : () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {

                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Text("Guler Global")
                            .font(.system(size: 50, weight: .black, design: .rounded))
                            .foregroundStyle(colorScheme == .light ? .bSea : .hWhite)
                            .zIndex(2)
                        
                        ZStack {
                            Image("icon")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 200, style: .continuous))
                                .overlay {
                                    RoundedCorner(radius: 200).stroke(style: .init(lineWidth: 5))
                                        .fill(LinearGradient(colors: colorScheme == .light ?  [.bSea, .hWhite] : [.hWhite, .bSea], startPoint: .top, endPoint: .bottom))
                                }
                                .shadow(radius: 5)
                                .zIndex(1)
                            
                            ForEach(0...3, id: \.self) { i in
                                Circle() // Ball
                                    .fill(.star)
                                    .frame (width: 50, height: 50)
                                    .offset(y: -160 - Double(i) * 60)
                                    .rotationEffect(.degrees(isAnimation ? 360 : 0))
                                    .animation(.easeInOut(duration: Double(i) + 1).repeatForever(autoreverses: false), value: isAnimation)
                                    .shadow(color:colorScheme == .light ? .black : .white,radius: 3)
                                    .blur(radius: 10)
                            }
                            .zIndex(0)
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 100)
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "person.fill")
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.gray)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        TextField("", text: $username)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding(.leading)
                            .frame(height: 44)
                            .placeholder(when: username.isEmpty) {
                                    Text("Kullanıcı Adı".uppercased()).foregroundStyle(.gray)
                            }
                    }
                    
                    Divider()
                        .padding(.top, 4)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.gray)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        SecureField("", text: $password)
                            .autocorrectionDisabled(true)
                            .keyboardType(.default)
                            .padding(.leading)
                            .frame(height: 44)
                            .placeholder(when: password.isEmpty) {
                                    Text("Şifre".uppercased()).foregroundStyle(.gray)
                            }
                    }
                }
                .frame(height: 136)
                .frame(maxWidth: 712)
                .background(.hWhite)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
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
                .background(.hWhite)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
                .padding()
           
                
                Button(action: {
                    withAnimation(.snappy) {
                        isLoginAction()
                    }
                }) {
                    Text(loginActionText)
                }
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(.bBlue)
                .frame(maxWidth: .infinity,alignment: .center)

            }
            .font(.system(size: 15, weight: .black))
            .foregroundStyle(.black)
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
        BasicEntry(username: $username, password: $password, loginActionText: "Kayıt Olmak için tıklayın !", complationText: "Giriş Yap") {
            print("Complation")
        } isLoginAction: {
            print("Giriş Yapıldı")
        }

    }
}

#Preview {
    TestBasicEntry()
}
