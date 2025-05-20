//
//  SplashVC.swift
//  XPhorm
//
//  Created by admin on 8/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation


class SplashVC: UIViewController {

    var player: AVPlayer?
     var isLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadVideo()
    }
    
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "splash_video", ofType:"mp4")
        
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        self.view.layer.addSublayer(playerLayer)
        
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        redirectToVC()
    }

    private func redirectToVC(){
        
        self.isLogin = true
        if  UserDefaults.standard.bool(forKey: "isFirstLogin") == true {
            
            appDelegate?.window?.rootViewController = showCaseVC.storyboardInstance!
        }else{
            let user  = UserData.shared.getUser()
            if user == nil{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontrollerHome") as! UITabBarController
                viewController.tabBar.isHidden = true
                appDelegate?.window?.rootViewController = viewController;
                appDelegate?.window?.makeKeyAndVisible()
            }else{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                
                appDelegate?.window?.rootViewController = viewController;
                appDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
