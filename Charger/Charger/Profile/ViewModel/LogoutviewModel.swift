//
//  LogoutViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 12.07.2022.
//
import Foundation
import UIKit

class LogoutViewModel {

    private var model = LogoutModel()

    func didLogoutButtonTapped(_ navigationController: UINavigationController){
        fetchData(navigationController)
    }

    private func fetchData(_ navigationController: UINavigationController){
        model.logoutRequest() {  code in
            switch code{
            case .success(let code):
                if(code == 200){
                    DispatchQueue.main.async {
                        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                            navigationController.pushViewController(vc, animated: true)
                        }
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
