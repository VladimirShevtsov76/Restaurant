//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Vladimir Shevtsov on 07.12.2021.
//

// Correspond to keys returned by the API under categories
struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
