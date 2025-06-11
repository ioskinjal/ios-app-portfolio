//
//  StartWatchParty.swift
//  OTT
//
//  Created by Srikanth on 6/18/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import Foundation
protocol StartWatchPartyViewProtocol {
    func StartThePartySelected()
    func watchPartyCloseButtonSelected()
}

class StartWatchParty: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var watchPartyImage : UIImageView?
    @IBOutlet weak var watchPartyLabel : UILabel?
    @IBOutlet weak var programNameLabel : UILabel?
    @IBOutlet weak var shareWithFriendsLabel : UILabel?
    @IBOutlet weak var copyBgView : UIView?
    @IBOutlet weak var copyLabel : UILabel?
    @IBOutlet weak var copyProgramButton : UIButton?
    @IBOutlet weak var seperatorLabel : UILabel?
    @IBOutlet weak var hostLabel : UILabel?
    @IBOutlet weak var startPartyButton : UIButton?
    
    
    var contentData : PageContentResponse?
    var changePartyButtonText : Bool = false
    var delegate:StartWatchPartyViewProtocol! = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if productType.iPad {
            self.view.frame.size.width = 450
            self.view.frame.size.height = 450
        }
        else {
            self.view.frame.size.width = (AppDelegate.getDelegate().window?.frame.size.width)! - 40
            self.view.frame.size.height = 450
        }
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        self.view.viewCornerDesignWithBorder(AppTheme.instance.currentTheme.rateNowViewBgColor)
        
        self.watchPartyLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.watchPartyLabel?.font = UIFont.ottRegularFont(withSize: 14)
        self.watchPartyLabel?.text = "Watch Party"
        
        self.programNameLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.programNameLabel?.font = UIFont.ottRegularFont(withSize: 18)
        
        if let pageResponceData = self.contentData {
            for pageData in pageResponceData.data {
                if pageData.paneType == .content {
                    let content = pageData.paneData as? Content
                    self.programNameLabel?.text = content?.title
                }
            }
        }
        
        self.shareWithFriendsLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.shareWithFriendsLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.shareWithFriendsLabel?.text = "Copy and share the link below with friends to watch this movie"
        self.shareWithFriendsLabel?.numberOfLines = 0
        
        self.copyBgView?.backgroundColor = AppTheme.instance.currentTheme.rateNowViewBgColor
        self.copyBgView?.viewCornerDesignWithBorder(AppTheme.instance.currentTheme.rateNowViewBgColor)
        
        
        self.copyLabel?.backgroundColor = .clear
        self.copyLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.copyLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.copyLabel?.text = "https://zpl.io/bAJPWQO"
        #warning("hard coded value for POC")
        
        self.copyProgramButton?.setTitle("Copy", for: .normal)
        self.copyProgramButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.copyProgramButton?.setImage(UIImage.init(named: "img_copy"), for: .normal)
        self.copyProgramButton?.backgroundColor = AppTheme.instance.currentTheme.rateNowButtonBgColor
        self.copyProgramButton?.buttonCornerDesignWithBorder(AppTheme.instance.currentTheme.rateNowButtonBgColor)
        
        self.seperatorLabel?.backgroundColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        self.hostLabel?.text = "You’re the host! Once everyone’s joined,start the party to watch together."
        self.hostLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.hostLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.hostLabel?.numberOfLines = 0
        
        
        self.startPartyButton?.titleLabel?.font =  UIFont.ottRegularFont(withSize: 13)
        if self.changePartyButtonText == true {
           // self.startPartyButton?.setImage(UIImage.init(named: ""), for: .normal)
            self.startPartyButton?.setTitle("OK", for: .normal)
        }
        else {
            self.startPartyButton?.setImage(UIImage.init(named: "img_play_circle"), for: .normal)
            self.startPartyButton?.setTitle("Start the Party", for: .normal)
        }
        self.startPartyButton?.setTintColor(AppTheme.instance.currentTheme.cardTitleColor, recursive: false)
        self.startPartyButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.startPartyButton?.backgroundColor = AppTheme.instance.currentTheme.themeColor
    }
    @IBAction func CloseButtonClicked(_ sender: Any) {
        self.delegate.watchPartyCloseButtonSelected()
    }
    @IBAction func StartPartyButtonClicked(_ sender: Any) {
        self.delegate.StartThePartySelected()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
