//
//  SelectDateTableViewCell.swift
//  Charger
//
//  Created by Evren Ustun on 8.07.2022.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI(){
        // MARK: - container view settings.
        containerView.backgroundColor = Asset.charcoalGrey.color
        contentView.backgroundColor = .clear
    
        containerView.layer.cornerRadius = 7
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
