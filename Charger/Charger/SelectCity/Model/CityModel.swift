//
//  CityAPI.swift
//  Charger
//
//  Created by Evren Ustun on 27.06.2022.
//

import Foundation

class CityModel{
    
    func getAllCities(completion: @escaping (Result<[String], Error>) -> Void){
        
        let queryItems = [URLQueryItem(name: "userID", value: "\(ProjectRepository.user.userId!)")]
        var urlComps = URLComponents(string: Constants.baseUrl + "/provinces")!
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
                // Decode response
                let cities = try JSONDecoder().decode([String].self, from: data)
                completion(.success(cities))
            }catch{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
