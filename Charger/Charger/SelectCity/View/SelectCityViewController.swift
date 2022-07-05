//
//  SelectCityViewController.swift
//  Charger
//
//  Created by Evren Ustun on 27.06.2022.
//

import UIKit

class SelectCityViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var citySearchBar: UISearchBar!
    @IBOutlet private weak var cityTableView: UITableView!
    
    private var selectCityTableViewHelper: SelectCityTableViewHelper!
    
    private let viewModel = CityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        self.title = "Şehir Seçin"
        
        selectCityTableViewHelper = .init(with: cityTableView, citySearchBar: citySearchBar)

        viewModel.delegate = self
        
        viewModel.getCities()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
    }
}

extension SelectCityViewController: CityViewModelDelegate {
    func didItemsFetch(_ items: [String]) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.selectCityTableViewHelper.reloadTable(items: items)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
    
}
