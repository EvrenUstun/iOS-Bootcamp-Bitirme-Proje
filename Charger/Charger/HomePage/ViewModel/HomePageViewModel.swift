//
//  HomePageViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 11.07.2022.
//

import Foundation

protocol HomePageViewModelDelegate: AnyObject {
    func didItemsFetch(_ items: [ApprovedAppointment])
}

class HomePageViewModel {
    
    var model = HomePageModel()
    weak var delegate: HomePageViewModelDelegate?
    
    func getUserAppointments() {
        self.fetchData()
    }
    
    func deleteAppointment(_ appointmentId: Int) {
        self.deleteData(appointmentId)
    }
    
    private func fetchData(){
        model.getUserAppointments()  { [unowned self] approvedAppointments in
            switch approvedAppointments{
            case .success(let approvedAppointment):
                self.delegate?.didItemsFetch(approvedAppointment)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func deleteData(_ appointmentId: Int){
        model.deleteAppointment(appointmentId)  { code in
            switch code{
            case .success(let code):
                if(code == 200){
                    print("code 200")
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
