//
//  DessertVM.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import Foundation

struct DessertService {
    
    func fetchDessert() async throws -> [Dessert] {
        
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            throw ErrorType.badConnection
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AllDessert.self, from: data)
            let results = decodedResponse.meals.sorted{ $0.strMeal < $1.strMeal }
            return results
        } catch {
            throw ErrorType.notDecodable
        }
    }
}

@MainActor
final class DessertVM: ObservableObject {
    
    enum State {
        case notAvailable
        case loading
        case success(data: [Dessert])
        case failed(error: ErrorType)
    }
    
    @Published private(set) var state: State = .notAvailable
    @Published var hasError: ErrorType?
    
    private let service: DessertService
    
    init(service: DessertService) {
        self.service = service
    }
    
    func fetchAllDessert() async {
        
        self.state = .loading
        self.hasError = nil
        
        do {
            let allDessert = try await service.fetchDessert()
            self.state = .success(data: allDessert)
        } catch {
            self.state = .failed(error: ErrorType.notDecodable)
            self.hasError = ErrorType.notDecodable
        }
    }
}
