//
//  SelectDateModel.swift
//  Charger
//
//  Created by Evren Ustun on 9.07.2022.
//

import Foundation

class SelectDateModel {
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getAvailableAppointments(_ stationId: Int, _ date: Date, completion: @escaping (Result<Appointment, Error>) -> Void){
        let queryItems = [
            URLQueryItem(name: "userID", value: "\(ProjectRepository.user?.userId ?? 0)"),
            URLQueryItem(name: "date", value: formatDate(date: date))
        ]
        var urlComps = URLComponents(string: Constants.baseUrl + "/stations/\(stationId)")! // \(stationId)
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        var request = URLRequest(url: url)
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ProjectRepository.user?.token ?? "", forHTTPHeaderField: "token")
        
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
                let availableAppointment = try JSONDecoder().decode(Appointment.self, from: data)
                completion(.success(availableAppointment))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
