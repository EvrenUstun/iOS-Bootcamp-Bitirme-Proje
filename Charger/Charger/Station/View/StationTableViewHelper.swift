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
    private var city: String = ""
    private var stations: [Station]?
    private var filteredStations: [Station]?
    
    init(
        with stationTableView: UITableView,
        stationSearchbar: UISearchBar,
        cityResultLabel: UILabel,
        city: String
    ) {
        super.init()
        
        self.stationTableView = stationTableView
        self.stationSearchbar = stationSearchbar
        self.cityResultLabel = cityResultLabel
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
        
        cell.socketLabel.text = "\((filteredStations?[indexPath.row].socketCount ?? 0) - (filteredStations?[indexPath.row].occupiedSocketCount ?? 0)) / \(filteredStations?[indexPath.row].socketCount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
    }
}
