//
//  AuthServiceProtocol.swift
//  GulerGlobal
//
//  Created by ibrahim on 31.12.2025.
//

import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUserName : String? { get }
    var isSignedIn : Bool { get }
    
    func logout(completion : @escaping (Result<Bool, AuthError>) -> ())
    func loginUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
    func registerUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
}
