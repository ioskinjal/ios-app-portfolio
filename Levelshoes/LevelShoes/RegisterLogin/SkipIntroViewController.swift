//
//  SkipIntroViewController.swift
//  LevelShoes
//
//  Created by apple on 4/23/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import CoreData
import MBProgressHUD

var isCountryCodeChanged = true
   var isLanguageCodeChanged = true
class SkipIntroViewController: UIViewController {
    private var animationSpeed = 0.75
    @IBOutlet weak var logoImageViewCenterY: NSLayoutConstraint!
    static var storyboardInstance:SkipIntroViewController? {
        return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: SkipIntroViewController.identifier) as? SkipIntroViewController
        
    }
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData() ?? [:], valueOf: .data).dic)
    @IBOutlet weak var videoView: PlayerView!
    @IBOutlet weak var logoImageView: UIImageView!{
        didSet{
            self.logoImageView.center.y  = self.logoImageView.center.y + 40
        }
    }
    @IBOutlet weak var standardConstraint:NSLayoutConstraint!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var blackColor: UIView! {
        didSet{
             self.blackColor!.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
    
   
    var player: AVPlayer?
    var backgroundViewBlack = UIView()
    var chooceCountryView = Bundle.main.loadNibNamed("ChooseCountry", owner: self, options: nil)?.first as! ChooseCountry
    var categorySelectionView = Bundle.main.loadNibNamed("CategorySelections", owner: self, options: nil)?.first as! CategorySelections
    var selectionViewTop = Bundle.main.loadNibNamed("SeclectionViewTop", owner: self, options: nil)?.first as! SeclectionViewTop
   
    var sharedManger =  CoreDataManager.sharedManager
   
    
    //MARK:- ViewDid Load
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: string.category) == nil && UserDefaults.standard.value(forKey: string.storecode) != nil{
            skipBtn.isHidden = true
            setupCategory()
            createRegistrationContniue()
        }else{
        let myColor : UIColor = UIColor.white
        skipBtn.layer.borderWidth = 1.0
        skipBtn.layer.cornerRadius = 2.0
        skipBtn.layer.borderColor = myColor.cgColor
        skipBtn.isUserInteractionEnabled = true
        skipBtn.isHidden = false
        /*
         Modified by Nitikesh. Added Alphacomponent for opacity and changed background color
         */
        skipBtn.setBackgroundColor(color: UIColor(hexString: "E0E0E0").withAlphaComponent(0.5), forState: .highlighted)
        let attributedTitle = NSAttributedString(string: "SKIP INTRO".localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        skipBtn.setAttributedTitle(attributedTitle, for: .normal)
        videoView.isHidden = true
        imageView.isHidden = true
        setupViews()

        }
        setData()
        
    }
    
    
   
    
    func setupViews() {
        self.chooceCountryView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 335 , width: UIScreen.main.bounds.width, height:335 )
        backgroundViewBlack.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height  )
        self.categorySelectionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 260, width: UIScreen.main.bounds.width, height: 260)
        chooceCountryView.btnContinue.isUserInteractionEnabled = false
        chooceCountryView.toggle.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chooceCountryView.toggle.setOn(true)
        updateNotificationLabelColor()
        chooceCountryView.selectCurrentCountryIfPossible()
    }
    
    func setupCategory() {
        self.categorySelectionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 260, width: UIScreen.main.bounds.width, height: 260)
    }
    func setData()  {
        for i in 0 ..< (data._source?.introList.count)!
        {
            if data._source?.introList[i].status == "active" {
                if data._source?.introList[i].type == "video"  {
                    videoView.isHidden = false
                    imageView.isHidden = true
                    self.player = AVPlayer(url: URL(string:(data._source?.introList[i].url)!)!)
                    self.player?.actionAtItemEnd = .none
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(playerDidFinishPlaying(note:)),
                                                           name: .AVPlayerItemDidPlayToEndTime,
                                                           object: self.player?.currentItem)
                                        
                    self.videoView?.playerLayer.player = player
                    self.videoView.playerLayer.videoGravity = .resize
                    self.videoView.player?.play()
                    logoImageView.sd_setImage(with: URL(string:(data._source?.introList[i].url)!), placeholderImage: UIImage(named: "logo_white"))
                }
                else
                {
                    videoView.isHidden = true
                    imageView.isHidden = false
                    imageView.sd_setImage(with:URL(string:(data._source?.introList[i].url)!), placeholderImage: UIImage(named: "levelShoesBackgroud"))
                    logoImageView.sd_setImage(with: URL(string:(data._source?.introList[i].logoUrl)!), placeholderImage: UIImage(named: "logo_white"))
                }
            }
        }
    }
    
   //MARK:- Skip Button
    
    @IBAction func onCLickSkip(_ sender: Any) {
        skipBtn.isUserInteractionEnabled = false
        
        self.videoView.player?.isMuted = true
        skipBtn.alpha = 1
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: {
                        self.skipBtn.alpha = 0
        }, completion: { _ in
            self.skipBtn.isHidden = true
            proceed()
            
           
        })
        
        func proceed() {
            chooceCountryView.transform = CGAffineTransform(translationX: 0, y: 445)
            self.chooceCountryView.btnContinue.addTarget(self, action: #selector(self.createRegistrationContniue), for: .touchUpInside)
//            self.chooceCountryView._btnNotification.addTarget(self, action: #selector(createRegistrationNotification(_:)), for: .touchUpInside)
            self.chooceCountryView._txtCountryName.addTarget(self, action: #selector(self.createCountryName), for: .touchUpInside)
            
            animateViewUp()
        }
        
    }
    
    //MARK:- Animated View
    func animateViewUp() {
        let diff = self.logoImageView.frame.maxY - (self.view.frame.height - self.chooceCountryView.frame.height)
        let isCountryPickerOverlapLogo = diff > 0
        if isCountryPickerOverlapLogo {
            self.logoImageViewCenterY.constant = -diff-70
        }
        UIView.animate(withDuration: animationSpeed, delay: 1, options: [.curveEaseInOut], animations: {
            self.blackColor!.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.chooceCountryView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }, completion:nil)
        self.view.addSubview(chooceCountryView)
    }
    
    
    func animateViewDown(completion:(() -> Void)?) {
        self.logoImageViewCenterY.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.blackColor!.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.chooceCountryView.frame.origin.y = self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.chooceCountryView.removeFromSuperview()
                completion?()
        })
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if let playerItem = note.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
            if skipBtn.isHidden == false {
                self.onCLickSkip(skipBtn)
            }
        }
    }
    //MARK: Slide View - Top To Bottom
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    
    //MARK:- Button Continue
    @objc func createRegistrationContniue() {
        
        
        animateViewDown {
             DispatchQueue.main.async {
                           proceed()
                        }
                        ApiManager.cacheAllCategories()
        }
        //UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
        //UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        //UserDefaults.standard.setValue(selectedCurrency, forKey: "currency")
        
        //Temporary Solution by Nitikesh. As there is no access for ES data change directly in the onboarding config.
        if((UserDefaults.standard.string(forKey: "currency")) == "KDE"){
            UserDefaults.standard.setValue("KWD", forKey: "currency")
        }
        UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flag")
        chooceCountryView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        
        func proceed() {
            selectionViewTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160)
            view.addSubview(selectionViewTop)
            logoImageView.layoutIfNeeded()
            let defaults = UserDefaults.standard

            if let countryFlag = defaults.string(forKey: "countryFlags") {
                let url = URL(string: countryFlag)
                selectionViewTop.imgFlag.sd_setImage(with: url, placeholderImage: nil)
            } else {
                if let strcountryFlag = selectedCountryFlag{
                    selectionViewTop.imgFlag.sd_setImage(with: URL(string: strcountryFlag), placeholderImage: nil)
                }
                //selectionViewTop.imgFlag.sd_setImage(with: URL(string: selectedCountryFlag!), placeholderImage: nil)
            }
            _ = defaults.value(forKey: "country")
            if let countryName = defaults.value(forKey: "countryName") as? String, var userLanguage = defaults.value(forKey: "userlanguage") as? String, countryName != "" {
                if(userLanguage == "Arabic") { userLanguage = "عربى" }
                let text = countryName + " | " + String(describing: userLanguage)
                
                selectionViewTop._lblContryName.text = text
            } else {
                selectionViewTop._lblContryName.text = selectedCountry
            }
            
            selectionViewTop.layoutIfNeeded()
            
            //UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
            //UserDefaults.standard.setValue(selectedCountry, forKey: "country")
            //UserDefaults.standard.setValue(selectedCurrency, forKey: "currency")
            //UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
            
            animateShowSelectionTopAndGenderSelector()
            chooceCountryView.isHidden = true
            self.view.addSubview(self.categorySelectionView)
            
            self.categorySelectionView._btnMen.addTarget(self, action: #selector(goToHomeMen), for: .touchUpInside)
            self.categorySelectionView._btnWomen.addTarget(self, action: #selector(goToHomeWomen), for: .touchUpInside)
            self.categorySelectionView._btnKids.addTarget(self, action: #selector(goToHomeKids), for: .touchUpInside)

           
        }
        
       
        
    }
    
    @IBAction func animateShowSelectionTopAndGenderSelector() {
        selectionViewTop.alpha = 0
        UIView.animate(withDuration: animationSpeed, delay: 0, options: [.curveEaseInOut], animations: {
            self.selectionViewTop.alpha = 1
            self.selectionViewTop.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160)
        }, completion: nil)

        self.categorySelectionView._btnWomen.alpha = 0
        self.categorySelectionView._btnMen.alpha = 0
        self.categorySelectionView._btnKids.alpha = 0
        let speed = animationSpeed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            self.categorySelectionView._btnWomen.animShowBuuton(duration: speed)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                self.categorySelectionView._btnMen.animShowBuuton(duration: speed)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                    self.categorySelectionView._btnKids.animShowBuuton(duration: speed)
                }
            }
        }
    }
    
    //MARK:- GoToHome
    @objc func goToHomeMen(){
        UserDefaults.standard.setValue(CommonUsed.globalUsed.genderMen, forKey: "category")
        goToHome()
    }
    
    @objc func goToHomeWomen(){
    UserDefaults.standard.setValue(CommonUsed.globalUsed.genderWomen, forKey: "category")
        goToHome()

    }
    @objc func goToHomeKids(){
        UserDefaults.standard.setValue(CommonUsed.globalUsed.genderKids, forKey: "category")
        goToHome()

    }
     func goToHome(){
         self.videoView.player?.isMuted = true
        self.videoView.player?.pause()
         UserDefaults.standard.setValue(true, forKey: "globalSearchBool")
        globalSearchBool = true
        if((UserDefaults.standard.string(forKey: "storecode") == "" || UserDefaults.standard.string(forKey: "storecode") == nil) && selectedStoreCode != ""){
                    UserDefaults.standard.setValue(selectedStoreCode, forKey: "storecode")
        }
        if((UserDefaults.standard.string(forKey: "country") == "" || UserDefaults.standard.string(forKey: "country") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        }
        if((UserDefaults.standard.string(forKey: "currency") == "" || UserDefaults.standard.string(forKey: "currency") == nil) && selectedCurrency != ""){
            UserDefaults.standard.setValue(selectedCurrency.localized, forKey: "currency")
        }
        if((UserDefaults.standard.string(forKey: "countryName") == "" || UserDefaults.standard.string(forKey: "countryName") == nil) && selectedCountry != ""){
            UserDefaults.standard.setValue(selectedCountry, forKey: "countryName")
        }
        if((UserDefaults.standard.string(forKey: "flagurl") == "" || UserDefaults.standard.string(forKey: "flagurl") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "flagurl")
        }
        if((UserDefaults.standard.string(forKey: "countryFlag") == "" || UserDefaults.standard.string(forKey: "countryFlag") == nil) && selectedCountryFlag != ""){
            UserDefaults.standard.setValue(selectedCountryFlag, forKey: "countryFlag")
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)

         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
            nextViewController.selectedIndex = 0
               
                                    // nextViewController.tabBar.isHidden = true
                               
               self.navigationController?.pushViewController(nextViewController, animated: true)
               sharedAppdelegate.window?.rootViewController = self.navigationController
                                        sharedAppdelegate.window?.makeKeyAndVisible()
    }
    //MARK:- Country Name
    @objc func createCountryName(){
      
    }
    
    func updateNotificationLabelColor() {
        
        if chooceCountryView.toggle.isOn {
            chooceCountryView._lblNotification.textColor = .black
            UserDefaults.standard.set(true, forKey: "prefNotification")
        } else {
            chooceCountryView._lblNotification.textColor = UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
            UserDefaults.standard.set(false, forKey: "prefNotification")
        }
    }
}

extension SkipIntroViewController: ToggleDelegate {
    func toggleChanged(_ toggle: Toggle) {
        updateNotificationLabelColor()
    }
}
