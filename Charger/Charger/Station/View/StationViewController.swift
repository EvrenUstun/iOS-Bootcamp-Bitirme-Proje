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
    
    private var stationTableViewHelper: StationTableViewHelper!
    
    private let viewModel = StationViewModel()
    
    var chargerTypeFilter: [String] = []
    var socketTypeFilter: [String] = []
    var serviceFilter: [String] = []
    var distance: Float = 15.0
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
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
