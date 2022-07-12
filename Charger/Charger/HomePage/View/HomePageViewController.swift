//
//  HomaPageViewController.swift
//  Charger
//
//  Created by Evren Ustun on 26.06.2022.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    @IBOutlet private weak var createAppointmentButton: UIButton!
    @IBOutlet weak var homePageAppIconView: UIImageView!
    @IBOutlet weak var noAppointmentLabel: UILabel!
    @IBOutlet weak var listAppointmentLabel: UILabel!
    @IBOutlet weak var appointmentTableView: UITableView!
    
    private let viewModel = HomePageViewModel()
    private var homePageTableViewHelper: HomePageTableViewHelper!
    private var approvedAppointments: [ApprovedAppointment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.getUserAppointments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViewData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    @objc func reloadTableViewData() {
        viewModel.getUserAppointments()
    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        let profileButton = UIBarButtonItem(image: UIImage(asset: Asset.users) , style: .plain, target: self, action: #selector(self.profileButtonPressed))
        navigationItem.leftBarButtonItem = profileButton
        navigationItem.leftBarButtonItem?.tintColor = Asset.solidWhite.color
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.title = "Randevular"
        
        viewModel.delegate = self
        
        homePageTableViewHelper = .init(with: appointmentTableView)
    }
    
    @objc
    func profileButtonPressed() {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func createAppointmentButtonPressed(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectCityViewController") as? SelectCityViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomePageViewController: HomePageViewModelDelegate {
    func didItemsFetch(_ items: [ApprovedAppointment]) {
        DispatchQueue.main.async {
            if items.count > 0 {
                self.homePageAppIconView.isHidden = true
                self.noAppointmentLabel.isHidden = true
                self.listAppointmentLabel.isHidden = true
                self.homePageTableViewHelper.reloadTable(items: items)
            }else {
                self.homePageAppIconView.isHidden = false
                self.noAppointmentLabel.isHidden = false
                self.listAppointmentLabel.isHidden = false
            }
            
        }
    }
}
