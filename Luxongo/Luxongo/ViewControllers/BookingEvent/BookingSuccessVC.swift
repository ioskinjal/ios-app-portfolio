//
//  BookingSuccess.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BookingSuccessVC: BaseViewController {
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:BookingSuccessVC {
        return StoryBoard.bookingEvent.instantiateViewController(withIdentifier: BookingSuccessVC.identifier) as! BookingSuccessVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
