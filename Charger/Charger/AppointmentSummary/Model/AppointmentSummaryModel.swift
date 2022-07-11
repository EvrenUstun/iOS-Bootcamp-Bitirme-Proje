//
//  AppointmentSummaryModel.swift
//  Charger
//
//  Created by Evren Ustun on 11.07.2022.
//

import Foundation

class AppointmentSummaryModel {
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func approveAppointment(_ stationId: Int, _ socketId: Int, _ timeSlot: String, _ appointmentDate: Date, completion: @escaping (Result<ApprovedAppointment, Error>) -> Void){
        var latitude: String
        var longitude: String
        if(ProjectRepository.longitude == nil || ProjectRepository.latitude == nil) {
            latitude = ""
            longitude = ""
        } else {
            latitude = "\(ProjectRepository.latitude!)"
            longitude = "\(ProjectRepository.longitude!)"
        }
        
        // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
        let parameters: [String: Any] = ["stationID": stationId, "socketID": socketId, "timeSlot": timeSlot, "appointmentDate": formatDate(date: appointmentDate)]
        
        let queryItems = [
            URLQueryItem(name: "userID", value: "\(ProjectRepository.user?.userId ?? 0)"),
            URLQueryItem(name: "userLatitude", value: latitude),
            URLQueryItem(name: "userLongitude", value: longitude)
        ]
        var urlComps = URLComponents(string: Constants.baseUrl + "/appointments/make")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ProjectRepository.user?.token ?? "", forHTTPHeaderField: "token")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
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
                let approvedAppointment = try JSONDecoder().decode(ApprovedAppointment.self, from: responseData)
                completion(.success(approvedAppointment))
                
            }catch{
                completion(.failure(error))
            }
        }
        // perform the task
        task.resume()
    }
    
    func getAppointmentSummary(_ stationId: Int, _ date: Date, completion: @escaping (Result<Appointment, Error>) -> Void){
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
                let summaryAppointment = try JSONDecoder().decode(Appointment.self, from: data)
                completion(.success(summaryAppointment))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
