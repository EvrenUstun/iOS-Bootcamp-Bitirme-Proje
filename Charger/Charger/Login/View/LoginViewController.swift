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
        
        setupUI()
    }
    
    func setupUI() {
        
        // Gradient background settings.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.24, green: 0.26, blue: 0.31, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.09, blue: 0.12, alpha: 1).cgColor
        ]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        navigationItem.hidesBackButton = true
        emailTextfield.text = "deneme@gmail.com"  //Silinecek
        
        // E-mail text field settings.
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "E-POSTA ADRESİNİZ",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        emailTextfield.textColor = .white
        emailTextfield.setPadding()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: emailTextfield.frame.height, width: emailTextfield.frame.width - 1, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        emailTextfield.borderStyle = UITextField.BorderStyle.none
        emailTextfield.layer.addSublayer(bottomLine)
        
        // Welcome text settings.
        let text = "Charger'a hoş geldiniz.".withBoldText(text: "Charger'a")
        welcomeLabel.attributedText = text
        
    }
    
    // MARK: - func for location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
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

}
