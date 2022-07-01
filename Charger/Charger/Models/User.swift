//
//  User.swift
//  Charger
//
//  Created by Evren Ustun on 25.06.2022.
//

import Foundation

struct User: Decodable {
    var email: String?
    var userId: Int?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case userId = "userID"
        case token
    }
}
