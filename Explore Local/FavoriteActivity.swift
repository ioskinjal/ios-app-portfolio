//
//  FavoriteActivity.swift
//  Explore Local
//
//  Created by admin on 3/27/19.
//  Copyright © 2019 NCrypted. All rights reserved.
//

import UIKit

class FavoriteActivity: UIActivity {

     func activityType() -> String? {
        return "TestActionss.Favorite"
    }
    
     func activityTitle() -> String? {
        return "Add to Favorites"
    }
    
     func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        NSLog("%@", #function)
        return true
    }
    
     func prepareWithActivityItems(activityItems: [AnyObject]) {
        NSLog("%@", #function)
    }
    
     func activityViewController() -> UIViewController? {
        NSLog("%@", #function)
        return nil
    }
    
    override func perform() {
        // Todo: handle action:
        NSLog("%@", #function)
        
        self.activityDidFinish(true)
    }
    
     func activityImage() -> UIImage? {
        return UIImage(named: "favorites_action")
    }
}
