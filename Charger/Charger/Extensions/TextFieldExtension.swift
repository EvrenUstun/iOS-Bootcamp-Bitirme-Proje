//
//  TextFieldExtensions.swift
//  Charger
//
//  Created by Evren Ustun on 26.06.2022.
//

import Foundation
import UIKit

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
