
import Foundation

protocol WorkServiceProtocol {
    var workCollectionName: String { get }
    
    func fetchWorks(completion: @escaping (Result<[Work], Error>) -> Void) async throws
    func saveWork(_ work: Work) async throws
    func updateWork(_ workId: String, updateArea: [String: Any]) async throws
    func deleteWork(_ workId: String) async throws
    func deleteMultipleWork(_ workIds: [String], completion: @escaping ((any Error)?) -> Void)
}
