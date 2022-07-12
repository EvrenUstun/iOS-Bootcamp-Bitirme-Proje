//
//  HomePageModel.swift
//  Charger
//
//  Created by Evren Ustun on 11.07.2022.
//

import Foundation

class HomePageModel {
    
    func deleteAppointment(_ appointmentId: Int?,completion: @escaping (Result<Int, Error>) -> Void){
        let queryItems = [
            URLQueryItem(name: "userID", value: "\(ProjectRepository.user?.userId ?? 0)")
        ]
        
        var urlComps = URLComponents(string: Constants.baseUrl + "/appointments/cancel/\(appointmentId ?? 0)")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!

        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)

        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ProjectRepository.user?.token ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "DELETE"
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            do{
                completion(.success(httpResponse.statusCode))
            }catch{
                completion(.failure(error))
            }
        }
        // perform the task
        task.resume()
    }
    
    func getUserAppointments(completion: @escaping (Result<[ApprovedAppointment], Error>) -> Void){
        
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
            URLQueryItem(name: "userLatitude", value: latitude),
            URLQueryItem(name: "userLongitude", value: longitude)
        ]
        
        var urlComps = URLComponents(string: Constants.baseUrl + "/appointments/\(ProjectRepository.user?.userId ?? 0)")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!

        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ProjectRepository.user?.token ?? "", forHTTPHeaderField: "token")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do{
                // Decode response
                let approvedAppointment = try JSONDecoder().decode([ApprovedAppointment].self, from: responseData)
                completion(.success(approvedAppointment))
            }catch{
                completion(.failure(error))
            }
        }
        // perform the task
        task.resume()
    }
}
