//
//  AlertManager.swift
//  Charger
//
//  Created by Evren Ustun on 30.06.2022.
//

import Foundation
import UIKit

class AlertManager {
    
    func showAlert(title: String, message: String?, preferredStyle: UIAlertController.Style = .alert,
                   cancelButtonTitle:String?, defaultButtonTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController{
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: handler)
            alertController.addAction(defaultButton)
        }
        
        if cancelButtonTitle != nil {
            let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel)
            alertController.addAction(cancelButton)
        }
        
        return alertController
    }
}
