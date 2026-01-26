//
//  DataServiceProtocol.swift
//  GulerGlobal
//
//  Created by ibrahim on 31.12.2025.
//

import Foundation


import Foundation

protocol DataServiceProtocol: CompanyServiceProtocol, WorkServiceProtocol, ProductServiceProtocol, StatementServiceProtocol {
    func fetchAllData(completion: @escaping (Result<([Company], [Work], [CompanyProduct], [WorkProduct], [Statement]), Error>) -> Void) async throws
}
