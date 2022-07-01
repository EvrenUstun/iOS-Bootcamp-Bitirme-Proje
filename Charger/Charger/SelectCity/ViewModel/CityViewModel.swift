//
//  CityViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 1.07.2022.
//

import Foundation

protocol CityViewModelDelegate: AnyObject {
    func didItemsFetch(_ items: [String])
}

class CityViewModel {
    private var model = CityModel()
    weak var delegate: CityViewModelDelegate?
    
    func getCities() {
        self.fetchData()
    }
    
    private func fetchData(){
        model.getAllCities { [unowned self] citiesArray in
            switch citiesArray{
            case .success(let city):
                self.delegate?.didItemsFetch(city)
            case .failure(let err):
                print(err)
            }
        }
    }
}
