//
//  UIViewControllerExtension.swift
//  Charger
//
//  Created by Evren Ustun on 4.07.2022.
//

import Foundation
import UIKit

extension UIViewController{
    func prepareGradientBackground(){
        // Gradient background settings.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            Asset.charcoalGrey.color.cgColor,
            Asset.dark.color.cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
