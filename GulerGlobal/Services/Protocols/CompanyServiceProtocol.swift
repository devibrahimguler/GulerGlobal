
import Foundation

protocol CompanyServiceProtocol {
    var companyCollectionName: String { get }
    
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) async throws
    func saveCompany(_ company: Company) async throws
    func updateCompany(_ companyId: String, updateArea: [String: Any]) async throws
    func deleteCompany(_ companyId: String) async throws
}
