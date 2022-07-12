//
//  HomePageTableViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 12.07.2022.
//

import Foundation
import UIKit

class HomePageTableViewHelper: NSObject {
    
    weak var appointmentTableView: UITableView!
    
    private var appointments: [ApprovedAppointment]?
    private var pastAppointments: [ApprovedAppointment]?
    private var availableAppointments: [ApprovedAppointment]?
    
    private let viewModel = HomePageViewModel()
    
    init(
        with appointmentTableView: UITableView
    ) {
        super.init()
        
        self.appointmentTableView = appointmentTableView
        
        self.appointmentTableView?.delegate = self
        self.appointmentTableView?.dataSource = self
        
        registerCell()
    }
    
    func reloadTable(items: [ApprovedAppointment]){
        appointments = items
        pastAppointments = appointments?.filter{ $0.hasPassed == true }
        availableAppointments = appointments?.filter{ $0.hasPassed == false }
        appointmentTableView.reloadData()
    }
    
    private func registerCell(){
        appointmentTableView.register(.init(nibName: "HomePageCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "HomePageCustomTableViewCell")
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension HomePageTableViewHelper: UITableViewDelegate, UITableViewDataSource {
    
    @objc
    func didTrashIconTapped(_ sender: UITapGestureRecognizer){
        guard let appointmentId = sender.view?.layer.value(forKey: "appointmentID") as? Int else { return }
        viewModel.deleteAppointment(appointmentId)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(appointments?.filter { $0.hasPassed == false }.count ?? 0)
        if section == 0 {
            return appointments?.filter { $0.hasPassed == false }.count ?? 0
        }else{
            return appointments?.filter { $0.hasPassed == true }.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = appointmentTableView.dequeueReusableCell(withIdentifier: "HomePageCustomTableViewCell", for: indexPath) as! HomePageCustomTableViewCell
            cell.trashIcon.isHidden = false
            
            appointmentsPrepareUI(cell, availableAppointments, indexPath)

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTrashIconTapped(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            cell.trashIcon.addGestureRecognizer(tap)
            cell.trashIcon.layer.setValue(availableAppointments?[indexPath.row].appointmentID, forKey: "appointmentID")
            return cell
            
        }else {
            let cell = appointmentTableView.dequeueReusableCell(withIdentifier: "HomePageCustomTableViewCell", for: indexPath) as! HomePageCustomTableViewCell
            
            cell.trashIcon.isHidden = true
            appointmentsPrepareUI(cell, pastAppointments, indexPath)

            return cell
        }
    }
    
    private func appointmentsPrepareUI(_ cell: HomePageCustomTableViewCell, _ appointment: [ApprovedAppointment]?, _ indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.chargerAndSocketTypeLabel.textAlignment = .right
        
        cell.stationNameLabel.text = appointment?[indexPath.row].stationName ?? ""
        
        let acChargeType = appointment?[indexPath.row].station?.sockets?.contains(where: { $0.chargeType == "AC" })
        let dcChargeType = appointment?[indexPath.row].station?.sockets?.contains(where: { $0.chargeType == "DC" })
        
        if acChargeType! && dcChargeType! {
            cell.chargeTypeIcon.image = Asset.acdcAvatar.image
        }else if dcChargeType! {
            cell.chargeTypeIcon.image = Asset.dcAvatar.image
        }else if acChargeType! {
            cell.chargeTypeIcon.image = Asset.acavatar.image
        }
        
        cell.socketNummberLabel.text = "\(appointment?[indexPath.row].station?.sockets?.filter{ $0.socketID == appointment?[indexPath.row].socketID }[0].socketNumber ?? 0)"
        
        cell.chargerAndSocketTypeLabel.text = (appointment?[indexPath.row].station?.sockets?.filter{ $0.socketID == appointment?[indexPath.row].socketID }[0].chargeType ?? "") + " • " + (appointment?[indexPath.row].station?.sockets?.filter{ $0.socketID == appointment?[indexPath.row].socketID }[0].socketType ?? "")
        
        cell.dateLabel.text = "\(appointment?[indexPath.row].date ?? ""), \(appointment?[indexPath.row].time ?? "")"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "GÜNCEL RANDEVULAR"
        }else {
            return "GEÇMİŞ RANDEVULAR"
        }
    }
}
