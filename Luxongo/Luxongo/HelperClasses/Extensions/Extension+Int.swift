//
//  Extension+Int.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


//https://stackoverflow.com/questions/29465205/how-to-add-minutes-to-current-time-in-swift
extension Int {
    var seconds: Int {
        return self
    }
    var minutes: Int {
        return self.seconds * 60
    }
    var hours: Int {
        return self.minutes * 60
    }
    var days: Int {
        return self.hours * 24
    }
    var weeks: Int {
        return self.days * 7
    }
    var months: Int {
        return self.weeks * 4
    }
    var years: Int {
        return self.months * 12
    }
}
/*
 //Usage:
 let threeDaysLater = TimeInterval(3.days)
 date.addingTimeInterval(threeDaysLater)
 */


extension Int{
    static func randomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}
