//
//  DetailVM.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import Foundation

struct DetailService {
    
    func fetchDetails(_ mealID: String) async throws -> Details {

        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else {
            throw ErrorType.badConnection
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Details.self, from: data)
            return decodedResponse
        } catch {
            throw ErrorType.notDecodable
        }
        
    }
}

@MainActor
final class DetailVM: ObservableObject {
    
    enum State {
        case notAvailable
        case loading
        case success(data: Details)
        case failed(error: ErrorType)
    }
    
    @Published var mealID: String
    @Published private(set) var state: State = .notAvailable
    @Published var hasError: ErrorType?
    
    private let service: DetailService
    
    init(service: DetailService, mealID: String = "") {
        self.service = service
        self.mealID = mealID
    }
    
    func fetchDetails() async {
        
        self.state = .loading
        self.hasError = nil
        
        do {
            let dessertDetails = try await service.fetchDetails(mealID)
            self.state = .success(data: dessertDetails)
        } catch {
            self.state = .failed(error: ErrorType.notDecodable)
            self.hasError = ErrorType.notDecodable
        }
    }
}
