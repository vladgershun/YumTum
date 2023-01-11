//
//  DessertView.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import SwiftUI

struct DessertView: View {
    
    @StateObject private var dessertVM = DessertVM(service: DessertService())
    
    var body: some View {
        
        NavigationStack {
            switch dessertVM.state {
            case .success(let allDessert):
                List(allDessert, id: \.idMeal) { dessert in
                    NavigationLink(destination: DetailView(mealID: dessert.idMeal)) {
                        HStack {
                            AsyncImage(url: URL(string: dessert.strMealThumb), scale: 2) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .cornerRadius(10)
                            .frame(width: 60, height: 60)
                        }
                            Text(dessert.strMeal)
                    }
                }
                .navigationTitle("Desserts")
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .task {
            await dessertVM.fetchAllDessert()
        }
//        .alert(isPresented: $pokemonVM.hasError.isPresent, error: pokemonVM.hasError) { }
        
    }
}

struct DessertView_Previews: PreviewProvider {
    static var previews: some View {
        DessertView()
    }
}




