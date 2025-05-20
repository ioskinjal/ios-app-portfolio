//
//  ViewController.swift
//  CalendarDemo
//
//  Created by NCrypted on 01/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import JTCalendar




class ViewController: UIViewController,JTCalendarDelegate {

    var calendarManager: JTCalendarManager?
    var _eventsByDate: [AnyHashable : Any] = [:]
    var _todayDate: Date?
    var _minDate: Date?
    var _maxDate: Date?
    var _dateSelected: Date?
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calenderContentView: JTHorizontalCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarManager = JTCalendarManager()
        calendarManager?.delegate = self
        createRandomEvents()
        createMinAndMaxDate()
        calendarManager?.menuView = calendarMenuView
        calendarManager?.contentView = calenderContentView
        let todayDate = Date()
        calendarManager?.setDate(todayDate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //#pragma mark - CalendarManager delegate
    
    func calendar(_ calendar: JTCalendarManager?, prepare dayView: JTCalendarDayView?) {
        // Today
        if (calendarManager?.dateHelper.date(Date(), isTheSameDayThan: dayView?.date))! {
            dayView?.circleView.isHidden = false
            dayView?.circleView.backgroundColor = UIColor.blue
            dayView?.dotView.backgroundColor = UIColor.white
            dayView?.textLabel.textColor = UIColor.white
        }else if (_dateSelected != nil) && (calendarManager?.dateHelper.date(_dateSelected, isTheSameDayThan: dayView?.date))! {
            dayView?.circleView.isHidden = false
            dayView?.circleView.backgroundColor = UIColor.red
            dayView?.dotView.backgroundColor = UIColor.white
            dayView?.textLabel?.textColor = UIColor.white
        }else if !(calendarManager?.dateHelper.date(calenderContentView.date, isTheSameMonthThan: dayView?.date))! {
            dayView?.circleView.isHidden = true
            dayView?.dotView.backgroundColor = UIColor.red
            dayView?.textLabel?.textColor = UIColor.lightGray
        }else {
            dayView?.circleView.isHidden = true
            dayView?.dotView.backgroundColor = UIColor.red
            dayView?.textLabel?.textColor = UIColor.black
        }
        if haveEvent(forDay: dayView?.date) {
            dayView?.dotView.isHidden = false
        } else {
            dayView?.dotView.isHidden = true
        }
    }

    func calendar(_ calendar: JTCalendarManager?, didTouch dayView: JTCalendarDayView?) {
        _dateSelected = dayView?.date
        // Animation for the circleView
        
      //  dayView?.circleView.transform = .identity.scaledBy(x: 0.1, y: 0.1)
        UIView.transition(with: dayView!, duration: 0.3, options: [], animations: {
            dayView?.circleView.transform = CGAffineTransform.identity
            self.calendarManager?.reload()
        })
        if (calendarManager?.settings.weekModeEnabled)! {
            return
        }
        // Load the previous or next page if touch a day from another month
        if !(calendarManager?.dateHelper.date(calenderContentView?.date, isTheSameMonthThan: dayView?.date))! {
            if calenderContentView?.date.compare((dayView?.date)!) == .orderedAscending {
                calenderContentView?.loadNextPageWithAnimation()
            } else {
                calenderContentView?.loadPreviousPageWithAnimation()
            }
        }
    }
    // MARK: - CalendarManager delegate - Page mangement
    // Used to limit the date for the calendar, optional
    func calendar(_ calendar: JTCalendarManager?, canDisplayPageWith date: Date?) -> Bool {
        return calendarManager!.dateHelper.date(date, isEqualOrAfter: nil, andEqualOrBefore: nil)
    }
    
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager?) {
        //    NSLog(@"Next page loaded");
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager?) {
        //    NSLog(@"Previous page loaded");
    }
    // MARK: - Fake data
    func createMinAndMaxDate() {
        _todayDate = Date()
        // Min date will be 2 month before today
        _minDate = calendarManager?.dateHelper.add(to: _todayDate, days: -2)
        
        // Max date will be 2 month after today
        _maxDate = calendarManager?.dateHelper.add(to: _todayDate, days: 2)
    }
    func dateFormatter() -> DateFormatter? {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "dd-MM-yyyy"
        }
        return dateFormatter
    }
    func haveEvent(forDay date: Date?) -> Bool {
        var key: String? = nil
        if let aDate = date {
            key = dateFormatter()?.string(from: aDate)
        }
        //if _eventsByDate[key ?? ""] && (_eventsByDate[key ?? ""]).count() > 0 {
            return true
       // }
       // return false
    }
    
    func createRandomEvents() {
        _eventsByDate = [AnyHashable : Any]()
        for i in 0..<30 {
            // Generate 30 random dates between now and 60 days later
            let randomDate = Date(timeInterval: TimeInterval((Int(arc4random()) % (3600 * 24 * 60))), since: Date())
            // Use the date as key for eventsByDate
            let key = dateFormatter()?.string(from: randomDate)
           // if !_eventsByDate[key] {
            _eventsByDate[key!] = [AnyHashable]()
          //  }
            //_eventsByDate[key!].append(randomDate)
        }
    }


}

