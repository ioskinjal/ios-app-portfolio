//
//  StartWatchPartyConfirmation.swift
//  OTT
//
//  Created by Srikanth on 6/23/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import Foundation

protocol StartWatchPartyConfirmationViewProtocol {
    func StartThePartyConfirmSelected()
    func MaybeLaterButtonSelected()
}

class StartWatchPartyConfirmationView: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var watchPartyImage : UIImageView?
    @IBOutlet weak var watchPartyLabel : UILabel?
    @IBOutlet weak var programNameLabel : UILabel?
    @IBOutlet weak var seperatorLabel : UILabel?
    @IBOutlet weak var ageConfirmationText : UILabel?
    @IBOutlet weak var startPartyButton : UIButton?
    @IBOutlet weak var maybeLaterButton : UIButton?
    
    
    var contentData : PageContentResponse?
    var delegate:StartWatchPartyConfirmationViewProtocol! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if productType.iPad {
            self.view.frame.size.width = 450
            self.view.frame.size.height = 400
        }
        else {
            self.view.frame.size.width = (AppDelegate.getDelegate().window?.frame.size.width)! - 40
            self.view.frame.size.height = 370
            
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
        
        
        
        self.seperatorLabel?.backgroundColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.seperatorLabel?.alpha = 0.5
        
        self.ageConfirmationText?.text = "You must be 18 years or older to participate in a Watch Party,  By selecting ‘Start The Party’, you agree to Watch Party Guidelines."
        self.ageConfirmationText?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.ageConfirmationText?.font = UIFont.ottRegularFont(withSize: 12)
        self.ageConfirmationText?.numberOfLines = 0
        
        
        self.startPartyButton?.titleLabel?.font =  UIFont.ottRegularFont(withSize: 13)
        //self.startPartyButton?.setImage(UIImage.init(named: "img_play_circle"), for: .normal)
        self.startPartyButton?.setTitle("Start the Party", for: .normal)
        self.startPartyButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.startPartyButton?.backgroundColor = AppTheme.instance.currentTheme.themeColor
        
        
        self.maybeLaterButton?.titleLabel?.font =  UIFont.ottRegularFont(withSize: 13)
        self.maybeLaterButton?.setTitle("May be Later", for: .normal)
        self.maybeLaterButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.maybeLaterButton?.backgroundColor = AppTheme.instance.currentTheme.rateNowButtonBgColor
    }
    @IBAction func CloseButtonClicked(_ sender: Any) {
        self.delegate.MaybeLaterButtonSelected()
    }
    @IBAction func MayBeLaterButtonClicked(_ sender: Any) {
        self.delegate.MaybeLaterButtonSelected()
    }
    @IBAction func StartPartyButtonClicked(_ sender: Any) {
        self.delegate.StartThePartyConfirmSelected()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
