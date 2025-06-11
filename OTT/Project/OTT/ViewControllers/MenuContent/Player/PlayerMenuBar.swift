//
//  PlayerMenuBar.swift
//  OTT
//
//  Created by Chandra Sekhar on 21/09/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

@objc protocol PlayerBarMenuProtocal {
    @objc optional func playerBarGoToSignUp()
    @objc optional func playerBarGoSignIn()
    @objc optional func playerBarUpdateTableview(height:CGFloat,showHide:Bool)
    @objc optional func playerBarFavbtnClicked()
    @objc optional func playerBarTakeTestButtonClicked(testUrl : String)
}

class PlayerMenuBar: UIView {

    @IBOutlet weak var favouriteBtn: UIButton!
    
    @IBOutlet weak var popupLblHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerInfoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var playerInfoView: UIView!
    
    
    @IBOutlet weak var questionInfoView: UIView!
    @IBOutlet weak var yourQuestionLabel: UILabel!
    @IBOutlet weak var questionInfoViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var takeTestButton : UIButton!
    @IBOutlet weak var takeTestButtonHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var hintInfoView: UIView!
    @IBOutlet weak var hintInfoImageView: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintInfoViewHeightConstraint: NSLayoutConstraint!
    
     

    
    /*player dock*/
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popupHeightconstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var popupLabel: UILabel!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    
    var popUpViewHeight = 109
    var itemDes = ItemDescrition()
    var isFav:Bool = false
    var showFav:Bool = false
    var showLoginView:Bool = false
    var showhide:Bool = false
    var playerBarMenuDelegate: PlayerBarMenuProtocal!
    var testURL:String = ""
    var showTestButton:Bool = false
    var enableTestButton:Bool = false
    var enableTakeTestTimer: Timer? = nil
    var testStartTime:Int64 = -1
    var showQuestionsInfo:Bool = false
    
    struct ItemDescrition {
        
        var description : String{
            set{
                localAnswer = newValue
                
                let constraintRect = CGSize(width: UIScreen.main.bounds.size.width - 30, height: CGFloat.greatestFiniteMagnitude)
                let boundingBox = localAnswer.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil) 
                descriptionHeight = boundingBox.height + 20
            }
            get{
                return localAnswer
            }
        }
        
