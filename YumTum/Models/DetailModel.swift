//
//  DetailModel.swift
//  YumTum
//
//  Created by Vlad Gershun on 1/10/23.
//

import Foundation

struct Details: Decodable {
    
    public let idMeal: String
    public let strMeal: String
    public let strMealThumb: String
    public let strInstructions: String

    public struct Ingredient: Equatable {
        public var ingredient: String
        public var measurement: String
    }

    public var ingredients: [Ingredient]

    struct StringCodingKey: CodingKey {
        var stringValue: String

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? {
            return nil
        }

        init?(intValue: Int) {
            return nil
        }
    }

    public init(idMeal: String, strMeal: String, strMealThumb: String, strInstructions: String, ingredients: [(String, String)]) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.strInstructions = strInstructions
        self.ingredients = ingredients.map{ name, measurement in Ingredient(ingredient: name, measurement: measurement) }
//        let f = Ingredient.init(ingredient:measurement:)
//        self.ingredients = ingredients.map(f)
    }

    public init(from decoder: Decoder) throws {
        ingredients = []

        let mealsContainer = try decoder.container(keyedBy: StringCodingKey.self)
        self.idMeal = try mealsContainer.decode(String.self, forKey: StringCodingKey(stringValue: "idMeal"))
        self.strMeal = try mealsContainer.decode(String.self, forKey: StringCodingKey(stringValue: "strMeal"))
        self.strMealThumb = try mealsContainer.decode(String.self, forKey: StringCodingKey(stringValue: "strMealThumb"))
        self.strInstructions = try mealsContainer.decode(String.self, forKey: StringCodingKey(stringValue: "strInstructions"))
        for i in 1...20 {
            guard
                let tempIngredient = try mealsContainer.decode(String?.self, forKey: StringCodingKey(stringValue: "strIngredient\(i)")),
                let tempMeasurement = try mealsContainer.decode(String?.self, forKey: StringCodingKey(stringValue: "strMeasure\(i)")),
                !tempIngredient.isEmpty,
                !tempMeasurement.isEmpty
            else {
                //no-op, value did not exist
                continue
            }
            ingredients.append(Ingredient(ingredient: tempIngredient, measurement: tempMeasurement))
        }
    }
}


//● Meal name
//● Instructions
//● Ingredients/measurements


//● Be sure to filter out any null or empty values from the API before displaying them.
//● UI/UX design is not what you’re being evaluated on, but the app should be user friendly and
//should take basic app design principles into account.
//● Project should compile using the latest version of Xcode.
