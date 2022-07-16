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
    var stationName: String!
    private let notificationPublisher = NotificationPublisher()
    let notificationTime: [String] = ["5 dakika önce", "10 dakika önce", "15 dakika önce", "30 dakika önce", "1 saat önce", "2 saat önce", "3 saat önce"]
    var notificationPickerView = UIPickerView()
    var popup: Popup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getAppointmentSummary(stationId, appointmentDate)
    }
    
    @IBAction func didSwitchChange(_ sender: Any) {
        if notificationSwitch.isOn {
            notificationScheduleTextField.isHidden = false
        }else {
            notificationScheduleTextField.isHidden = true
        }
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
        imageIcon.tintColor = Asset.grayscaleGray25.color
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(systemName: "chevron.down")!.size.width, height: UIImage(systemName: "chevron.down")!.size.height)
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: UIImage(systemName: "chevron.down")!.size.width, height: UIImage(systemName: "chevron.down")!.size.height)
        
        notificationScheduleTextField.isHidden = true
        notificationScheduleTextField.rightView =  contentView
        notificationScheduleTextField.rightViewMode = .always
        
        notificationScheduleTextField.delegate = self
        notificationScheduleTextField.tintColor = .clear
    }
    
    private func pickerViewSettings(){
        notificationScheduleTextField.inputView = notificationPickerView
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        notificationScheduleTextField.text = notificationTime[3]
        notificationPickerView.selectRow(3, inComponent: 0, animated: true)
    }
    
    private func setTitle(title:String, subtitle:String) -> UIView {
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
        
    private func minuteToSecond(_ minute: Int) -> Int{
        return minute * 60
    }
    
    private func stringToTime(_ timeStr: String) -> (Int, Int) {
        var hours = 0
        var minutes = 0
        let patternH = "[0-9]*[:]" // digits, followed by :
        let regexH = try! NSRegularExpression(pattern: patternH, options: .caseInsensitive)
        if let matchH = regexH.firstMatch(in: timeStr, range: NSRange(0..<timeStr.utf16.count)) {
            let hStr = String(timeStr[Range(matchH.range(at: 0), in: timeStr)!]).dropLast()
            hours = Int(hStr) ?? 0
            let patternM = "[:][0-9]{1,2}"  //  1 or 2 digits
            let regexM = try! NSRegularExpression(pattern: patternM, options: .caseInsensitive)
            if let matchM = regexM.firstMatch(in: timeStr, range: NSRange(0..<timeStr.utf16.count)) {
                let mStr = String(timeStr[Range(matchM.range(at: 0), in: timeStr)!]).dropFirst()
                minutes = Int(mStr) ?? 0
            }
        }
        
        return (hours, minutes)
    }
    
    // The hour and minute difference between the two given hours
    private func timeDifference(_ time1: (Int, Int), _ time2: (Int, Int)) -> (Int, Int){
        var time = (time1.0 - time2.0, time1.1 - time2.1)
        if time.1 < 0 {
            time.1 = time.1 + 60
            time.0 -= 1
        }
        print(time)
        return time
    }
    
    @IBAction func didApproveAppointmentButtonTapped(_ sender: Any) {
        if notificationSwitch.isOn {
            //Bugünün saat ve dakikası
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            print(hour)
            print(minutes)
            
            var components = calendar.dateComponents([.day], from: Date.now, to: appointmentDate)
            if !calendar.isDateInToday(appointmentDate){
                components.day! += 1
            }
            
            let dayToSeconds = components.day! * 3600
            
            let today = stringToTime("\(hour):\(minutes)")
            
            let appointmentTime = (appointmentHour).split(separator: ":")[0]
            
            let reminder = (notificationScheduleTextField.text)!.split(separator: " ")
            
            var alertTime: (Int, Int) = (0,0)
            
            switch notificationScheduleTextField.text {
            case "5 dakika önce":
                alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 1):\(60 - (Int(reminder[0]) ?? 0))")
            case "10 dakika önce":
                alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 1):\(60 - (Int(reminder[0]) ?? 0))")
            case "15 dakika önce":
                alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 1):\(60 - (Int(reminder[0]) ?? 0))")
            case "30 dakika önce":
                alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 1):\(60 - (Int(reminder[0]) ?? 0))")
            case "1 saat önce":
                if  ((Int(appointmentTime) ?? 0) - 1) < 0 {
                    alertTime = stringToTime("23:00")
                }else {
                    alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 1):00")
                }
            case "2 saat önce":
                if  ((Int(appointmentTime) ?? 0) - 2) == -1 {
                    alertTime = stringToTime("23:00")
                } else if ((Int(appointmentTime) ?? 0) - 2) == -2 {
                    alertTime = stringToTime("22:00")
                }else {
                    alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 2):00")
                }
            case "3 saat önce":
                if  ((Int(appointmentTime) ?? 0) - 3) == -1 {
                    alertTime = stringToTime("23:00")
                } else if ((Int(appointmentTime) ?? 0) - 3) == -2 {
                    alertTime = stringToTime("22:00")
                } else if ((Int(appointmentTime) ?? 0) - 3) == -3 {
                    alertTime = stringToTime("21:00")
                } else {
                    alertTime = stringToTime("\((Int(appointmentTime) ?? 0) - 3):00")
                }
            case .none:
                print("none")
            case .some(_):
                print("some")
            }
            
            let totalTime = timeDifference(alertTime, today)
            print("total time: \(totalTime)")
            
            let seconds = totalTime.0 * 3600 + totalTime.1 * 60 + dayToSeconds
            
            if seconds <= 0 {
                self.popup = Popup(frame: self.view.frame)
                
                popup.firstButton.setImage(Asset.editButton.image, for: .normal)
                popup.secondButton.setImage(Asset.continueWithoutNotifyButton.image, for: .normal)
                
                self.popup.firstButton.addTarget(self, action: #selector(didEditButtonTapped), for: .touchUpInside)
                self.popup.secondButton.addTarget(self, action: #selector(didContinueWithoutNotifyButtonButtonTapped), for: .touchUpInside)
                self.view.addSubview(popup)
                
                print("seconds küçükk")
            } else {
                notificationPublisher.sendNotification(title: "Yaklaşan Randevu", subtitle: nil, body: "\(stationName!) istasyonu için oluşturduğunuz randevunuza \(reminder[0]) \(reminder[1]) kaldı", badge: nil, delayInterval: seconds)
                viewModel.getApprovedAppointment(stationId, socketId, hourLabel.text ?? "", appointmentDate)
                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else {
            viewModel.getApprovedAppointment(stationId, socketId, hourLabel.text ?? "", appointmentDate)
            if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc
    func didEditButtonTapped(){
        self.popup.removeFromSuperview()
    }
    
    @objc
    func didContinueWithoutNotifyButtonButtonTapped(){
        self.popup.removeFromSuperview()
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
    func didApprovedAppointmentsFetch(_ items: ApprovedAppointment) {}
    
    func didItemsFetch(_ items: Appointment) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.stationName = items.stationName ?? ""
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

extension AppointmentSummaryViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
