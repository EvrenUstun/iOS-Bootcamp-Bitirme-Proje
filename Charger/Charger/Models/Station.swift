//
//  Station.swift
//  Charger
//
//  Created by Evren Ustun on 4.07.2022.
//

import Foundation

struct Station: Decodable {
    var id: Int?
    var stationCode: String?
    var sockets: [Socket]?
    var socketCount: Int?
    var occupiedSocketCount: Int?
    var distanceInKM: Double?
    var geoLocation: GeoLocation?
    var services: [String]?
    var stationName: String?
}

// MARK: - Socket
struct Socket: Decodable {
    var socketID: Int?
    var socketType: String?
    var chargeType: String?
    var power: Int?
    var powerUnit: String?
    var socketNumber: Int?
}

// MARK: - GeoLocation
struct GeoLocation: Decodable {
    var longitude: Double?
    var latitude: Double?
    var province: String?
    var address: String?
}
