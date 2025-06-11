//
//  NoInternetVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 18/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import AVFoundation

protocol NoInternetDelgate {
    
    func didCancel()
}

class NoInternetVC: UIViewController {

    @IBOutlet weak var lblNoInternet: UILabel!{
        didSet{
            lblNoInternet.text = "No Internet".localized
        }
    }
    @IBOutlet weak var lblConnection: UILabel!{
        didSet{
            lblConnection.text =  "Your connection appears to be offline.".localized
        }
    }
    @IBOutlet weak var imgBack: UIImageView!
    
    static var storyboardInstance:NoInternetVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: NoInternetVC.identifier) as? NoInternetVC
        
    }
    
    var player: AVPlayer?
    var delegate : NoInternetDelgate?
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if data._source?.onBoardingList[0].type == "video"{
            if data._source?.onBoardingList[0].status == "active" {
                self.loadVideo()
            }
        }else{
            self.imgBack.downLoadImage(url: (data._source?.onBoardingList[1].url)!)
        }
    }
    
    @IBAction func onClickRetry(_ sender: Any) {
        if delegate != nil{
            delegate?.didCancel()
        }
        self.dismiss(animated: true) {
            
        }
        
    }
    
    private func loadVideo() {
        player = AVPlayer(url: URL(string: (data._source?.onBoardingList[0].url)!)!)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        self.view.layer.addSublayer(playerLayer)
        
        player?.seek(to:kCMTimeZero)
        player?.play()
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
