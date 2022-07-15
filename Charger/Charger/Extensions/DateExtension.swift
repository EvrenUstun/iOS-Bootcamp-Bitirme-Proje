//
//  DateExtensions.swift
//  Charger
//
//  Created by Evren Ustun on 14.07.2022.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    
    func localizedDescription(date dateStyle: DateFormatter.Style = .medium,
                                  time timeStyle: DateFormatter.Style = .medium,
                                  in timeZone: TimeZone = .current,
                                  locale: Locale = .current,
                                  using calendar: Calendar = .current) -> String {
        DateFormatter().calendar = calendar
        DateFormatter().locale = locale
        DateFormatter().timeZone = timeZone
        DateFormatter().dateStyle = dateStyle
        DateFormatter().timeStyle = timeStyle
            return DateFormatter().string(from: self)
        }
        var localizedDescription: String { localizedDescription() }
    
    var shortTime: String { localizedDescription(date: .none, time: .short) }
    
}
