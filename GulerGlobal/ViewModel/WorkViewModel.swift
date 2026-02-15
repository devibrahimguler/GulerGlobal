//
//  WorkViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: Work CRUD only.
//

import SwiftUI

@MainActor
final class WorkViewModel: ObservableObject {
    private let dataModel: WorkDataModel
    
    @Published var works: [Work] = []
    @Published var workDetails = WorkDetails()
    
    init(dataModel: WorkDataModel) {
        self.dataModel = dataModel
    }
    
    // MARK: - Queries
    
    func generateUniqueID() -> String {
        let highestID = works.compactMap { Int($0.id) }.max() ?? 0
        return String(format: "%04d", highestID + 1)
    }
    
    func updateDetails(with work: Work?) {
        workDetails = WorkDetails(from: work)
    }
    
    // MARK: - CRUD
    
    func create(work: Work, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.saveWork(work)
                await MainActor.run {
                    self.works.append(work)
                    setLoading(false)
                }
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    setLoading(false)
                }
            }
        }
    }
    
    func update(workId: String, workDetails: WorkDetails, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                guard
                    let index = self.works.firstIndex(where: { $0.id == workId }),
                    workDetails.name != "",
                    workDetails.description != "",
                    workDetails.cost != "",
                    workDetails.left != ""
                else { return }
                
                let name = workDetails.name.trim()
                let description = workDetails.description.trim()
                let cost = workDetails.cost.toDouble()
                let left = workDetails.left.toDouble()
                let status = workDetails.status
                let startDate = workDetails.startDate
                let endDate = workDetails.endDate
                
                let updateArea = [
                    "name": name,
                    "description": description,
                    "cost": cost,
                    "left": left,
                    "status": status.rawValue,
                    "startDate": startDate,
                    "endDate": endDate,
                ]
                
                try await dataModel.updateWork(workId, updateArea: updateArea)
                
                await MainActor.run {
                    self.works[index] = Work(
                        id: workId,
                        companyId: self.works[index].companyId,
                        name: name,
                        description: description,
                        cost: cost,
                        left: left,
                        status: status,
                        startDate: startDate,
                        endDate: endDate
                    )
                    self.updateDetails(with: nil)
                    setLoading(false)
                }
                
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    self.updateDetails(with: nil)
                    setLoading(false)
                }
            }
        }
    }
    
    func delete(workId: String, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.deleteWork(workId)
                await MainActor.run {
                    self.works.removeAll { $0.id == workId }
                    setLoading(false)
                }
            } catch {
                print("Kayıt hatası oluştu: \(error.localizedDescription)")
                await MainActor.run {
                    setLoading(false)
                }
            }
        }
    }
    
    func multipleDelete(workIds: [String], setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        dataModel.deleteMultipleWork(workIds) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                setLoading(false)
            } else {
                self.works.removeAll { workIds.contains($0.id) }
                setLoading(false)
            }
        }
    }
}
