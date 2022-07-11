//
//  SelectDateTableViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 8.07.2022.
//

import UIKit

class SelectDateTableViewHelper: NSObject {
    
    var numbers: [String] = ["1", "2" ,"3"]
    
    weak var socketOneTableView: UITableView!
    weak var socketTwoTableView: UITableView!
    weak var socketThreeTableView: UITableView!
    var previousIndexPath: IndexPath?
    var test: NSMutableArray = []
    
    var socketNumber: Int = 0
    var hour: String = ""
    
    private var appointment: Appointment?
    
    init(
        with socketOneTableView: UITableView,
        socketTwoTableView: UITableView,
        socketThreeTableView: UITableView
    ) {
        super.init()
        
        self.socketOneTableView = socketOneTableView
        self.socketTwoTableView = socketTwoTableView
        self.socketThreeTableView = socketThreeTableView
        
        self.socketOneTableView?.delegate = self
        self.socketOneTableView?.dataSource = self
        
        self.socketTwoTableView?.delegate = self
        self.socketTwoTableView?.dataSource = self
        
        self.socketThreeTableView?.delegate = self
        self.socketThreeTableView?.dataSource = self
        
        registerCell()
    }
    
    private func registerCell(){
        socketOneTableView.register(.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell")
        socketTwoTableView.register(.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell2")
        socketThreeTableView.register(.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell3")
    }
    
    func reloadTable(items: Appointment){
        appointment = items
        socketOneTableView.reloadData()
        socketTwoTableView.reloadData()
        socketThreeTableView.reloadData()
    }
    
}

extension SelectDateTableViewHelper: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView.tag == 0 {
            return appointment?.sockets?[0].day?.timeSlots?.count ?? 0
        }else if tableView.tag == 1 {
            return appointment?.sockets?[1].day?.timeSlots?.count ?? 0
        }else {
            return appointment?.sockets?[2].day?.timeSlots?.count ?? 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            if let cell = socketOneTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                cellStyle(cell)
                cell.hourLabel.text = appointment?.sockets?[0].day?.timeSlots?[indexPath.row].slot ?? ""
                if appointment?.sockets?[0].day?.timeSlots?[indexPath.row].isOccupied ?? false{
                    cell.isUserInteractionEnabled = false
                    cell.hourLabel.textColor = Asset.grayscaleGray25.color
                }
                cell.tag = indexPath.row
                test.addObjects(from: [cell])
                return cell
            }
        }else if tableView.tag == 1 {
            if let cell = socketTwoTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell2", for: indexPath) as? SelectDateTableViewCell{
                cellStyle(cell)
                cell.hourLabel.text = appointment?.sockets?[1].day?.timeSlots?[indexPath.row].slot ?? ""
                if appointment?.sockets?[1].day?.timeSlots?[indexPath.row].isOccupied ?? false{
                    cell.isUserInteractionEnabled = false
                    cell.hourLabel.textColor = Asset.grayscaleGray25.color
                }
                cell.tag = indexPath.row
                return cell
            }
        }else {
            if let cell = socketThreeTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell3", for: indexPath) as? SelectDateTableViewCell{
                cellStyle(cell)
                cell.hourLabel.text = appointment?.sockets?[2].day?.timeSlots?[indexPath.row].slot ?? ""
                if appointment?.sockets?[2].day?.timeSlots?[indexPath.row].isOccupied ?? false{
                    cell.isUserInteractionEnabled = false
                    cell.hourLabel.textColor = Asset.grayscaleGray25.color
                }
                cell.tag = indexPath.row
                return cell
            }
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 60
        }else if tableView.tag == 1 {
            return 60
        }else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 0 {
            print("1")
            let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
            
            if previousIndexPath != nil {
                let previousCell = tableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell2 = socketTwoTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell3 = socketThreeTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                
                resetCellStyle(previousCell)
                resetCellStyle(previousCell2)
                resetCellStyle(previousCell3)
            }
            previousIndexPath = indexPath
            selectedCellStyle(cell, indexPath)
            socketNumber = (appointment?.sockets![0].socketNumber)!
            hour = cell.hourLabel.text ?? ""
            
        }else if tableView.tag == 1 {
            print("2")
            let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell

            if previousIndexPath != nil {
                let previousCell = tableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell2 = socketOneTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell3 = socketThreeTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                
                resetCellStyle(previousCell)
                resetCellStyle(previousCell2)
                resetCellStyle(previousCell3)
            }
            previousIndexPath = indexPath
            selectedCellStyle(cell, indexPath)
            socketNumber = (appointment?.sockets![1].socketNumber)!
            hour = cell.hourLabel.text ?? ""
        }else {
            print("3")
            let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell

            if previousIndexPath != nil {
//                print(previousIndexPath)
                let previousCell2 = socketOneTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell3 = socketTwoTableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                let previousCell = tableView.cellForRow(at: previousIndexPath!) as! SelectDateTableViewCell
                
                resetCellStyle(previousCell)
                resetCellStyle(previousCell2)
                resetCellStyle(previousCell3)
            }
            previousIndexPath = indexPath
            selectedCellStyle(cell, indexPath)
            socketNumber = (appointment?.sockets![2].socketNumber)!
            hour = cell.hourLabel.text ?? ""
        }
    }
    
    private func cellStyle(_ cell: SelectDateTableViewCell){
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    private func resetCellStyle(_ previousCell: SelectDateTableViewCell) {
        previousCell.contentView.backgroundColor = Asset.charcoalGrey.color
        previousCell.containerView.backgroundColor = Asset.charcoalGrey.color
        previousCell.containerView.layer.borderColor = UIColor.clear.cgColor
        previousCell.containerView.layer.borderWidth = 0.0
    }
    
    private func selectedCellStyle(_ cell: SelectDateTableViewCell, _ indexPath: IndexPath){
//        previousIndexPath = indexPath
        cell.contentView.backgroundColor = Asset.dark.color
        cell.containerView.backgroundColor = Asset.dark.color
        cell.containerView.layer.borderColor = Asset.mainPrimary.color.cgColor
        cell.containerView.layer.borderWidth = 1.0
        cell.containerView.layer.cornerRadius = 7
        cell.contentView.layer.cornerRadius = 7
    }
}
