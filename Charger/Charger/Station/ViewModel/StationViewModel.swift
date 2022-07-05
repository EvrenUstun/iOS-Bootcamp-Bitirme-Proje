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
    
    func getStations(_ city: String) {
        self.fetchData(city)
    }
    
    private func fetchData(_ city: String){
        model.getAllStation(city)  { [unowned self] stations in
            switch stations{
            case .success(let station):
                self.delegate?.didItemsFetch(station)
            case .failure(let err):
                print(err)
            }
        }
    }
}
