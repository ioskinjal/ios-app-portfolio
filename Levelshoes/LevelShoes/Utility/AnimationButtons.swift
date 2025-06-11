//
//  AnimationButtons.swift
//  LevelShoes
//
//  Created by Maa on 23/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func animateTap() {
        alpha = 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.alpha = 1
        }
    }
    
    func animShowBuuton(duration: Double = 0.5) {
        self.alpha = 0
        self.isHidden = false
        self.center.y += self.bounds.height
        UIView.animate(withDuration: duration) {
            self.center.y -= self.bounds.height
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func animateViewButton(){
        UIView.animate(withDuration: 3, delay: 0, options: [.transitionCrossDissolve],
                       animations: {
                        self.bounds.origin.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }

    func set_image(_ image: UIImage, animated: Bool = true) {
        let sender = self
        if animated == true {
            
        }
        UIView.animate(withDuration: 0.15, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                sender.setImage(image, for: .normal)
            }
        }
    }
}

