//
//  AccontDelegate.swift
//  sampleColView
//
//  Created by Muzaffar on 13/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit

@objc protocol AccontDelegate{
    @objc optional func  didFinishSignIn(finished : Bool)
    @objc optional func  didFinishSignUp()
    @objc optional func  didFinishOTPValidation()
}
