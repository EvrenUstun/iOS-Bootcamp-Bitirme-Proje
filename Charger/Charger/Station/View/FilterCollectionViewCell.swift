//
//  FilterCollectionViewCell.swift
//  Charger
//
//  Created by Evren Ustun on 14.07.2022.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var xIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI(){
        
        // MARK: - container view settings.
        containerView.backgroundColor = Asset.dark.color
        containerView.layer.borderColor = Asset.mainPrimary.color.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 18
        
        xIconView.isUserInteractionEnabled = true
    }
}
