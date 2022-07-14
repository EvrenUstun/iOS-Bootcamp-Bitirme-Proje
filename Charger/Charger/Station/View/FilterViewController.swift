//
//  FilterViewController.swift
//  Charger
//
//  Created by Evren Ustun on 5.07.2022.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var chargerTypeACButton: UIButton!
    @IBOutlet weak var chargerTypeDCButton: UIButton!
    @IBOutlet weak var socketType2Button: UIButton!
    @IBOutlet weak var socketCSSButton: UIButton!
    @IBOutlet weak var socketCHAdeMOButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var servicesParkButton: UIButton!
    @IBOutlet weak var servicesWifiButton: UIButton!
    @IBOutlet weak var servicesBuffetButton: UIButton!
    
    var distance: Float = 15.0
    var city: String = ""
    
    private var filterViewHelper: FilterViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        distanceSlider.value = distanceSlider.maximumValue
        
        filterViewHelper = .init()
        
        filterViewHelper.setSettingsForButton(chargerTypeACButton)
        filterViewHelper.setSettingsForButton(chargerTypeDCButton)
        filterViewHelper.setSettingsForButton(socketType2Button)
        filterViewHelper.setSettingsForButton(socketCSSButton)
        filterViewHelper.setSettingsForButton(socketCHAdeMOButton)
        filterViewHelper.setSettingsForButton(servicesParkButton)
        filterViewHelper.setSettingsForButton(servicesWifiButton)
        filterViewHelper.setSettingsForButton(servicesBuffetButton)
        
        self.title = "Filtreleme"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        let clearButton = UIBarButtonItem(title: "TEMİZLE", style: .plain, target: self, action: #selector(self.didClearButtonTapped))
        
        navigationItem.rightBarButtonItem = clearButton
        navigationItem.rightBarButtonItem?.tintColor = Asset.solidWhite.color
    }
    
    @objc
    func didClearButtonTapped(){
        distance = 15
        distanceSlider.value = distanceSlider.maximumValue
        filterViewHelper.switchButtonStyle(chargerTypeACButton, true)
        filterViewHelper.switchButtonStyle(chargerTypeDCButton, true)
        filterViewHelper.switchButtonStyle(socketType2Button, true)
        filterViewHelper.switchButtonStyle(socketCSSButton, true)
        filterViewHelper.switchButtonStyle(socketCHAdeMOButton, true)
        filterViewHelper.switchButtonStyle(servicesParkButton, true)
        filterViewHelper.switchButtonStyle(servicesWifiButton, true)
        filterViewHelper.switchButtonStyle(servicesBuffetButton, true)
    }
    
    @IBAction func changeDistance(_ sender: UISlider) {
        distanceSlider.value = roundf(distanceSlider.value)
        distance = distanceSlider.value * 3
    }
    
    @IBAction func didACButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(chargerTypeACButton)
    }
    
    @IBAction func didDCButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(chargerTypeDCButton)
    }
    
    @IBAction func didType2ButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(socketType2Button)
    }
    
    @IBAction func didCSSButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(socketCSSButton)
    }
    
    @IBAction func didCHAdeMOButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(socketCHAdeMOButton)
    }
    
    @IBAction func didParkButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(servicesParkButton)
    }
    
    @IBAction func didBuffetButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(servicesBuffetButton)
    }
    
    @IBAction func didWifButtonTapped(_ sender: Any) {
        filterViewHelper.switchButtonStyle(servicesWifiButton)
    }
    
    @IBAction func didFilterButtonTapped(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StationViewController") as? StationViewController{
            vc.city = city
            vc.chargerTypeFilter = filterViewHelper.chargerTypeFilter
            vc.socketTypeFilter = filterViewHelper.socketTypeFilter
            vc.serviceFilter = filterViewHelper.serviceFilter
            vc.distance = distance
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
