//
//  FilterViewHelper.swift
//  Charger
//
//  Created by Evren Ustun on 7.07.2022.
//

import Foundation
import UIKit

class FilterViewHelper {
    
    var chargerTypeFilter: [String] = []
    var socketTypeFilter: [String] = []
    var serviceFilter: [String] = []
    
    init(){}
    
    func setSettingsForButton(_ button: UIButton!){
        button.layer.borderColor = Asset.grayscaleGray25.color.cgColor
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
    }
    
    func switchButtonStyle(_ button: UIButton!, _ isClear: Bool = false){
        if button.backgroundColor == Asset.dark.color || isClear{
            button.layer.borderColor = Asset.grayscaleGray25.color.cgColor
            button.backgroundColor = UIColor.clear
            switchCaseForFilterRemove(button.titleLabel!.text!)
        }else {
            button.layer.borderColor = Asset.mainPrimary.color.cgColor
            button.backgroundColor = Asset.dark.color
            switchCaseForFilter(button.titleLabel!.text!)
        }
    }
    
    func switchCaseForFilterRemove(_ buttonLabel: String){
        switch buttonLabel {
        case "AC":
            if let index = chargerTypeFilter.firstIndex(of: "AC") {
                chargerTypeFilter.remove(at: index)
            }
        case "DC (Hızlı Şarj)":
            if let index = chargerTypeFilter.firstIndex(of: "DC") {
                chargerTypeFilter.remove(at: index)
            }
        case "Type 2":
            if let index = socketTypeFilter.firstIndex(of: "Type-2") {
                socketTypeFilter.remove(at: index)
            }
        case "CSC":
            if let index = socketTypeFilter.firstIndex(of: "CSC") {
                socketTypeFilter.remove(at: index)
            }
        case "CHAdeMO":
            if let index = socketTypeFilter.firstIndex(of: "CHAdeMO") {
                socketTypeFilter.remove(at: index)
            }
        case "Otopark":
            if let index = serviceFilter.firstIndex(of: "Otopark") {
                serviceFilter.remove(at: index)
            }
        case "Büfe":
            if let index = serviceFilter.firstIndex(of: "Büfe") {
                serviceFilter.remove(at: index)
            }
        case "Wi-Fi":
            if let index = serviceFilter.firstIndex(of: "Wi-Fi") {
                serviceFilter.remove(at: index)
            }
        default:
            print("")
        }
    }
    
    func switchCaseForFilter(_ buttonLabel: String){
        switch buttonLabel {
        case "AC":
            chargerTypeFilter.append("AC")
        case "DC (Hızlı Şarj)":
            chargerTypeFilter.append("DC")
        case "Type 2":
            socketTypeFilter.append("Type-2")
        case "CSC":
            socketTypeFilter.append("CSC")
        case "CHAdeMO":
            socketTypeFilter.append("CHAdeMO")
        case "Otopark":
            serviceFilter.append("Otopark")
        case "Büfe":
            serviceFilter.append("Büfe")
        case "Wi-Fi":
            serviceFilter.append("Wi-Fi")
        default:
            print("")
        }
    }
}
