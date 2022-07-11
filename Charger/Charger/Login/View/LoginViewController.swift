//
//  ViewController.swift
//  Charger
//
//  Created by Evren Ustun on 25.06.2022.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: UI Components
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private var backgroundView: UIView!
    
    let locationManager = CLLocationManager()
    
    private var viewModel = LoginViewModel()
    private var alertManager = AlertManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For use when the app is open & in the background.
        // locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        self.hideKeyboardWhenTappedAround()
        self.emailTextfield.delegate = self
        
        setupUI()
    }

    func setupUI() {
        
        // Gradient background settings.
        prepareGradientBackground()
        
        navigationItem.hidesBackButton = true
        emailTextfield.text = "deneme@gmail.com"  //Silinecek
        
        // E-mail text field settings.
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "E-POSTA ADRESİNİZ",
            attributes: [
                NSAttributedString.Key.foregroundColor: Asset.grayscaleGray25.color,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)
            ]
        )
        emailTextfield.textColor = Asset.solidWhite.color
        emailTextfield.setPadding()
        
        bottomLayerForButton()
        
        // Welcome text settings.
        let text = "Charger'a hoş geldiniz.".withBoldText(text: "Charger'a", fontSize: 28)
        welcomeLabel.attributedText = text
        welcomeLabel.textColor = Asset.solidWhite.color
        loginLabel.textColor = Asset.grayscaleGray25.color
        
        loginButton.setImage(UIImage(asset: Asset.loginButton), for: .normal)
        
    }

    // MARK: - func for location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            ProjectRepository.latitude = location.coordinate.latitude
            ProjectRepository.longitude = location.coordinate.longitude
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if(manager.authorizationStatus == .denied){
            let alertController = self.alertManager.showAlert(title: "Lokasyon İzni", message: "Lokasyonunuza ihtiyacımız var", cancelButtonTitle: "Vazgeç", defaultButtonTitle: "Ayarları aç") { action in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            present(alertController, animated: true)
        }
    }
    
    // MARK: - func for Button
    @IBAction func loginButtonPressed(_ sender: Any) {
        // email validation.
        let email = emailTextfield.text
        if email!.isValidEmail {
            viewModel.didUserTapLoginButton(email!, navigationController: self.navigationController!)
        }else{
            let alertController = self.alertManager.showAlert(title: "Geçersiz e-posta", message: "E-posta adresinizi kontrol edin.", cancelButtonTitle: "Tamam")
            present(alertController, animated: true)
        }
        
    }
    
    private func bottomLayerForButton(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: emailTextfield.frame.height, width: emailTextfield.frame.width - 1, height: 1.0)
        bottomLine.backgroundColor = Asset.grayscaleGray25.color.cgColor
        emailTextfield.borderStyle = UITextField.BorderStyle.none
        emailTextfield.layer.addSublayer(bottomLine)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
}
