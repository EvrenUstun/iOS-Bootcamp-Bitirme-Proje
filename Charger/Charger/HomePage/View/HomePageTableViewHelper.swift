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
    weak var view: UIView!
    
    private var appointments: [ApprovedAppointment]?
    private var pastAppointments: [ApprovedAppointment]?
    private var availableAppointments: [ApprovedAppointment]?
    var appointmentId: Int?
    var row: Int!
    var popup: Popup!
    var popupDescription: String!
    private let viewModel = HomePageViewModel()
    
    init(
        with appointmentTableView: UITableView,
        view: UIView
    ) {
        super.init()
        
        self.appointmentTableView = appointmentTableView
        
        self.appointmentTableView?.delegate = self
        self.appointmentTableView?.dataSource = self
        
        self.view = view
        
        self.popup = Popup(frame: self.view.frame)
        
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
    
    func deleteItem(_ appointmentId: Int){
        viewModel.deleteAppointment(appointmentId)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        self.popup.removeFromSuperview()
    }
    
    @objc
    func didDeleteButtonTapped(){
        deleteItem(appointmentId ?? 0)
    }
    
    @objc
    func didCloseButtonTapped(){
        self.popup.removeFromSuperview()
    }
    
    @objc
    func didTrashIconTapped(){
        deleteItem(appointmentId ?? 0)
    }
    
    @objc
    func didTrashIconTapped(_ sender: UITapGestureRecognizer){
        appointmentId = sender.view?.layer.value(forKey: "appointmentID") as? Int
        row = sender.view?.layer.value(forKey: "row") as! Int
        
        popup.firstButton.setImage(Asset.cancelAppointmentButton.image, for: .normal)
        popup.secondButton.setImage(Asset.cancelButton.image, for: .normal)
        
        let description: String = "\(availableAppointments?[row].stationName ?? "") istasyonundaki \(availableAppointments?[row].date ?? "") saat  \(availableAppointments?[row].time ?? "") randevunuz iptal edilecektir."
        self.popup.popupTitleLabel?.text = "denenejn"
        self.popup.popupDescriptionLabel?.text = description
        
        self.popup.firstButton.addTarget(self, action: #selector(didDeleteButtonTapped), for: .touchUpInside)
        self.popup.secondButton.addTarget(self, action: #selector(didCloseButtonTapped), for: .touchUpInside)
        self.view.addSubview(popup)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.trashIcon.layer.setValue(indexPath.row, forKey: "row")
            
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
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: -10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = Asset.grayscaleGray25.color
        
        if section == 0 {
            if availableAppointments?.count ?? 0 > 0 {
                label.text = "GÜNCEL RANDEVULAR"
            }else {
                headerView.isHidden = true
                label.text = ""
            }
        }else {
            if pastAppointments?.count ?? 0 > 0 {
                label.text = "GEÇMİŞ RANDEVULAR"
            }else {
                headerView.isHidden = true
                label.text = ""
            }
        }
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = Asset.grayscaleGray25.color
            view.textLabel?.backgroundColor = .clear
        }
    }
}
