//
//  AppointmentSummaryViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 11.07.2022.
//

import Foundation

protocol AppointmentSummaryViewModelDelegate: AnyObject {
    func didItemsFetch(_ items: Appointment)
    func didApprovedAppointmentsFetch(_ items: ApprovedAppointment)
}

class AppointmentSummaryViewModel {
    var model = AppointmentSummaryModel()
    weak var delegate: AppointmentSummaryViewModelDelegate?
    
    func getAppointmentSummary(_ stationId: Int, _ date: Date) {
        self.fetchData(stationId, date)
    }
    
    func getApprovedAppointment(_ stationId: Int, _ socketId: Int, _ timeSlot: String, _ appointmentDate: Date) {
        self.fetchApprovedAppointmentData(stationId, socketId, timeSlot, appointmentDate)
    }
    
    private func fetchData(_ stationId: Int, _ date: Date){
        model.getAppointmentSummary(stationId, date)  { [unowned self] appointments in
            switch appointments{
            case .success(let appointments):
                self.delegate?.didItemsFetch(appointments)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func fetchApprovedAppointmentData(_ stationId: Int, _ socketId: Int, _ timeSlot: String, _ appointmentDate: Date){
        model.approveAppointment(stationId, socketId, timeSlot, appointmentDate) { [unowned self] appointments in
            switch appointments{
            case .success(let appointments):
                self.delegate?.didApprovedAppointmentsFetch(appointments)
            case .failure(let err):
                print(err)
            }
        }
    }
}
