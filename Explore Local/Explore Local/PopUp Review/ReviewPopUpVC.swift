//
//  ReviewPopUpVC.swift
//  Talabtech
//
//  Created by NCT 24 on 16/07/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit
import Cosmos


protocol SubmitReviews {
    func reviewSubmitted(isSuccess: Bool)
}

class ReviewPopUpVC: UIViewController {
    
    //MARK: Properties
    static var storyboardInstance:ReviewPopUpVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ReviewPopUpVC.identifier) as? ReviewPopUpVC
    }
    
    var parentVC:PostedReviewsVC?
    var parentVC1:BuisnessDetailVC?
    var delegate:SubmitReviews?
    var review:PostedReviewsCls.ReviewList?
    var bus_id:String?
    var businessDetail:BusinessDetail!
    @IBOutlet weak var blackLayerView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickBlackLayer))
            containerView.addGestureRecognizer(tapGest)
        }
    }
    
    @IBOutlet weak var cosmosStarView: CosmosView!{
        didSet{
            cosmosStarView.didTouchCosmos = didTouchCosmos
            cosmosStarView.didFinishTouchingCosmos = didFinishTouchingCosmos
        }
    }
    
    @IBOutlet weak var txtReview: UITextView!{
        didSet{
            txtReview.placeholder = "Enter Review*"
        }
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    //var redeemHistoryData : RedeemHistory?
    var starRating:String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if review == nil{

        }else{
        cosmosStarView.rating = (review!.average_rating! as NSString).doubleValue
        txtReview.text = review?.review_description
        }
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if isValidated(){
            if review == nil{
                callPostReview()
            }else{
            callEditReview()
            }
        }
    }
    
    func callPostReview(){
        let param = ["action":"post_review",
                     "business_id":bus_id!,
                     "user_id":UserData.shared.getUser()!.user_id,
                     "average_rating":cosmosStarView.rating,
                     "review_description":txtReview.text!] as [String : Any]
        
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
           // let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            //self.alert(title: "", message: str, completion: {
                self.dismiss(animated: true, completion: {
                    self.parentVC1?.callBusinessDetail()
                //if let delegate = self.delegate{
                  //  delegate.reviewSubmitted(isSuccess: true)
                //}
            })
        }
    }
    
}

//Mark: Custom functions
extension ReviewPopUpVC{
   
    @objc func onClickBlackLayer(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    func callEditReview() {
        let param = ["action":"update_review",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "review_id":review!.review_id!,
                     "review_description":txtReview.text!,
                     "star":cosmosStarView.rating] as [String : Any]
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.parentVC?.callPostedReviews()
                self.dismiss(animated: true, completion: nil)
                
                if let delegate = self.delegate{
                    delegate.reviewSubmitted(isSuccess: true)
                }
            })
            
            }
        }
    
    
        
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtReview.text?.isEmpty)! {
            ErrorMsg = "Please provide review"
        }
        else if cosmosStarView.rating == 0.0 {
            ErrorMsg = "Please select rating"
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
}

//Star View functions
extension ReviewPopUpVC{
    
    private func didTouchCosmos(_ rating: Double) {
        print(Float(rating))
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        print(Float(rating))
        starRating = "\(Float(rating))"
    }
    
}
