//
//  ProfileViewController.swift
//  Charger
//
//  Created by Evren Ustun on 26.06.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profileCardView: UIView!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var userDeviceUDIDLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    
    private var viewModel = LogoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        
        prepareGradientBackground()
        
        self.title = "Profil"
        
        profileCardView.layer.cornerRadius = 10
        
        userEmailLabel.text = ProjectRepository.user?.email ?? ""
        
        userDeviceUDIDLabel.text = ProjectRepository.deviceUDID
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        viewModel.didLogoutButtonTapped(self.navigationController!)
    }
}
