//
//  UserConnection.swift
//  GulerGlobal
//
//  Created by ibrahim Güler on 19.07.2024.
//

import FirebaseAuth

protocol AuthProtocol {
    var getUserName : String? { get }
    var getUid : String? { get }
    
    func logout(completion : @escaping (Result<Bool, AuthError>) -> ()) 
    func loginUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
    func registerUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ())
}

struct UserConnection : AuthProtocol {
    
    private let auth : Auth = Auth.auth()
    
    var getUserName : String? {
        guard let currentUser = auth.currentUser else { return nil }
        guard let username = currentUser.email?.split(separator: "@").first else { return nil }
        return String(username)
    }
    
    var getUid : String? {
        guard let currentUser = auth.currentUser else { return nil }
        return currentUser.uid
    }
    
    func logout(completion : @escaping (Result<Bool, AuthError>) -> ()) {
        do {
            try auth.signOut()
            completion(.success(false))
        } catch {
            print("Logout eror : \(error.localizedDescription)")
        }
     
    }
    
    func loginUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ()) {
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard error == nil  else {
                completion(.failure(.haveError))
                return
            }
            
            guard let result = result else {
                completion(.failure(.dontHandleData))
                return
            }
            
            completion(.success(result))
        }
    }
    
    func registerUser(email: String, password: String, completion : @escaping (Result<AuthDataResult, AuthError>) -> ()) {
        auth.createUser(withEmail: email, password: password) { result, error in
            
            guard error == nil else {
                completion(.failure(.haveError))
                return
            }
            
            guard let result = result  else {
                completion(.failure(.dontHandleData))
                return
            }
            
            completion(.success(result))
        }
    }
    
}

enum AuthError : Error {
    case haveError
    case dontHandleData
}
