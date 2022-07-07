//
//  CityAPI.swift
//  Charger
//
//  Created by Evren Ustun on 27.06.2022.
//

import Foundation

class StationModel{
    
    func getAllStation(_ city: String, _ chargerTypeFilter: [String], _ socketTypeFilter: [String], _ serviceFilter: [String], _ distance: Float, completion: @escaping (Result<[Station], Error>) -> Void){
        
        var latitude: String
        var longitude: String
        if(ProjectRepository.longitude == nil || ProjectRepository.latitude == nil) {
            latitude = ""
            longitude = ""
        } else {
            latitude = "\(ProjectRepository.latitude!)"
            longitude = "\(ProjectRepository.longitude!)"
        }
        
        let queryItems = [
            URLQueryItem(name: "userID", value: "\(ProjectRepository.user.userId!)"),
            URLQueryItem(name: "userLatitude", value: latitude),
            URLQueryItem(name: "userLongitude", value: longitude)
        ]
        var urlComps = URLComponents(string: Constants.baseUrl + "/stations")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        var request = URLRequest(url: url)
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ProjectRepository.user.token ?? "", forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            do{
                var filteredByCityStations: [Station] = []
                // Decode response
                let stations = try JSONDecoder().decode([Station].self, from: data)
                for station in stations {
                    if station.geoLocation?.province == city{
                        filteredByCityStations.append(station)
                    }
                }
                // statins filter by charger type, socket type, service and distance
                filteredByCityStations = self.filteredByChargerType(filteredByCityStations, chargerTypeFilter, socketTypeFilter, serviceFilter, distance)
                // Stations sort by km
                filteredByCityStations.sort {
                    $0.distanceInKM! < $1.distanceInKM!
                }
                completion(.success(filteredByCityStations))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - private filter func
    // Nested filtering functions are arranged according to the conditions
    private func filteredByChargerType(_ filteredByCityStations: [Station], _ chargerTypeFilter: [String], _ socketTypeFilter: [String], _ serviceFilter: [String], _ distance: Float) -> [Station]{
        
        if !chargerTypeFilter.isEmpty {
            if chargerTypeFilter.count == 1 {
                return filteredBySocketType(filteredByCityStations.filter({ $0.sockets!.contains(where: { $0.chargeType == chargerTypeFilter[0] })}), socketTypeFilter,serviceFilter,distance)
            }else {
                return filteredBySocketType(filteredByCityStations.filter({ $0.sockets!.contains(where: { $0.chargeType == chargerTypeFilter[0] || $0.chargeType == chargerTypeFilter[1] })}), socketTypeFilter,serviceFilter,distance)
            }
        }
        
        return filteredBySocketType(filteredByCityStations,socketTypeFilter,serviceFilter,distance)
    }
    
    private func filteredBySocketType(_ filteredByChargerTypeStations: [Station], _ socketTypeFilter: [String], _ serviceFilter: [String], _ distance: Float) -> [Station]{
        
        if !socketTypeFilter.isEmpty {
            if socketTypeFilter.count == 1 {
                return filteredByServiceType(filteredByChargerTypeStations.filter({ $0.sockets!.contains(where: { $0.socketType == socketTypeFilter[0] })}),serviceFilter,distance)
            }else if socketTypeFilter.count == 2{
                return filteredByServiceType(filteredByChargerTypeStations.filter({ $0.sockets!.contains(where: { $0.socketType == socketTypeFilter[0] || $0.socketType == socketTypeFilter[1]})}),serviceFilter,distance)
            }else {
                return filteredByServiceType(filteredByChargerTypeStations.filter({ $0.sockets!.contains(where: { $0.socketType == socketTypeFilter[0] || $0.socketType == socketTypeFilter[1] || $0.socketType == socketTypeFilter[2]})}),serviceFilter,distance)
            }
        }
        
        return filteredByServiceType(filteredByChargerTypeStations, serviceFilter, distance)
    }
    
    
    private func filteredByServiceType(_ filteredBySocketTypeStations: [Station], _ serviceFilter: [String], _ distance: Float) -> [Station]{
        
        if !serviceFilter.isEmpty {
            if serviceFilter.count == 1 {
                return filteredByDistance(filteredBySocketTypeStations.filter({ $0.services!.contains(where: { $0 == serviceFilter[0] })}),distance)
            }else if serviceFilter.count == 2{
                return filteredByDistance(filteredBySocketTypeStations.filter({ $0.services!.contains(where: { $0 == serviceFilter[0] || $0 == serviceFilter[1] })}),distance)
            }else {
                return filteredByDistance(filteredBySocketTypeStations.filter({ $0.services!.contains(where: { $0 == serviceFilter[0] || $0 == serviceFilter[1] || $0 == serviceFilter[2] })}),distance)
            }
        }
        return filteredByDistance(filteredBySocketTypeStations, distance)
    }
    
    private func filteredByDistance(_ filteredByServiceStations: [Station], _ distance: Float) -> [Station] {
        switch distance{
        case 15:
            return filteredByServiceStations
        case 12:
            return filteredByServiceStations.filter { $0.distanceInKM! <= 12.0 }
        case 9:
            return filteredByServiceStations.filter { $0.distanceInKM! <= 9.0 }
        case 6:
            return filteredByServiceStations.filter { $0.distanceInKM! <= 6.0 }
        case 3:
            return filteredByServiceStations.filter { $0.distanceInKM! <= 3.0 }
        default:
            return filteredByServiceStations
        }
    }
}
