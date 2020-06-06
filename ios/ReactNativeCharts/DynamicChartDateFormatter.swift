//
//  DynamicChartDateFormatter.swift
//  ReactNativeCharts
//
//  Created by Taylor Johnson on 6/5/20.
//

import Foundation
import Charts

extension Date {
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
}

// assumes values are -Index
// TODO take timeUnit
// TODO clean up
open class DynamicChartDateFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
    
    open var dateFormatter = DateFormatter()
    
    open var dates = [Double]()
    
    public override init() {
        
    }
    
    public init(dates: [Double], locale: String?) {
        self.dates = dates
        self.dateFormatter.locale = Locale(identifier: locale ?? Locale.current.languageCode ?? "en_US")
    }

    open func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateIndex = -Int(value.rounded())
        guard dates.indices.contains(dateIndex), dateIndex == -Int(value) else { return "" }
        
        let date = Date(timeIntervalSince1970: dates[dateIndex] / 1000)
        
        let entries = axis?.entries ?? []
        guard let entryIndex = entries.firstIndex(of: value) else { return "" }

        if (entryIndex == 0) {
            let entryInterval = abs(Int(entries[1] - entries[0]))
            let previousDateIndex = dateIndex + entryInterval
            return formatByPreviousDateIndex(previousDateIndex, date: date)
        }
        
        let previousDateIndex = -Int(entries[entryIndex - 1].rounded())
        return formatByPreviousDateIndex(previousDateIndex, date: date)
    }
    
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        // TODO impl
        return ""
    }

    private func formatByPreviousDateIndex(_ previousDateIndex: Int, date: Date) -> String {
        guard dates.indices.contains(previousDateIndex) else { return "" }
        let previousDate = Date(timeIntervalSince1970: dates[previousDateIndex] / 1000)

        updateFormatting(date1: date, date2: previousDate)

        return dateFormatter.string(from: date)
    }
    
    // If value diff > year
        // return year number
    // If value diff > month
        // return month number
    // If value diff > day
        // return day number
    // else
        // return HH:mm
    private func updateFormatting(date1: Date, date2: Date) {
        if (!date1.isInSameYear(as: date2)) {
            dateFormatter.dateFormat = "yyyy"
        } else if (!date1.isInSameMonth(as: date2)) {
            dateFormatter.dateFormat = "MMM"
        } else if (!date1.isInSameDay(as: date2)) {
            dateFormatter.dateFormat = "d"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
    }
    
}
