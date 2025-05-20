//
//  GiveReviewVC.swift
//  ThumbPin
//
//  Created by NCT109 on 27/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import Cosmos

class GiveReviewVC: BaseViewController {

    @IBOutlet weak var viewCommunicationRate: CosmosView!
    @IBOutlet weak var viewQualityRate: CosmosView!
    @IBOutlet weak var viewDEliveryRate: CosmosView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labelEnterReview: UILabel!
    @IBOutlet weak var labelSelectRating: UILabel!
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var txtDescription: UITextView!{
        didSet {
            txtDescription.layer.borderColor = Color.Custom.blackColor.cgColor
            txtDescription.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    
    static var storyboardInstance:GiveReviewVC? {
        return StoryBoard.chat.instantiateViewController(withIdentifier: GiveReviewVC.identifier) as? GiveReviewVC
    }
    var providerId = ""
    var serviceID = Int()
    var getReview = GetAllReview()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewRating.rating = 3
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApiGetReviewStatus()
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Ratings & Review")
        //labelSelectRating.text = localizedString(key: "Select Rating")
        labelEnterReview.text = localizedString(key: "Enter Review here")
        btnSubmit.setTitle("  \(localizedString(key: "Submit"))  ", for: .normal)
    }
    
    func callApiGetReviewStatus() {
        let dictParam = [
            "action": Action.checkreviewstatus,
            "lId": "1",
            "reviewer_id": UserData.shared.getUser()!.user_id,
            "provider_id": providerId,
            "service_id": serviceID,
        ] as [String : Any]
        ApiCaller.shared.getReviews(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.getReview = GetAllReview(dic: dict["userData"] as? [String : Any] ?? [String : Any]())
            self.showData()
        }
    }
    func callApiGiveReview() {
        let dictParam = [
            "action": Action.giveRate,
            "lId": "1",
            "reviewer_id": UserData.shared.getUser()!.user_id,
            "provider_id": providerId,
            "service_id": serviceID,
            "score": "",
            "review": txtDescription.text!,
            "delivery_on_time_rating":viewDEliveryRate.rating,
            "material_service_quantity_rating":viewQualityRate.rating,
            "communication_rating":viewCommunicationRate.rating
        ] as [String : Any]
        ApiCaller.shared.getReviews(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showData() {
        let strTemp = localizedString(key: "How would you rate your overall experience with My %@")
        self.labelName.text = NSString(format: "\(strTemp)" as NSString, getReview.name) as String
       // self.labelName.text = "How Would you rate your overall experience with My \(self.getReview.name)"
        if let strUrl = self.getReview.image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            imgvwProfile.sd_setShowActivityIndicatorView(true)
            imgvwProfile.sd_setIndicatorStyle(.gray)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if viewDEliveryRate.rating == 0 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.delivery_rate)
            return
        }
       else if viewQualityRate.rating == 0 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.service_quality)
            return
        }
        else if viewCommunicationRate.rating == 0 {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.communication)
            return
        }
        else if txtDescription.text.isEmpty {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.reviewDescr)
            return
        }
        callApiGiveReview()
    }
}
