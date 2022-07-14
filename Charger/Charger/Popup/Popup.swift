//
//  Popup.swift
//  Charger
//
//  Created by Evren Ustun on 13.07.2022.
//

import UIKit

class Popup: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    @IBOutlet weak var popupDescriptionLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
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
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    func xibSetup(frame: CGRect){
        let view = loadXib()
        view.frame = frame
        addSubview(view)
    }
    
    func loadXib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Popup", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
    
    
}