        var descriptionHeight : CGFloat = 0
        var localAnswer = ""
    }

    func handleTestButton() {
        if self.enableTakeTestTimer != nil{
            self.enableTakeTestTimer?.invalidate()
            self.enableTakeTestTimer = nil
        }
        self.takeTestButton.isHidden = true
        self.takeTestButtonHeightConstraint.constant = 0
        
    }
    func handleQuestionInfo() {
        if showQuestionsInfo == true {
            self.questionInfoViewHeightConstraint.constant = 100
            self.hintInfoViewHeightConstraint.constant = 50
            self.hintInfoView.isHidden = false
            self.yourQuestionLabel.isHidden = false
        }
        else {
            self.questionInfoViewHeightConstraint.constant = 50
            self.hintInfoViewHeightConstraint.constant = 0
            self.hintInfoView.isHidden = true
            self.yourQuestionLabel.isHidden = true
        }
    }
    @objc func updateTestTimer(){
        if self.testStartTime != -1 {
            var timeDiffInSec = (self.testStartTime - Date().toMillis()) / 1000
            if timeDiffInSec <= 0{
                timeDiffInSec = 0
                if self.enableTakeTestTimer != nil{
                    self.enableTakeTestTimer?.invalidate()
                    self.enableTakeTestTimer = nil
                }
            }
            else{
                let timeStr = secondsToHoursMinutesSeconds(seconds: Int(timeDiffInSec))
                self.takeTestButton.setTitle("  Test will be enabled in \(timeStr)  ", for: .normal)
            }
        }
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        if hours > 0 {
            return String(format:"%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format:"%02d:%02d", minutes, seconds)
        }
    }
    func setupViews()  {
//        self.takeTestButton.isHidden = true
//        self.takeTestButtonHeightConstraint.constant = 0
        self.playerInfoView.isHidden = true
        self.popupLabel.numberOfLines = 0
        
        self.yourQuestionLabel.text = "Your Question"
        self.yourQuestionLabel.font = UIFont.ottSemiBoldFont(withSize: 14)
        self.yourQuestionLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        
        self.hintLabel.text = "All your questions will be addressed shortly"
        self.hintLabel.font = UIFont.ottMediumFont(withSize: 12)
        self.hintLabel.textColor = AppTheme.instance.currentTheme.hintInfoLabelColor
        
        self.hintInfoViewHeightConstraint.constant = 0
        self.hintInfoView.isHidden = true
        self.yourQuestionLabel.isHidden = true

        //        self.playerInfoViewHeightConstraint.constant = 0
        if self.showLoginView {
            self.popupView.isHidden = false
        }
        else {
            self.popupView.isHidden = true
        }
        self.setUpCommonly()
       /* let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showHideClicked))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)*/

    }
    
    func setUpCommonly() {
        if self.enableTakeTestTimer != nil{
            self.enableTakeTestTimer?.invalidate()
            self.enableTakeTestTimer = nil
        }
        self.signUpBtn.setTitle("Register".localized, for: .normal)
        self.signInBtn.setTitle("Sign-in".localized, for: .normal)
        
        
        let showFavouriteBtn = self.showFav
        if showFavouriteBtn {
            self.favouriteBtn.isHidden = false
            if self.isFav {
                self.favouriteBtn.setImage(#imageLiteral(resourceName: "fav_selected"), for: UIControl.State.normal)
            }
            else {
                self.favouriteBtn.setImage(#imageLiteral(resourceName: "fav_deselected"), for: UIControl.State.normal)
            }
        }
        else {
            self.favouriteBtn.isHidden = true
        }
        
        if self.showTestButton {
            self.handleTestButton()
        }
        if self.showQuestionsInfo {
            self.handleQuestionInfo()
        }
        
    }

    // MARK: - get Attributed Text from Desc
    func getAttributedText(timeString:String,desc:String) ->  NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        //            paragraphStyle.paragraphSpacing = 0.5;
        paragraphStyle.alignment = NSTextAlignment.left
        
        //Title
        var tempDesc = desc
        var tempTimeString = timeString
        if tempTimeString.count > 0{
            if timeString == desc {
                tempTimeString = ""
            }
            let titleAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):
                UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                  convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0),convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle) : paragraphStyle]
            let titleAttributedString = NSMutableAttributedString(
                string: " " + desc,
                attributes: convertToOptionalNSAttributedStringKeyDictionary(titleAttribute))
            let totalDescStr = NSMutableAttributedString(
                string: tempTimeString + "  ",
                attributes: convertToOptionalNSAttributedStringKeyDictionary(titleAttribute))
            let textAttachment = NSTextAttachment.init()
            textAttachment.image = #imageLiteral(resourceName: "details_clock_icon")
            textAttachment.bounds = CGRect.init(x: 0, y: 0, width: 12, height: 12)
            let attachment = NSAttributedString.init(attachment: textAttachment)
            attributedString.append(totalDescStr)
            attributedString.append(attachment)
            attributedString.append(titleAttributedString)
            attributedString.append(NSAttributedString.init(string: "\n"))
            tempDesc = ""
        }
        
        //desc
        
        
        if tempDesc.count > 0{
            let contentAttribute = [kCTFontAttributeName:
                UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular),
                                    kCTForegroundColorAttributeName: UIColor.init(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0),convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle) : paragraphStyle] as [AnyHashable : NSObject]
            let contentAttributedString = NSMutableAttributedString(
                string: " " + tempDesc,
                attributes: convertToOptionalNSAttributedStringKeyDictionary(contentAttribute as! [String : Any]))
            let textAttachment = NSTextAttachment.init()
            textAttachment.image = #imageLiteral(resourceName: "info_icon")
            textAttachment.bounds = CGRect.init(x: 0, y: -1.5, width: 12, height: 12)
            let attachment = NSAttributedString.init(attachment: textAttachment)
            attributedString.append(NSAttributedString.init(string: " "))
            attributedString.append(attachment)
            attributedString.append(contentAttributedString)
            attributedString.append(NSAttributedString.init(string: "\n"))
        }
        
        return attributedString
        
    }
    // MARK: - loading suggestion specific View
    func loadPlayerItemDetails(playItemObj:PageContentResponse) {
        self.testURL = playItemObj.info.attributes.takeaTestURL.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        self.testStartTime = -1
        let attributes = playItemObj.info.attributes
        if (attributes.contentType == "epg") && (attributes.isLive == true){
           self.testStartTime = Int64(truncating: attributes.takeaTestStartTime)
        }
        infoBtn.isHidden = true
        self.popUpViewHeightConstraint.constant = 60
        for pageData in playItemObj.data {
            if pageData.paneType == .content {
                let content = pageData.paneData as? Content
                self.iconImageView.loadingImageFromUrl(content?.posterImage ?? "", category: "tv")
                self.programLabel.text = content?.title
                //                var row = 1
                channelNameLabel.isHidden = false
                self.channelNameLabel.text = ""
                for dataRow in (content?.dataRows)! {
                    if dataRow.rowNumber == 1{
                        self.iconWidthConstraint.constant = 0
                        for element in dataRow.elements {
                            if element.elementType == .image {
                                self.iconImageView.loadingImageFromUrl(element.data, category: "tv")
                                self.iconWidthConstraint.constant = 43
                            }
                            else if element.elementType == .text {
                                self.programLabel.text = element.data
                            }
                        }
                    }
                    else if dataRow.rowNumber == 2{
                        for element in dataRow.elements {
                            if element.elementType == .text {
                                self.channelNameLabel.text = self.channelNameLabel.text! + element.data + " "
                            }
                        }
                    }
                    else if dataRow.rowNumber == 7{
                        for element in dataRow.elements {
                            if element.elementType == .text {
                                self.popupLabel.attributedText = getAttributedText(timeString: "", desc: element.data)
                                infoBtn.isHidden = true
                                self.popupLabel.sizeToFit()
                            }
                            else if element.elementType == .marker && element.elementSubtype == "duration" {
                                self.channelNameLabel.text = self.channelNameLabel.text!
                                let timeStr = self.channelNameLabel.text!
                                if timeStr .isEmpty {
                                    self.channelNameLabel.attributedText = getAttributedText(timeString: element.data, desc: element.data)
                                }
                                else {
                                    self.channelNameLabel.attributedText = getAttributedText(timeString: timeStr, desc: element.data)
                                }
                                self.channelNameLabel.textColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
                            }
                        }
                    }
                    else{
                        for element in dataRow.elements {
                            if element.elementType == .description {
                                itemDes.description = element.data
                                self.descLabel.text = element.data
                            }
                                
                            else if element.elementType == .marker && element.elementSubtype == "duration" {
                                self.channelNameLabel.text = self.channelNameLabel.text!
                                self.channelNameLabel.attributedText = getAttributedText(timeString: self.channelNameLabel.text!, desc: element.data)
                                self.channelNameLabel.textColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
                            }
                        }
                    }
                }
                break
            }
        }
        if (self.popupLabel.text? .isEmpty)! {
            self.popUpViewHeight = 60
            self.popupLblHeightConstraint.constant = 0
            self.playerInfoViewHeightConstraint.constant = 234
        }
        else {
            self.popUpViewHeight = 109
            self.popupLblHeightConstraint.constant = 50.5
            self.playerInfoViewHeightConstraint.constant = 283
        }
        self.popUpViewHeightConstraint.constant = CGFloat(self.popUpViewHeight)
    }
    func setupPlayerItemView(obj:PageContentResponse)
    {
        loadPlayerItemDetails(playItemObj:obj)
        showHideButton.addTarget(self, action: #selector(PlayerMenuBar.showHideClicked), for: UIControl.Event.touchUpInside)
        
        self.playerInfoView.isHidden = false
        if showhide == false {
            self.descLabel.isHidden = true
            self.descLabelHeightConstraint.constant = 0
            //            UIView.animate(withDuration:0.1, animations: {
            self.showHideButton.transform = CGAffineTransform(rotationAngle: 0)
            //            })
            //            self.descLabel.backgroundColor = UIColor.green
        }else{
            //            UIView.animate(withDuration:0.1, animations: {
            self.showHideButton.transform = CGAffineTransform(rotationAngle: .pi)
            //            })
            self.descLabelHeightConstraint.constant = itemDes.descriptionHeight + 5
            self.descLabel.isHidden = false
            //            self.descLabel.backgroundColor = UIColor.red
        }
        //        self.playerInfoViewHeightConstraint.constant = 113
        self.popUpViewHeightConstraint.constant = CGFloat(self.popUpViewHeight)
        self.setUpCommonly()
        
    }
    // MARK: - showHide button action Clicked
    @objc func showHideClicked() {
        Log(message: "showHideClicked")
        var viewHeight:CGFloat = 0
        
        if showhide == false {
            if !self.showLoginView {
                if self.descLabel.text! .isEmpty {
                    viewHeight = (135 - 60)
                } else {
                    viewHeight = (135 - 60) + (itemDes.descriptionHeight + 5)
                }
                Log(message: "\(viewHeight)")
                showhide = true
            }
            else {
                if self.descLabel.text! .isEmpty {
                    viewHeight = (135 - 47)
                } else {
                    viewHeight = (135 - 47) + (itemDes.descriptionHeight + 5) + CGFloat(self.popUpViewHeight)
                }

                Log(message: "\(viewHeight)")
                showhide = true
            }
        }else{
            if !self.showLoginView {
                viewHeight = (135 - 60)
                showhide = false
            }
            else {
                viewHeight = CGFloat((135 - 47) + self.popUpViewHeight)
                showhide = false
            }
        }
        self.playerBarMenuDelegate.playerBarUpdateTableview!(height:viewHeight,showHide:showhide)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        self.playerBarMenuDelegate.playerBarGoToSignUp!()
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        self.playerBarMenuDelegate.playerBarGoSignIn!()
    }
    
    
    @IBAction func favouriteBtnClicked(_ sender: Any) {
        self.playerBarMenuDelegate.playerBarFavbtnClicked!()
    }
    @IBAction func TakeTestButtonClicked(_ sender: Any) {
        self.playerBarMenuDelegate.playerBarTakeTestButtonClicked!(testUrl: self.testURL)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
