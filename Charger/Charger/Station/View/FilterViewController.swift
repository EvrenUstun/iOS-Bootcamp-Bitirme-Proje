//
//  FilterViewController.swift
//  Charger
//
//  Created by Evren Ustun on 5.07.2022.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        self.title = "Filtreleme"
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        let clearButton = UIBarButtonItem(title: "TEMİZLE", style: .plain, target: nil, action: nil)
//        UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease") , style: .plain, target: self, action: #selector(self.filterButtonPressed))
        
        navigationItem.rightBarButtonItem = clearButton
        navigationItem.rightBarButtonItem?.tintColor = Asset.solidWhite.color
        
    }

}
