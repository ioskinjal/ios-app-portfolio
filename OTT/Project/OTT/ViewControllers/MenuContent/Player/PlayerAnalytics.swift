//
//  PlayerAnalytics.swift
//  sampleColView
//
//  Created by Mohan Agadkar on 08/08/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import Foundation

extension PlayerViewController {
    
    func reportSeekEvent(_ seekStart : Bool = false) {
        print("log :: ", #function)
        if sliderPlayer.value < 0 {
            return
        }
        if seekStart {
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().triggerLogEvent(eventTrigger.trigger_seek_start, position: Int(Int32(sliderPlayer.value)))
            }
//            if appContants.isEnabledConviva && self.session != nil {
////                var seekToPosition : Float64 = CMTimeGetSeconds(self.player.avplayer.currentItem!.duration)
////                seekToPosition  = seekToPosition  * Float64(sliderPlayer.value)
//                let seekToPosition : Float64 = Float64(sliderPlayer.value)
//                self.session.setSeekStart(NSInteger(seekToPosition))
//                self.player.avplayer.seek(to:CMTimeMake(Int64(seekToPosition ), 1), completionHandler: { (isFinished:Bool) in
//                    if isFinished == true {
//                        self.session.setSeekEnd(NSInteger(seekToPosition ))
//                    }
//                })
//            }
        } else {
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().triggerLogEvent(eventTrigger.trigger_seek_end, position: Int(Int32(sliderPlayer.value)))
            }
        }
    }
    
    func reportError(_ errorMessage : String) {
        print("log :: ", #function)
        if appContants.isEnabledAnalytics {
            logAnalytics.shared().sendError(errorMessage)
        }
        
//        if appContants.isEnabledConviva && self.session != nil {
//            self.session.reportError(errorMessage, errorType: ErrorSeverity.SEVERITY_FATAL)
//        }
    }
    
    func clearSession(_ playReachedEnd : Bool = false) {
        print("log :: ", #function)
        if appContants.isEnabledAnalytics && self.a_m_d != nil && self.a_m_d.count > 0 {
            logAnalytics.shared().closeSession(playReachedEnd)
        }
        
//        if appContants.isEnabledConviva &&  self.c_m_d != nil && self.c_m_d.count > 0 && self.session != nil{
//            LivePass.cleanupSession(self.session)
//            self.session = nil
//        }
    }

}
