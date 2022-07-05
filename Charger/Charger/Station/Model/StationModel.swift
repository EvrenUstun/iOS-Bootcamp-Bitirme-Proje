//
//  CityAPI.swift
//  Charger
//
//  Created by Evren Ustun on 27.06.2022.
//

import Foundation

class StationModel{
    
    func getAllStation(_ city: String,completion: @escaping (Result<[Station], Error>) -> Void){
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
        print("Station url: \(url)")
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
                var filteredStations: [Station] = []
                // Decode response
                let stations = try JSONDecoder().decode([Station].self, from: data)
                for station in stations {
                    if station.geoLocation?.province == city{
                        filteredStations.append(station)
                    }
                }
                completion(.success(filteredStations))
            }catch{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
