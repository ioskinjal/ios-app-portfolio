//
//  BookingFailVC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BookingFailVC: UIViewController {
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:BookingFailVC {
        return StoryBoard.bookingEvent.instantiateViewController(withIdentifier: BookingFailVC.identifier) as! BookingFailVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
