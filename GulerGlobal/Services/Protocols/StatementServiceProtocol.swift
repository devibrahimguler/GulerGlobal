
import Foundation

protocol StatementServiceProtocol {
    var statementCollectionName: String { get }
    
    func fetchStatements(completion: @escaping (Result<[Statement], Error>) -> Void) async throws
    func saveStatement(_ statement: Statement) async throws
    func updateStatement(_ statementId: String, updateArea: [String: Any]) async throws
    func deleteStatement(_ statementId: String) async throws
    func deleteMultipleStatement(_ statementIds: [String], completion: @escaping ((any Error)?) -> Void)
}
