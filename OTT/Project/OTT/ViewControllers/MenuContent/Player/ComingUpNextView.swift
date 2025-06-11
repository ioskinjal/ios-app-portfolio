//
//  ComingUpNextView.swift
//  OTT
//
//  Created by Muzaffar on 03/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

@objc protocol ComingUpNextViewDelegate {
    @objc func comingUpNextViewDidTap()
}

class ComingUpNextView: UIView {

    @IBOutlet private weak var comingUpNextLabel: UILabel?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var imageView: UIImageView?

    weak var delegate : ComingUpNextViewDelegate?
    var  nextVideoContent : Card!
    var comingUpNextViewDisplaySeconds  = -1
    var card : Card?
    var shouldShow = true
    var isPlayerMinimized = false
    weak var player : AVPlayer?
    var forceHide = false 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func initiate(card : Card?, headerLabelText:String = ""){
        forceHide = false
        self.card = card
        self.comingUpNextLabel?.text = headerLabelText
        if let title = card?.display.title{
            self.titleLabel?.text = title
        }
        if let imageUrl = card?.display.imageUrl{
            imageView?.loadingImageFromUrl(imageUrl, category: "tv")
        }
    }
    
    func updateHiddenStateFor(duration : Float64, currentTime : Float64) {
        if (self.card == nil) || (self.shouldShow == false) || (self.isPlayerMinimized == true) || (playerVC != nil && (playerVC?.isMidRollAdPlaying == true)) {
            
            self.isHidden = true
            return;
        }
        
        if AppDelegate.getDelegate().configs?.nextVideoDisplayType.lowercased() == "p"{
            if let percentage = AppDelegate.getDelegate().configs?.nextVideoDisplayPercentage{
                self.comingUpNextViewDisplaySeconds = percentage * Int(duration) / 100
            }
        }
        else{ // nextVideoDisplayType = "S"
            if let seconds = AppDelegate.getDelegate().configs?.nextVideoDisplaySeconds{
                self.comingUpNextViewDisplaySeconds = Int(duration) - seconds
            }
        }
        
        if currentTime >= Float64(self.comingUpNextViewDisplaySeconds){
            self.isHidden = forceHide
        }
        else{
            self.isHidden = true
        }
    }
    
    func updateStates(){
        if let timeRanges = player?.currentItem?.seekableTimeRanges{
            if timeRanges.count > 0 {
                let timeRange: CMTimeRange = timeRanges.first!.timeRangeValue
                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
                let currentTime = CMTimeGetSeconds(player!.currentItem!.currentTime())
                self.updateHiddenStateFor(duration: durationSeconds, currentTime: currentTime)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.forceHide = true
        self.isHidden = true
        self.delegate?.comingUpNextViewDidTap()
    }
    
    deinit {
        print(#function)
    }

}
