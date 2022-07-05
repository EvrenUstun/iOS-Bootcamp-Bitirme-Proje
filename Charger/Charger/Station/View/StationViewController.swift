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
    
    private var stationTableViewHelper: StationTableViewHelper!
    
    private let viewModel = StationViewModel()
    
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        self.title = "İstasyon Seçin"
        
        stationTableViewHelper = .init(with: stationTableView, stationSearchbar: stationSearchbar, cityResultLabel: cityResultLabel, city: city)
        
        viewModel.delegate = self
        
        viewModel.getStations(city)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease") , style: .plain, target: self, action: #selector(self.filterButtonPressed))
        
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.rightBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
    }
    
    @objc
    func filterButtonPressed() {
        print("Filter pressed.")
    }
}

extension StationViewController: StationViewModelDelegate {
    func didItemsFetch(_ items: [Station]) {
        DispatchQueue.main.async {
            self.stationTableViewHelper.reloadTable(items: items)
        }
    }
}
