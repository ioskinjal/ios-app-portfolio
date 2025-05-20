//
//  BusinessProfileVC.swift
//  ThumbPin
//
//  Created by NCT109 on 03/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

var userIdCustomerBusiness = ""

class BusinessProfileVC: UIViewController {
    
    @IBOutlet weak var btnEditBusinessProfile: UIButton!
    @IBOutlet weak var viewContainerHeight: UIView!
    @IBOutlet weak var labelPaypalEmailValue: UILabel!
    @IBOutlet weak var labelPaypalEmail: UILabel!
    @IBOutlet weak var labelWillingnessTravelValue: UILabel!
    @IBOutlet weak var labelWillingnesstravel: UILabel!
    @IBOutlet weak var labelSubCategoryValue: UILabel!
    @IBOutlet weak var labelSubCategory: UILabel!
    @IBOutlet weak var labelCategoryValue: UILabel!
    
    @IBOutlet weak var stackViewPaypal: UIStackView!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelDescriptionValue: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelNameValue: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocationValue: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    var businessProfile = BusinessProfile()
    var userType = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromProvider{
            stackViewPaypal.isHidden = true
        }
        if UserData.shared.getUser()!.user_type == "2" {
            userIdCustomerBusiness = UserData.shared.getUser()!.user_id
            userType = UserData.shared.getUser()!.user_type
            btnEditBusinessProfile.isHidden = false
        }else {
            userType = "2"
            btnEditBusinessProfile.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isConnectedToInternet {
            print("Yes! internet is available.")
            callApiGetBusinessProfile()
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            self.businessProfile = BusinessProfile(dic: dict["business_profile"] as? [String : Any] ?? [String : Any]())
            self.showBusinessProfileData()
        }
    }
    func callApiGetBusinessProfile() {
        let dictParam = [
            "action": Action.business,
            "lId": UserData.shared.getLanguage,
            "user_type": userType,
            "user_id": userIdCustomerBusiness,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.businessProfile = BusinessProfile(dic: dict["businessprofile"] as? [String : Any] ?? [String : Any]())
            self.showBusinessProfileData()
        }
    }
    func showBusinessProfileData() {
        labelLocationValue.text = businessProfile.business_location
        labelNameValue.text = businessProfile.business_name
        labelDescriptionValue.text = businessProfile.business_desc
        labelCategoryValue.text = businessProfile.category
        labelSubCategoryValue.text = businessProfile.sub_category
        labelWillingnessTravelValue.text = businessProfile.w_travel
        labelPaypalEmailValue.text = businessProfile.business_paypal_email
        view.layoutIfNeeded()
        viewContainerHeight.layoutIfNeeded()
      //  NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":viewContainerHeight.frame.height] as [String:Any])
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":self.viewContainerHeight.frame.height], userInfo: nil)
        }
    }
    func setUpLang() {
        labelLocation.text = localizedString(key: "Business Location")
        labelName.text = localizedString(key: "Business Name")
        labelDescription.text = localizedString(key: "Business Description")
        labelCategory.text = localizedString(key: "Business Category")
        labelSubCategory.text = localizedString(key: "Business Sub Category")
        labelWillingnesstravel.text = localizedString(key: "Willingness to travel")
        labelPaypalEmail.text = localizedString(key: "Paypal Email")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnEditBusinessProfileAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(EditBusinessProfileVC.storyboardInstance!, animated: true)
    }
    

}
