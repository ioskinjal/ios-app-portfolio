//
//  Extension+Date.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension UIDatePicker {
    //https://stackoverflow.com/questions/10494174/minimum-and-maximum-date-in-uidatepicker
    func setLimit(forCalendarComponent component:Calendar.Component, minimumUnit min: Int, maximumUnit max: Int) {
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        guard let timeZone = TimeZone(identifier: "UTC") else { return }
        calendar.timeZone = timeZone
        
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        
        components.setValue(-min, for: component)
        if let maxDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.maximumDate = maxDate
        }
        
        components.setValue(-max, for: component)
        if let minDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.minimumDate = minDate
        }
    }
    
}
//self.datePicker.setLimit(forCalendarComponent: .year, minimumUnit: 13, maximumUnit: 100)

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}


extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

//Use
// returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
//print(Date().dayNumberOfWeek()!) // 4




//https://stackoverflow.com/questions/41646542/how-do-you-compare-just-the-time-of-a-date-in-swift?rq=1
class Time: Comparable, Equatable {
    init(_ date: Date) {
        //get the current calender
        let calendar = Calendar.current
        
        //get just the minute and the hour of the day passed to it
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }
    
    init(_ hour: Int, _ minute: Int) {
        //calculate the seconds since the beggining of the day for comparisions
        let dateSeconds = hour * 3600 + minute * 60
        
        //set the varibles
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }
    
    var hour : Int
    var minute: Int
    
    var date: Date {
        //get the current calender
        let calendar = Calendar.current
        
        //create a new date components.
        var dateComponents = DateComponents()
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return calendar.date(byAdding: dateComponents, to: Date())!
    }
    
    /// the number or seconds since the beggining of the day, this is used for comparisions
    private let secondsSinceBeginningOfDay: Int
    
    //comparisions so you can compare times
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }
    
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }
    
    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }
    
    
    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }
    
    
    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
}

extension Date {
    var time: Time {
        return Time(self)
    }
}


extension Date{
    func dateAsString(formate:String = DateFormatter.appDateTimeFormat) -> String{
        let formatter2 = DateFormatter()
        formatter2.dateFormat = formate
        let selectedDate = formatter2.string(from: self)
        return selectedDate
    }
}

