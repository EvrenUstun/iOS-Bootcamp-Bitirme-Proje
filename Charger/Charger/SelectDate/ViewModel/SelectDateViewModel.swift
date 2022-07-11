//
//  SelectDateViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 9.07.2022.
//

import Foundation

protocol SelectDateViewModelDelegate: AnyObject {
    func didItemsFetch(_ items: Appointment)
}

class SelectDateViewModel {
    var model = SelectDateModel()
    weak var delegate: SelectDateViewModelDelegate?
    
    func getAvailableAppointments(_ stationId: Int, _ date: Date) {
        self.fetchData(stationId, date)
    }
    
    private func fetchData(_ stationId: Int, _ date: Date){
        model.getAvailableAppointments(stationId, date)  { [unowned self] appointments in
            switch appointments{
            case .success(let appointments):
                self.delegate?.didItemsFetch(appointments)
            case .failure(let err):
                print(err)
            }
        }
    }
}
