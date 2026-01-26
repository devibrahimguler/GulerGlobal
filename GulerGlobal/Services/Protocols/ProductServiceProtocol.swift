
import Foundation

protocol ProductServiceProtocol {
    var companyProductCollectionName: String { get }
    var workProductCollectionName: String { get }
    
    func fetchCompanyProducts(completion: @escaping (Result<[CompanyProduct], Error>) -> Void) async throws
    func fetchWorkProducts(completion: @escaping (Result<[WorkProduct], Error>) -> Void) async throws
    
    func saveCompanyProduct(_ product: CompanyProduct) async throws
    func updateCompanyProduct(_ productId: String, updateArea: [String: Any]) async throws
    func deleteCompanyProduct(_ productId: String) async throws
    func deleteMultipleCompanyProduct(_ productIds: [String], completion: @escaping ((any Error)?) -> Void)
    
    func saveWorkProduct(_ product: WorkProduct) async throws
    func updateWorkProduct(_ productId: String, updateArea: [String: Any]) async throws
    func deleteWorkProduct(_ productId: String) async throws
    func deleteMultipleWorkProduct(_ productIds: [String], completion: @escaping ((any Error)?) -> Void)
}
