//
//  NSObjectExtension.swift
//  MobiloitteDemo
//
//  Created by Maa on 27/05/20.
//  Copyright © 2020 Chandan Jee. All rights reserved.
//

import Foundation
extension NSObject {
    class var name: String {
        return String(describing: self)
    }
}
