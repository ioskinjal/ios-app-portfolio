//
//  UserRatingView.swift
//  OTT
//
//  Created by Srikanth on 6/5/20.
//  Copyright © 2020 Srikanth. All rights reserved.
//

import UIKit
import Cosmos

protocol UserRatingViewProtocol {
    func updateUserRating(rating:Double)
    func closeButtonSelected()
}

class UserRatingView: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    var contentData : PageContentResponse?
    
    @IBOutlet weak var programInfoLabel : UILabel?
    @IBOutlet weak var programNameLabel : UILabel?
    @IBOutlet weak var programRatingInfoLabel : UILabel?
    @IBOutlet weak var programRatingView : CosmosView?
    @IBOutlet weak var helpOthersLabel : UILabel?
    @IBOutlet weak var ratingImageView : UIImageView?
    @IBOutlet weak var submitRatingButton : UIButton?
    
    var delegate:UserRatingViewProtocol! = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size.width = (AppDelegate.getDelegate().window?.frame.size.width)!
        self.view.frame.size.height = (AppDelegate.getDelegate().window?.frame.size.height)!
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
         
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        self.programInfoLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.programInfoLabel?.font = UIFont.ottRegularFont(withSize: 14)
        
        self.programNameLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.programNameLabel?.font = UIFont.ottRegularFont(withSize: 22)
        
        self.programRatingInfoLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        self.programRatingInfoLabel?.font = UIFont.ottRegularFont(withSize: 14)
        
        self.programRatingView?.didTouchCosmos = didTouchCosmos
        self.programRatingView?.didFinishTouchingCosmos = didFinishTouchingCosmos
        
         
        self.helpOthersLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.helpOthersLabel?.font = UIFont.ottRegularFont(withSize: 11)
         
        self.submitRatingButton?.titleLabel?.font =  UIFont.ottRegularFont(withSize: 13)
        self.submitRatingButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.submitRatingButton?.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.submitRatingButton?.isUserInteractionEnabled = false
        self.submitRatingButton?.alpha = 0.5
       
        if let pageResponceData = self.contentData {
            let ratingInfoText = "How would you rate the "
            let programInfoText = "How was the "
            if pageResponceData.info.attributes.contentType == "tvshowepisode" || pageResponceData.info.attributes.contentType == "tvshow" {
                self.programRatingInfoLabel?.text = ratingInfoText + "TV Show ?"
                self.programInfoLabel?.text = programInfoText + "TV Show ?"
            }
            else if pageResponceData.info.attributes.contentType == "movie" {
                self.programRatingInfoLabel?.text = ratingInfoText + "Movie ?"
                self.programInfoLabel?.text = programInfoText + "Movie ?"
            }
            if ((pageResponceData.pageButtons.feedback?.userFeedbackRecord) != nil) {
                let tempVal = pageResponceData.pageButtons.feedback?.userFeedbackRecord?.rating ?? 0
                self.programRatingView?.rating = Double(tempVal)
            }
            else{
                self.programRatingView?.rating = 0.0
            }
            for pageData in pageResponceData.data {
                if pageData.paneType == .content {
                    let content = pageData.paneData as? Content
                    self.programNameLabel?.text = content?.title
                    
                    /*for dataRow in (content?.dataRows)! {
                        
                        for element in dataRow.elements {
                            if element.elementSubtype == "title" {
                                
                            }
                        }
                    }*/
                    break
                }
            }
        }
        
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    func formatValue(_ value: Double) -> String {
      return String(format: "%.0f", value)
    }
    
    private func didTouchCosmos(_ rating: Double) {
        self.submitRatingButton?.isUserInteractionEnabled = true
        self.submitRatingButton?.alpha = 1.0
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.submitRatingButton?.isUserInteractionEnabled = true
        self.submitRatingButton?.alpha = 1.0
    }
    
    @IBAction func SubmitRatingButtonClicked(_ sender: Any) {
        Log(message: "self.programRatingView?.rating : \(String(describing: self.programRatingView?.rating))")

        self.startAnimating(allowInteraction: false)
        let ratingString = self.formatValue(self.programRatingView?.rating ?? 0.0)
        OTTSdk.mediaCatalogManager.contentFeedback(path: self.contentData?.info.path ?? "", rating: ratingString, description: "", onSuccess: { (response) in
            self.stopAnimating()
            self.showAlertWithText("Thank you for your feedback", message: "Sharing your experience with us is extremely helpful.")
        }) { (error) in
            self.stopAnimating()
        }
    }
    
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        
        let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
        
        let okButtonAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.delegate.updateUserRating(rating: self.programRatingView?.rating ?? 0.0)
        }
        alertController.addAction(okButtonAction)
        
        self.present(alertController, animated: true) {
        }
    }
    @IBAction func CloseButtonClicked(_ sender: Any) {
        self.delegate.closeButtonSelected()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
