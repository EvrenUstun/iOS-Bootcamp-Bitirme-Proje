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
    weak var notFoundLabel: UILabel!
    weak var againSearchLabel: UILabel!
    private var cities: [String]?
    private var filteredCities: [String]?
    
    init(
        with cityTableView: UITableView,
        citySearchBar: UISearchBar,
        notFoundLabel: UILabel,
        againSearchLabel: UILabel
    ) {
        super.init()
        
        self.cityTableView = cityTableView
        self.citySearchBar = citySearchBar
        self.notFoundLabel = notFoundLabel
        self.againSearchLabel = againSearchLabel
        
        self.cityTableView?.delegate = self
        self.cityTableView?.dataSource = self
        self.citySearchBar.delegate = self
    }
    
    func reloadTable(items: [String]){
        cities = items
        filteredCities = items
        cityTableView.reloadData()
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
        self.cityTableView.addSubview(notFoundLabel)
        
        againSearchLabel.frame = CGRect(x: (screenWidth/4) , y: (screenHeight/4+70), width: self.againSearchLabel.bounds.size.width, height: self.againSearchLabel.bounds.size.height) // x , y, width , height
        againSearchLabel.textAlignment = .center
        againSearchLabel.sizeToFit()
        againSearchLabel.textColor = Asset.grayscaleGray25.color
        self.cityTableView.addSubview(againSearchLabel)
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationViewController") as? StationViewController{
            vc.city = (filteredCities?[indexPath.row])!
            
            if let currentVC = UIApplication.topViewController() as? SelectCityViewController {
               //the type of currentVC is MyViewController inside the if statement, use it as you want to
                currentVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectCityTableViewHelper: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            filteredCities = cities
        }else {
            filteredCities = cities?.filter {$0.lowercased().contains(searchText.lowercased())}
        }
        
        cityTableView.reloadData()
        notFoundLabel.isHidden = true
        againSearchLabel.isHidden = true
        
        // if statements for city not found
        if filteredCities?.count == 0 {
            notFoundLabelSettings()
            cityTableView.reloadData()
        }
    }
}
