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
        return StoryBoard.dealDetail.instantiateViewController(withIdentifier: ReviewPopUpVC.identifier) as? ReviewPopUpVC
    }
    
    var parentVC:DealDetailVC?
    var delegate:SubmitReviews?
    var review:PostedReviewsCls.ReviewList?
    var str_id:String?
    var businessDetail:DealDetailCls!
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
            txtReview.placeholder = "Description"
            txtReview.setBorder(radius: 0.0, color: UIColor.lightGray)
        }
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    //var redeemHistoryData : RedeemHistory?
    var starRating:String?
    
    
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
                callPostReview()
            }
    }
    
    func callPostReview(){
        let param = ["action":"post-review",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "rating":cosmosStarView.rating,
                     "review_description":txtReview.text!,
                     "deal_id":str_id!] as [String : Any]
        
        Modal.shared.postReview(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.dismiss(animated: true, completion: {
                    self.parentVC?.callDealDetail()
                })
                if let delegate = self.delegate{
                    delegate.reviewSubmitted(isSuccess: true)
                }
            })
        }
    }
    
}

//Mark: Custom functions
extension ReviewPopUpVC{
   
    @objc func onClickBlackLayer(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    
        
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtReview.text?.isEmpty)! {
            ErrorMsg = "Please provide review"
        }
        else if starRating ?? "0" < "0" {
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
