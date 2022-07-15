//
//  SelectDateTableViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 8.07.2022.
//

import UIKit

class SelectDateTableViewHelper: NSObject {
    
    weak var socketOneTableView: UITableView!
    weak var socketTwoTableView: UITableView!
    weak var socketThreeTableView: UITableView!
    var previousIndexPath: IndexPath?
    var firsListSelected: [Int] = []
    var secondListSelected: [Int] = []
    var thirdListSelected: [Int] = []
    var socketNumber: Int = 0
    var hour: String = ""
    var socketCount: Int = 1
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
        socketTwoTableView.register(.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell")
        socketThreeTableView.register(.init(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell")
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
        if socketCount == 1 {
            if tableView.tag == 0{
                return appointment?.sockets?[0].day?.timeSlots?.count ?? 0
            }
        } else if socketCount == 2 {
            if tableView.tag == 0{
                return appointment?.sockets?[0].day?.timeSlots?.count ?? 0
            }
            else if tableView.tag == 1 {
                return appointment?.sockets?[1].day?.timeSlots?.count ?? 0
            }
        }else if socketCount == 3{
            if tableView.tag == 0{
                return appointment?.sockets?[0].day?.timeSlots?.count ?? 0
            }
            else if tableView.tag == 1 {
                return appointment?.sockets?[1].day?.timeSlots?.count ?? 0
            }else {
                return appointment?.sockets?[2].day?.timeSlots?.count ?? 0
            }
        }
        return 0
    }
    
    private func disabledCell(_ cell: SelectDateTableViewCell){
        cell.isUserInteractionEnabled = false
        cell.hourLabel.textColor = Asset.grayscaleGray25.color
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if socketCount == 1{
            socketOneTableView.isHidden = false
            socketTwoTableView.isHidden = true
            socketThreeTableView.isHidden = true
            
            if tableView.tag == 0 {
                if let cell = socketOneTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 0)
                    firsListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
            }
        }else if socketCount == 2 {
            socketOneTableView.isHidden = false
            socketTwoTableView.isHidden = false
            socketThreeTableView.isHidden = true
            
            if tableView.tag == 0 {
                if let cell = socketOneTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 0)
                    firsListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
            }else if tableView.tag == 1 {
                if let cell = socketTwoTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 1)
                    secondListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
            }
        }else if socketCount == 3 {
            socketOneTableView.isHidden = false
            socketTwoTableView.isHidden = false
            socketThreeTableView.isHidden = false
            
            if tableView.tag == 0 {
                if let cell = socketOneTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 0)
                    firsListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
            }else if tableView.tag == 1 {
                if let cell = socketTwoTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 1)
                    secondListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
            }else {
                if let cell = socketThreeTableView.dequeueReusableCell(withIdentifier: "SelectDateTableViewCell", for: indexPath) as? SelectDateTableViewCell{
                    tableViewSettings(cell, indexPath, 2)
                    thirdListSelected.contains(indexPath.row) ?  selectedCellStyle(cell, indexPath) : resetCellStyle(cell)
                    
                    return cell
                }
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
        
        if socketCount == 1 {
            if tableView.tag == 0 {
                if firsListSelected.contains(indexPath.row) {
                    firsListSelected = firsListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    firsListSelected.append(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![0].socketNumber)!
                hour = cell.hourLabel.text ?? ""
                
            }
        }else if socketCount == 2 {
            if tableView.tag == 0 {
                if firsListSelected.contains(indexPath.row) {
                    firsListSelected = firsListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    firsListSelected.append(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![0].socketNumber)!
                hour = cell.hourLabel.text ?? ""
                
            }else if tableView.tag == 1 {
                if secondListSelected.contains(indexPath.row) {
                    secondListSelected = secondListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    secondListSelected.append(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![1].socketNumber)!
                hour = cell.hourLabel.text ?? ""
            }
        }else if socketCount == 3 {
            if tableView.tag == 0 {
                
                if firsListSelected.contains(indexPath.row) {
                    firsListSelected = firsListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    firsListSelected.append(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![0].socketNumber)!
                hour = cell.hourLabel.text ?? ""
            }else if tableView.tag == 1 {
                if secondListSelected.contains(indexPath.row) {
                    secondListSelected = secondListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    secondListSelected.append(indexPath.row)
                    
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![1].socketNumber)!
                hour = cell.hourLabel.text ?? ""
            }else {
                if thirdListSelected.contains(indexPath.row) {
                    thirdListSelected = thirdListSelected.filter{$0 != indexPath.row}
                } else {
                    removeListAndReloadTable()
                    thirdListSelected.append(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = tableView.cellForRow(at: indexPath) as! SelectDateTableViewCell
                
                socketNumber = (appointment?.sockets![2].socketNumber)!
                hour = cell.hourLabel.text ?? ""
            }
        }
    }
    
    private func tableViewSettings(_ cell: SelectDateTableViewCell, _ indexPath: IndexPath, _ tableViewNumber: Int) {
        cellStyle(cell)
        cell.hourLabel.text = appointment?.sockets?[tableViewNumber].day?.timeSlots?[indexPath.row].slot ?? ""
        
        if appointment?.sockets?[tableViewNumber].day?.timeSlots?[indexPath.row].isOccupied ?? false{
            cell.isUserInteractionEnabled = false
            cell.hourLabel.textColor = Asset.grayscaleGray25.color
        }
    }
    
    private func removeListAndReloadTable(){
        firsListSelected.removeAll()
        secondListSelected.removeAll()
        thirdListSelected.removeAll()        
        DispatchQueue.main.async {
            self.socketOneTableView.reloadData()
            self.socketTwoTableView.reloadData()
            self.socketThreeTableView.reloadData()
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
        cell.contentView.backgroundColor = Asset.dark.color
        cell.containerView.backgroundColor = Asset.dark.color
        cell.containerView.layer.borderColor = Asset.mainPrimary.color.cgColor
        cell.containerView.layer.borderWidth = 1.0
        cell.containerView.layer.cornerRadius = 7
        cell.contentView.layer.cornerRadius = 7
    }
}
