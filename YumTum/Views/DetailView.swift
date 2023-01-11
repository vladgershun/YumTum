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
                Section {
                    AsyncImage(url: URL(string: details.strMealThumb), scale: 2) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.gray
                    }
                    
                    DisclosureGroup {
                        Text(details.strInstructions)
                    } label: {
                        HStack(spacing: 20) {
                            Image(systemName: "book")
                            Text("Instructions")
                        }
                    }
                    
//                    DisclosureGroup {
//                        IngredientsView(ingredients: details.ingredients)
//                    } label: {
//                        HStack(spacing: 20) {
//                            Image(systemName: "cart")
//                            Text("Ingredients")
//                        }
//                    }
                    
                } header: {
                    Text(details.strMeal)
                        .font(.title2)
                }
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .task {
            detailVM.mealID = self.mealID
            await detailVM.fetchDetails()
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}


//struct IngredientsView: View {
//    var ingredients: [Details.Ingredient]
//
//    var body: some View {
//        ForEach(ingredients, id: \.ingredient) { item in
//            HStack {
//                Text("• \(item.ingredient)")
//                Spacer()
//                Text(item.measurement)
//            }
//        }
//    }
//}
