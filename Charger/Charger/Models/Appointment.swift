//
//  Appointment.swift
//  Charger
//
//  Created by Evren Ustun on 9.07.2022.
//

import Foundation

// MARK: - Appointment
struct Appointment: Decodable {
    var stationID: Int?
    var stationCode: String?
    var sockets: [Socket]?
    var geoLocation: GeoLocation?
    var services: [String]?
    var stationName: String?
}

struct ApprovedAppointment: Decodable {
    var time: String?
    var date: String?
    var station: Station?
    var stationCode: String?
    var userID: Int?
    var socketID: Int?
    var stationName: String?
    var appointmentID: Int?
    var hasPassed: Bool?
}

// MARK: - Day
struct Day: Decodable {
    var id: Int?
    var date: String?
    var timeSlots: [TimeSlot]?
}

// MARK: - TimeSlot
struct TimeSlot: Decodable {
    var slot: String?
    var isOccupied: Bool?
}
