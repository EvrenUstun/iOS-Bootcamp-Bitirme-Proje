//
//  LoginViewModel.swift
//  Charger
//
//  Created by Evren Ustun on 30.06.2022.
//

import Foundation
import UIKit

class LoginViewModel {
    
    private var model = LoginModel()
    
    func didUserTapLoginButton(_ email: String, navigationController: UINavigationController) {
        fetchData(email, navigationController)
    }
    
    private func fetchData(_ email: String, _ navigationController: UINavigationController) {
        model.loginPostRequest(email: email) {  code in
            switch code{
            case .success(let code):
                if(code == 200){
                    DispatchQueue.main.async {
                        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
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
