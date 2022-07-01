//
//  SelectCityTableViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 1.07.2022.
//

import UIKit

class SelectCityTableViewHelper: NSObject {
    
    weak var cityTableView: UITableView!
    weak var citySearchBar: UISearchBar!
    private var cities: [String]?
    private var filteredCities: [String]?
    
    init(
        with cityTableView: UITableView,
        citySearchBar: UISearchBar
    ) {
        super.init()
        
        self.cityTableView = cityTableView
        self.citySearchBar = citySearchBar
        
        self.cityTableView?.delegate = self
        self.cityTableView?.dataSource = self
        self.citySearchBar.delegate = self
    }
    
    func reloadTable(items: [String]){
        cities = items
        filteredCities = items
        cityTableView.reloadData()
    }
}


extension SelectCityTableViewHelper: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = filteredCities?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SelectCityTableViewHelper: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            filteredCities = cities
            cityTableView.reloadData()
        }else {
            filteredCities = cities?.filter {$0.lowercased().contains(searchText.lowercased())}
            cityTableView.reloadData()
        }
    }
}
