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
    
    private var selectDateTableViewHelper: SelectDateTableViewHelper!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.titleView =  setTitle(title: "Tarih ve Saat Seçin", subtitle: "BORUSAN OTO SAMANDIRA")
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
        
        datePickerTextField.inputView = datePicker
        datePickerTextField.text = formatDate(date: Date()) // today
        
        // assign date picker to the text field
        datePickerTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc
    func doneTapped(){
        datePickerTextField.text = formatDate(date: datePicker.date)
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
         
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        print("Devam et tıklandı.")
    }
}
