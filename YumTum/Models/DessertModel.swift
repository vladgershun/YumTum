//
//  DessertModel.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import Foundation

struct AllDessert: Codable {
    var meals: [Dessert]
}

struct Dessert: Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}
