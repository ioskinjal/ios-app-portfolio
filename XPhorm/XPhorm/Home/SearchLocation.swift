//
//  SearchLocation.swift
//  XPhorm
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchLocation: NSObject,MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D
        
        
        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
}
