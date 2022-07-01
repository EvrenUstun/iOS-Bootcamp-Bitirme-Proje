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
    
    let gradientLayer = CAGradientLayer()
    
    private let viewModel = CityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.24, green: 0.26, blue: 0.31, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.09, blue: 0.12, alpha: 1).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        self.title = "Şehir Seçin"
        
        selectCityTableViewHelper = .init(with: cityTableView, citySearchBar: citySearchBar)

        viewModel.delegate = self
        
        viewModel.getCities()
        
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
