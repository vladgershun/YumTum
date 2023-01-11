//
//  DetailView.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import SwiftUI

struct DetailView: View {
    
    var mealID: String
    @StateObject private var detailVM = DetailVM(service: DetailService())
    
    var body: some View {
        ZStack {
            switch detailVM.state {
            case .success(let details):
                List(details, id: \.idMeal) { dessert in
                    Section {
                        AsyncImage(url: URL(string: dessert.strMealThumb), scale: 2) { image in
                            image
                                .resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        
                        DisclosureGroup {
                            Text(dessert.strInstructions)
                        } label: {
                            HStack(spacing: 20) {
                                Image(systemName: "book")
                                Text("Instructions")
                            }
                        }
                        
                        DisclosureGroup {
                            IngredientsView(ingredients: dessert.ingredients)
                        } label: {
                            HStack(spacing: 20) {
                                Image(systemName: "cart")
                                Text("Ingredients")
                            }
                        }
                        
                    } header: {
                        Text(dessert.strMeal)
                            .font(.title2)
                    }
                }
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .task(id: detailVM.mealID) {
            detailVM.mealID = self.mealID
            await detailVM.fetchDetails()
        }
        .alert(isPresented: $detailVM.hasError.isPresent, error: detailVM.hasError) { }
    }
}

struct IngredientsView: View {
    var ingredients: [Recipe.Ingredient]

    var body: some View {
        ForEach(ingredients, id: \.ingredient) { item in
            HStack {
                Text("• \(item.ingredient)")
                Spacer()
                Text(item.measurement)
            }
        }
    }
}
