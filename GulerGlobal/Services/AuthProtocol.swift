//
//  AuthProtocol.swift
//  GulerGlobal
//
//  Created by ibrahim on 1.02.2026.
//

import FirebaseAuth

protocol AuthProtocol {
    var getUserName : String? { get }
    var getUid : String? { get }
    
    func logout(completion : @escaping (Result<Bool, AuthError>) -> ()) 
    func loginUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
    func registerUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
}
