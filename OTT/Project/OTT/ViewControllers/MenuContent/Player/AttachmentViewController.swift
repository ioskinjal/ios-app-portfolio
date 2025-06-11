//
//  AttachmentViewController.swift
//  OTT
//
//  Created by Chandoo on 22/03/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    @IBOutlet weak var attachmentView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!

    var attachmentImagePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        attachmentView.loadingImageFromUrl(attachmentImagePath, category: "tv")
        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if playerVC != nil{
                playerVC?.stopAnimating()
                playerVC?.stopAnimating1()
                playerVC?.stopAnimatingPlayer(false)
                if playerVC?.playBtn != nil {
                    playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                }
                playerVC?.isNavigatingToBrowser = false
                playerVC?.player.playFromCurrentTime()
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
