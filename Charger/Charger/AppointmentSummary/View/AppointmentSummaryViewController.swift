//
//  AppointmentSummaryViewController.swift
//  Charger
//
//  Created by Evren Ustun on 10.07.2022.
//

import UIKit

class AppointmentSummaryViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceInKmLabel: UILabel!
    @IBOutlet weak var stationCodeLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var socketNumberLabel: UILabel!
    @IBOutlet weak var chargerTypeLabel: UILabel!
    @IBOutlet weak var socketTypeLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationScheduleTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var appointmentDate: Date!
    var stationId: Int!
    private let viewModel = AppointmentSummaryViewModel()
    var whichSocketSelected: Int!
    var appointmentHour: String!
    var socketId: Int!

    let notificationTime: [String] = ["5 dakika önce", "10 dakika önce", "15 dakika önce", "30 dakika önce", "1 saat önce", "2 saat önce", "3 saat önce"]
    
    var notificationPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.getAppointmentSummary(stationId, appointmentDate)
    }
    
    func setupUI() {
        
        // Gradient background settings.
        prepareGradientBackground()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        textFieldSettings()
        pickerViewSettings()
        
        viewModel.delegate = self
    }
    
    private func textFieldSettings(){
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(systemName: "chevron.down")
        
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "chevron.down")!.size.width, height: UIImage(systemName: "chevron.down")!.size.height)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "chevron.down")!.size.width, height: UIImage(systemName: "chevron.down")!.size.height)
        
        notificationScheduleTextField.isHidden = true
        notificationScheduleTextField.rightView =  contentView
        notificationScheduleTextField.rightViewMode = .always
    }
    
    private func pickerViewSettings(){
        notificationScheduleTextField.inputView = notificationPickerView
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        notificationScheduleTextField.text = notificationTime[3]
        notificationPickerView.selectRow(3, inComponent: 0, animated: true)
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -10, width: 0, height: 0))

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = Asset.solidWhite.color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = Asset.grayscaleGray25.color
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
    
    @IBAction func didSwitchChange(_ sender: Any) {
        if notificationSwitch.isOn {
            notificationScheduleTextField.isHidden = false
        }else {
            notificationScheduleTextField.isHidden = true
        }
        
    }
    @IBAction func didApproveAppointmentButtonTapped(_ sender: Any) {
        viewModel.getApprovedAppointment(stationId, socketId, hourLabel.text ?? "", appointmentDate)
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AppointmentSummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notificationTime.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notificationTime[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notificationScheduleTextField.text = notificationTime[row]
        notificationScheduleTextField.resignFirstResponder()
    }
    
    func getCleanKm(_ km: Double?) -> String {
        if km != nil{
            return String(format: "%.1f", km!) + " km"
        }else {
            return ""
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
         
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

extension AppointmentSummaryViewController: AppointmentSummaryViewModelDelegate {
    func didApprovedAppointmentsFetch(_ items: ApprovedAppointment) {
        
    }
    
    func didItemsFetch(_ items: Appointment) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()

            self.navigationItem.titleView =  self.setTitle(title: "Randevu Detayı", subtitle: items.stationName ?? "")
            self.addressLabel.text = items.geoLocation?.address
            self.distanceInKmLabel.text = self.getCleanKm(ProjectRepository.distanceInKm)
            self.stationCodeLabel.text = items.stationCode
            
            let services: String = items.services?.joined(separator: ", ") ?? ""
            self.servicesLabel.text = services
            
            self.socketNumberLabel.text = "\(self.whichSocketSelected ?? 0)"
            self.chargerTypeLabel.text = items.sockets?[self.whichSocketSelected-1].chargeType ?? ""
            self.socketTypeLabel.text = items.sockets?[self.whichSocketSelected-1].socketType ?? ""
            self.powerLabel.text = "\(items.sockets?[self.whichSocketSelected-1].power ?? 0) "  + (items.sockets?[self.whichSocketSelected-1].powerUnit ?? "")
            self.dateLabel.text = self.formatDate(date: self.appointmentDate)
            self.hourLabel.text = self.appointmentHour
            
            self.socketId = items.sockets?[self.whichSocketSelected-1].socketID
            
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
    }
}
