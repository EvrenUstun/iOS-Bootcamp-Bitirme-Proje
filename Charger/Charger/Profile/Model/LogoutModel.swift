//
//  LoginAPI.swift
//  Charger
//
//  Created by Evren Ustun on 25.06.2022.
//
import Foundation
import UIKit

class LogoutModel{

    func logoutRequest(completion: @escaping (Result<Int, Error>) -> Void) {

        // create the url with URL
        guard let url = URL(string: Constants.baseUrl + "/auth/logout/\(ProjectRepository.user?.userId ?? 0)") else{
            return
        }

        // create the session object
        let session = URLSession.shared

        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
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
            completion(.success(httpResponse.statusCode))
        }
        // perform the task
        task.resume()
    }
}
