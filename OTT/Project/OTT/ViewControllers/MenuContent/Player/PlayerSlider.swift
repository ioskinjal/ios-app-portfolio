    //
//  PlayerSlider.swift
//  OTT
//
//  Created by Muzaffar on 09/05/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit

    class PlayerSlider: UISlider {
        var oldValue : Float?
        var maxForwardValue : Float = 0
        var disableFarwardSeek = false
        
        override func trackRect(forBounds bounds: CGRect) -> CGRect {
            var newBounds = super.trackRect(forBounds: bounds)
            newBounds.size.height = 5
            return newBounds
        }
        override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
            let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
            let thumbOffsetToApplyOnEachSide:CGFloat = unadjustedThumbrect.size.width / 2.0
            let minOffsetToAdd = -thumbOffsetToApplyOnEachSide
            let maxOffsetToAdd = thumbOffsetToApplyOnEachSide
            let diffVal = (self.maximumValue - self.minimumValue)
            let offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (diffVal > 0 ? diffVal : 1 ))
            var origin = unadjustedThumbrect.origin
            origin.x += offsetForValue
            return CGRect(origin: origin, size: unadjustedThumbrect.size)
        }
    }
