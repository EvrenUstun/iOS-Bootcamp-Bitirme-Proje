//
//  PopupViewController.swift
//  Charger
//
//  Created by Evren Ustun on 16.07.2022.
//

import UIKit

class PopupViewController: UIViewController {
        
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupDescriptionLabel: UILabel!
    @IBOutlet weak var popupFirstButton: UIButton!
    @IBOutlet weak var popupSecondButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        // MARK: - container view settings.
        containerView.backgroundColor = Asset.charcoalGrey.color
        
        containerView.layer.shadowColor = Asset.dark.color.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        
        containerView.layer.rasterizationScale = UIScreen.main.scale
        
        containerView.layer.cornerRadius = 15
    }
    
    @IBAction func didFirstPopupButtonTapped(_ sender: Any) {
        UIView.transition(with: self.view, duration: 0.50, options: [.transitionCrossDissolve],
                          animations: {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }, completion: nil)
    }
    
    @IBAction func didSecondPopupButtonTapped(_ sender: Any) {
        UIView.transition(with: self.view, duration: 0.50, options: [.transitionCrossDissolve],
                          animations: {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }, completion: nil)
    }
}
