//
//  SelectDateViewController.swift
//  Charger
//
//  Created by Evren Ustun on 8.07.2022.
//

import UIKit

class SelectDateViewController: UIViewController {
    
    @IBOutlet weak var datePickerTextField: UITextField!
    
    @IBOutlet weak var socketOneLabel: UILabel!
    @IBOutlet weak var socketTwoLabel: UILabel!
    @IBOutlet weak var socketThreeLabel: UILabel!
    @IBOutlet weak var socketTypeOneLabel: UILabel!
    @IBOutlet weak var socketTypeTwoLabel: UILabel!
    @IBOutlet weak var socketTypeThreeLabel: UILabel!
    @IBOutlet weak var socketOneTableView: UITableView!
    @IBOutlet weak var socketTwoTableView: UITableView!
    @IBOutlet weak var socketThreeTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var stationId: Int!
    private var subTitle: String?
    private var appointment: Appointment!
    
    private var selectDateTableViewHelper: SelectDateTableViewHelper!
    
    let datePicker = UIDatePicker()
    
    private let viewModel = SelectDateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func setupUI() {
        // Gradient background settings.
        prepareGradientBackground()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let constraints = [
            socketOneTableView.widthAnchor.constraint(equalToConstant: (screenWidth - 80)/3),
            socketTwoTableView.widthAnchor.constraint(equalToConstant: (screenWidth - 80)/3),
            socketThreeTableView.widthAnchor.constraint(equalToConstant: (screenWidth - 80)/3)
        ]
        NSLayoutConstraint.activate(constraints)
        
        datePickerTextField.textAlignment = .right 
        
        selectDateTableViewHelper = .init(with: socketOneTableView, socketTwoTableView: socketTwoTableView, socketThreeTableView: socketThreeTableView)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = Asset.grayscaleGray25.color
        
        createDatePicker()
        viewModel.delegate = self
        viewModel.getAvailableAppointments(stationId, datePicker.date)
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
    
    func createDatePicker(){

        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        datePickerTextField.inputAccessoryView = toolbar
        
        // date picker mode
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datepicker:)), for: UIControl.Event.valueChanged)
        
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        
        // Get the current year
        let year = Calendar.current.component(.year, from: Date())
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear)
            datePicker.maximumDate = lastOfYear
        }
        // assign date picker to the text field
        datePickerTextField.inputView = datePicker
        datePickerTextField.text = formatDate(date: Date()) // today
    }
    
    @objc
    func doneTapped(){
        datePickerTextField.text = formatDate(date: datePicker.date)
       
        viewModel.getAvailableAppointments(stationId, datePicker.date)
//        selectDateTableViewHelper.reloadTable(items: appointment)
        self.view.endEditing(true)
    }
    
    @objc
    func dateChange(datepicker: UIDatePicker){
        datePickerTextField.text = formatDate(date: datepicker.date)
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
         
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppointmentSummaryViewController") as? AppointmentSummaryViewController{
            vc.appointmentDate = datePicker.date
            vc.stationId = stationId
            vc.whichSocketSelected = selectDateTableViewHelper.socketNumber
            vc.appointmentHour = selectDateTableViewHelper.hour
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension SelectDateViewController: SelectDateViewModelDelegate {
    func didItemsFetch(_ items: Appointment) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.appointment = items
            self.subTitle = items.stationName
            self.navigationItem.titleView =  self.setTitle(title: "Tarih ve Saat Seçin", subtitle: self.subTitle ?? "")
            self.socketTypeOneLabel.text = "\(items.sockets![0].chargeType!) • \(items.sockets![0].socketType!)"
            self.socketTypeTwoLabel.text = "\(items.sockets?[1].chargeType ?? " ") • \(items.sockets?[1].socketType ?? " ")"
            self.socketTypeThreeLabel.text = "\(items.sockets?[2].chargeType ?? " ") • \(items.sockets?[2].socketType ?? " ")"
            self.selectDateTableViewHelper.reloadTable(items: items)
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
        }
    }
}
