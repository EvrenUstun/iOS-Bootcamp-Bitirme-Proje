//
//  StationTableViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 4.07.2022.
//

import UIKit

class StationTableViewHelper: NSObject {
    
    weak var stationTableView: UITableView!
    weak var stationSearchbar: UISearchBar!
    weak var cityResultLabel: UILabel!
    weak var notFoundLabel: UILabel!
    weak var againSearchLabel: UILabel!
    
    private var city: String = ""
    private var stations: [Station]?
    private var filteredStations: [Station]?
    
    init(
        with stationTableView: UITableView,
        stationSearchbar: UISearchBar,
        cityResultLabel: UILabel,
        notFoundLabel: UILabel,
        againSearchLabel: UILabel,
        city: String
    ) {
        super.init()
        
        self.stationTableView = stationTableView
        self.stationSearchbar = stationSearchbar
        self.cityResultLabel = cityResultLabel
        self.notFoundLabel = notFoundLabel
        self.againSearchLabel = againSearchLabel
        self.city = city
        
        self.stationTableView?.delegate = self
        self.stationTableView?.dataSource = self
        self.stationSearchbar.delegate = self
        
        registerCell()
    }
    
    func reloadTable(items: [Station]){
        stations = items
        filteredStations = items
        reloadLabel(filteredStations?.count ?? 0)
        stationTableView.reloadData()
    }
    private func registerCell(){
        stationTableView.register(.init(nibName: "StationCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "StationCustomTableViewCell")
    }
    
    private func reloadLabel(_ count: Int) {
        let text = "'\(self.city)' şehri için \(count) sonuç görüntüleniyor".withBoldText(text: "'\(self.city)'", fontSize: 18)
        self.cityResultLabel.attributedText = text
    }
    
    private func notFoundLabelSettings(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        notFoundLabel.isHidden = false
        againSearchLabel.isHidden = false
        
        notFoundLabel.frame = CGRect(x: (screenWidth/4-50) , y: screenHeight/4, width: self.notFoundLabel.bounds.size.width, height: self.notFoundLabel.bounds.size.height) // x , y, width , height
        notFoundLabel.textAlignment = .center
        notFoundLabel.sizeToFit()
        notFoundLabel.textColor = Asset.solidWhite.color
        self.stationTableView.addSubview(notFoundLabel)
        
        againSearchLabel.frame = CGRect(x: (screenWidth/4) , y: (screenHeight/4+70), width: self.againSearchLabel.bounds.size.width, height: self.againSearchLabel.bounds.size.height) // x , y, width , height
        againSearchLabel.textAlignment = .center
        againSearchLabel.sizeToFit()
        againSearchLabel.textColor = Asset.grayscaleGray25.color
        self.stationTableView.addSubview(againSearchLabel)
    }
}

extension StationTableViewHelper: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stationTableView.dequeueReusableCell(withIdentifier: "StationCustomTableViewCell", for: indexPath) as! StationCustomTableViewCell
        cell.backgroundColor = .clear
        cell.stationNameLabel.text = filteredStations?[indexPath.row].stationName ?? "N/A"
        cell.distanceInKmLabel.text = getCleanKm(filteredStations?[indexPath.row].distanceInKM)
        cell.selectionStyle = .none
        
        let acChargeType = filteredStations?[indexPath.row].sockets!.contains(where: { $0.chargeType == "AC" })
        let dcChargeType = filteredStations?[indexPath.row].sockets!.contains(where: { $0.chargeType == "DC" })
        
        if acChargeType! && dcChargeType! {
            cell.chargeTypeIcon.image = Asset.acdcAvatar.image
        }else if dcChargeType! {
            cell.chargeTypeIcon.image = Asset.dcAvatar.image
        }else if acChargeType! {
            cell.chargeTypeIcon.image = Asset.acavatar.image
        }
        
        cell.socketLabel.text = "\((filteredStations?[indexPath.row].socketCount ?? 0) - (filteredStations?[indexPath.row].occupiedSocketCount ?? 0)) / \(filteredStations?[indexPath.row].socketCount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectDateViewController") as? SelectDateViewController{
            vc.stationId = self.filteredStations?[indexPath.row].id
            if let currentVC = UIApplication.topViewController() as? StationViewController {
               //the type of currentVC is MyViewController inside the if statement, use it as you want to
                currentVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
        ProjectRepository.distanceInKm = filteredStations?[indexPath.row].distanceInKM
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func getCleanKm(_ km: Double?) -> String {
        if km != nil{
            return String(format: "%.1f", km!) + " km"
        }else {
            return ""
        }
    }
}

extension StationTableViewHelper: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            filteredStations = stations
        }else {
            filteredStations = stations?.filter {$0.stationName!.lowercased().contains(searchText.lowercased())}
        }
        stationTableView.reloadData()
        reloadLabel(filteredStations?.count ?? 0)
        
        notFoundLabel.isHidden = true
        againSearchLabel.isHidden = true
        
        // if statements for city not found
        if filteredStations?.count == 0 {
            notFoundLabelSettings()
            stationTableView.reloadData()
        }
    }
}
