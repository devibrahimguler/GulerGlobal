//
//  StatementViewModel.swift
//  GulerGlobal
//
//  Refactored from MainViewModel — SRP: Statement CRUD only.
//

import SwiftUI

@MainActor
final class StatementViewModel: ObservableObject {
    private let dataModel: StatementDataModel
    
    @Published var statements: [Statement] = []
    @Published var statementDetails = StatementDetails()
    
    init(dataModel: StatementDataModel) {
        self.dataModel = dataModel
    }
    
    // MARK: - Queries
    
    func updateDetails(with statement: Statement?) {
        statementDetails = StatementDetails(from: statement)
    }
    
    // MARK: - CRUD
    
    func create(statement: Statement, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.saveStatement(statement)
                await MainActor.run {
                    self.statements.append(statement)
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
    
    func update(statementId: String, statementDetails: StatementDetails, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                guard
                    let index = self.statements.firstIndex(where: { $0.id == statementId }),
                    statementDetails.amount != ""
                else { return }
                
                let amount = statementDetails.amount.toDouble()
                let date = statementDetails.date
                let status = statementDetails.status
                
                let updateArea = [
                    "amount": amount,
                    "date": date,
                    "status": status.rawValue
                ]
                
                try await dataModel.updateStatement(statementId, updateArea: updateArea)
                
                await MainActor.run {
                    self.statements[index] = Statement(
                        id: self.statements[index].id,
                        companyId: self.statements[index].companyId,
                        amount: amount,
                        date: date,
                        status: status
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
    
    func delete(statementId: String, setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        Task {
            do {
                try await dataModel.deleteStatement(statementId)
                await MainActor.run {
                    self.statements.removeAll { $0.id == statementId }
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
    
    func multipleDelete(statementIds: [String], setLoading: @escaping (Bool) -> Void) {
        setLoading(true)
        dataModel.deleteMultipleStatement(statementIds) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Toplu silme hatası: \(error.localizedDescription)")
                setLoading(false)
            } else {
                self.statements.removeAll { statementIds.contains($0.id) }
                setLoading(false)
            }
        }
    }
}
