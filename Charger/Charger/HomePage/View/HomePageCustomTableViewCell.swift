//
//  HomePageCustomTableViewCell.swift
//  Charger
//
//  Created by Evren Ustun on 11.07.2022.
//

import UIKit

class HomePageCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chargeTypeIcon: UIImageView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificaitonLabel: UILabel!
    @IBOutlet weak var socketNummberLabel: UILabel!
    @IBOutlet weak var chargerAndSocketTypeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstLabelConteinerView: UIView!
    @IBOutlet weak var secondLabelConteinerView: UIView!
    @IBOutlet weak var trashIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI(){
        // MARK: - container view settings.
        containerView.backgroundColor = Asset.charcoalGrey.color
        
        containerView.layer.shadowColor = Asset.dark.color.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        
        containerView.layer.rasterizationScale = UIScreen.main.scale
        
        containerView.layer.cornerRadius = 15
        
        //MARK: - first label container settings.
        firstLabelConteinerView.backgroundColor = Asset.charcoalGrey.color
        
        firstLabelConteinerView.layer.shadowColor = Asset.dark.color.cgColor
        firstLabelConteinerView.layer.shadowOpacity = 0.5
        firstLabelConteinerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        firstLabelConteinerView.layer.shadowRadius = 15
        
        // MARK: - second label container settings.
        secondLabelConteinerView.backgroundColor = Asset.charcoalGrey.color
        
        secondLabelConteinerView.layer.shadowColor = Asset.dark.color.cgColor
        secondLabelConteinerView.layer.shadowOpacity = 0.5
        secondLabelConteinerView.layer.shadowOffset = CGSize(width: 10, height: 10)
        secondLabelConteinerView.layer.shadowRadius = 15
        
        trashIcon.isUserInteractionEnabled = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
