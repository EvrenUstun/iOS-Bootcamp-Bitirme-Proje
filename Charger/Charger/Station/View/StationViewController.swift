//
//  StationViewController.swift
//  Charger
//
//  Created by Evren Ustun on 4.07.2022.
//

import UIKit

class StationViewController: UIViewController {
    
    @IBOutlet weak var stationSearchbar: UISearchBar!
    @IBOutlet weak var stationTableView: UITableView!
    @IBOutlet weak var cityResultLabel: UILabel!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var againSearchLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    private var stationTableViewHelper: StationTableViewHelper!
    private let viewModel = StationViewModel()
    var chargerTypeFilter: [String] = []
    var socketTypeFilter: [String] = []
    var serviceFilter: [String] = []
    var distance: Float = 15.0
    var filterItem: [String] = []
    var city: String = ""
    private var row: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterCollectionView.isHidden = true
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        filterCollectionView.register(.init(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
        
        setupUI()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        // search bar settings
        stationSearchbar.searchTextField.layer.cornerRadius = 18
        stationSearchbar.searchTextField.layer.masksToBounds = false
        stationSearchbar.searchTextField.layer.backgroundColor = Asset.dark.color.cgColor
        stationSearchbar.searchTextField.layer.borderColor = Asset.grayscaleGray25.color.cgColor
        stationSearchbar.searchTextField.layer.borderWidth = 1
        stationSearchbar.searchTextField.textColor = Asset.solidWhite.color
        stationSearchbar.searchTextField.leftView?.tintColor = .white
        
        notFoundLabel.isHidden = true
        againSearchLabel.isHidden = true
        
        self.title = "İstasyon Seçin"
        
        stationTableViewHelper = .init(with: stationTableView, stationSearchbar: stationSearchbar, cityResultLabel: cityResultLabel, notFoundLabel: notFoundLabel, againSearchLabel:againSearchLabel, city: city)
        
        viewModel.delegate = self
        
        viewModel.getStations(city, chargerTypeFilter, socketTypeFilter, serviceFilter, distance)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease") , style: .plain, target: self, action: #selector(self.filterButtonPressed))
        
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.rightBarButtonItem?.tintColor = Asset.grayscaleGray25.color
    }
    
    @objc
    func filterButtonPressed() {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController{
            vc.city = self.city
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension StationViewController: StationViewModelDelegate {
    func didItemsFetch(_ items: [Station]) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.stationTableViewHelper.reloadTable(items: items)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
}

extension StationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var filterCount: Int = 0
        if distance == 15 {
            filterCount = chargerTypeFilter.count + socketTypeFilter.count + serviceFilter.count
        }else {
            filterCount = chargerTypeFilter.count + socketTypeFilter.count + serviceFilter.count + 1
        }
        if filterCount > 0 {
            filterCollectionView.isHidden = false
        }
        return filterCount
    }
    
    @objc
    func didTappedXButton(_ sender: UITapGestureRecognizer){
        row = (sender.view?.layer.value(forKey: "row") as! Int)
        
        if filterItem[row] == "AC" || filterItem[row] == "DC" {
            if let index = chargerTypeFilter.firstIndex(of: filterItem[row]) {
                chargerTypeFilter.remove(at: index)
            }
        } else if filterItem[row] == "Type-2" || filterItem[row] == "CSC" || filterItem[row] == "CHAdeMO" {
            if let index = socketTypeFilter.firstIndex(of: filterItem[row]) {
                socketTypeFilter.remove(at: index)
            }
        } else if filterItem[row] == "Otopark" || filterItem[row] == "Büfe" || filterItem[row] == "Wi-Fi" {
            if let index = serviceFilter.firstIndex(of: filterItem[row]) {
                serviceFilter.remove(at: index)
            }
        } else if filterItem[row] == "3 km" || filterItem[row] == "6 km" || filterItem[row] == "9 km" || filterItem[row] == "12 km" {
            distance = 15
        }
        refreshDataWhenDeleted()
    }
    
    private func refreshDataWhenDeleted(){
        filterItem.remove(at: row)
        filterCollectionView.reloadData()
        viewModel.getStations(city, chargerTypeFilter, socketTypeFilter, serviceFilter, distance)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedXButton(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cell.xIconView.addGestureRecognizer(tap)
        cell.xIconView.layer.setValue(indexPath.row, forKey: "row")
        
        for arr in chargerTypeFilter{
            filterItem.append(arr)
        }
        
        for arr in socketTypeFilter{
            filterItem.append(arr)
        }
        
        for arr in serviceFilter{
            filterItem.append(arr)
        }
        if distance != 15 {
            filterItem.append("\(Int(distance)) km")
        }
        
        cell.filterNameLabel.text = filterItem[indexPath.item]
        return cell
    }
}
