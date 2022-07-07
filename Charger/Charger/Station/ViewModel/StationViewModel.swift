//
//  StationModelView.swift
//  Charger
//
//  Created by Evren Ustun on 4.07.2022.
//

import Foundation

protocol StationViewModelDelegate: AnyObject {
    func didItemsFetch(_ items: [Station])
}

class StationViewModel {
    var model = StationModel()
    weak var delegate: StationViewModelDelegate?
    
    func getStations(_ city: String, _ chargerTypeFilter: [String], _ socketTypeFilter: [String], _ serviceFilter: [String], _ distance: Float) {
        self.fetchData(city, chargerTypeFilter, socketTypeFilter, serviceFilter, distance)
    }
    
    private func fetchData(_ city: String, _ chargerTypeFilter: [String], _ socketTypeFilter: [String], _ serviceFilter: [String], _ distance: Float){
        model.getAllStation(city, chargerTypeFilter, socketTypeFilter, serviceFilter, distance)  { [unowned self] stations in
            switch stations{
            case .success(let station):
                self.delegate?.didItemsFetch(station)
            case .failure(let err):
                print(err)
            }
        }
    }
}
