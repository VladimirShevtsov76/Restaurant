//
//  MenuItem.swift
//  Restaurant
//
//  Created by Vladimir Shevtsov on 07.12.2021.
//

import Foundation

// Properties correspond to the keys listed in the API
struct MenuItem: Codable {
    var id:          Int
    var name:        String
    var description: String
    var price:       Double
    var category:    String
    var imageURL:    URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case category
        case imageURL = "image_url"
    }
}

// The top key returned by API is called items
struct MenuItems: Codable {
    let items: [MenuItem]
}
