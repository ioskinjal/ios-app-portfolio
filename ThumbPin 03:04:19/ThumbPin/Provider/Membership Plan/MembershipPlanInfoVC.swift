//
//  MembershipPlanInfoVC.swift
//  ThumbPin
//
//  Created by NCT109 on 12/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class MembershipPlanInfoVC: BaseViewController,UITextViewDelegate {
    
    @IBOutlet weak var lblDurationHead: UILabel!
    @IBOutlet weak var lblMsgHead: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblMessagess: UILabel!
    @IBOutlet weak var labelRedeemCredit: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtDescription: UITextView!{
        didSet {
            txtDescription.layer.borderWidth = 1
            txtDescription.layer.borderColor = Color.Custom.darkGrayColor.cgColor
        }
    }
    @IBOutlet weak var txtPaypalEmail: CustomTextField!
    @IBOutlet weak var txtRedeemCredit: CustomTextField!
    @IBOutlet weak var labelRedeemValue: UILabel!
    @IBOutlet weak var labelRedeem: UILabel!
    @IBOutlet weak var labelTotalCreditsUsedValue: UILabel!
    @IBOutlet weak var labelTotalCreditsUsed: UILabel!
    @IBOutlet weak var labelAvailableBalanceValue: UILabel!
    @IBOutlet weak var labelAvailableBalance: UILabel!
    @IBOutlet weak var btnPurchasePlan: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    
    static var storyboardInstance:MembershipPlanInfoVC? {
        return StoryBoard.serviceNotifications.instantiateViewController(withIdentifier: MembershipPlanInfoVC.identifier) as? MembershipPlanInfoVC
    }
    var memberShipPlanRecord = MemeberShipPlanRecord()
    var purchased_membership_plan = MemeberShipPlanRecord.PurchaseMemberShipPlan()
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlaceHolderLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if isConnectedToInternet {
            print("Yes! internet is available.")
            callApiMembedrShipPlaneDetail()
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            purchased_membership_plan = MemeberShipPlanRecord.PurchaseMemberShipPlan(dic:dict["purchased_membership_plan"] as? [String : Any] ?? [String:Any]())
            self.showDataOffline()
        }
        setUpLang()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func showDataOffline() {
        btnPurchasePlan.setTitle(purchased_membership_plan.display_text, for: .normal)
        labelAvailableBalanceValue.text = purchased_membership_plan.available_balance
        labelTotalCreditsUsedValue.text = purchased_membership_plan.total_credit_used
        labelRedeemValue.text = purchased_membership_plan.request_for_redeem
        //txtPaypalEmail.text = purchased_membership_plan.paypal_email
    }
    func setUpPlaceHolderLabel() {
        txtDescription.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 2
        // placeholderLabel.text = "Enter Some Dscription about yourself"
        placeholderLabel.text = localizedString(key: "Enter Description")
        placeholderLabel.font = UIFont(name:"Muli",size:15)        //UIFont.italicSystemFont(ofSize: (textViewSendMsg.font?.pointSize)!)
        
        txtDescription.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtDescription.font?.pointSize)! / 2)
        placeholderLabel.frame.size.width = txtDescription.frame.width - 15
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtDescription.text.isEmpty
    }
    // MARK: - TextView Change
    func textViewDidChange(_ textView: UITextView) {
        if textView == txtDescription {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    func callApiMembedrShipPlaneDetail() {
        let dictParam = [
            "action": Action.getCreditRecord,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getMemberShipPlan(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.memberShipPlanRecord = MemeberShipPlanRecord(dic: dict)
            self.showData()
        }
    }
    func callApiReedemRequest() {
        let dictParam = [
            "action": Action.redeemRequest,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
            "amount": txtRedeemCredit.text!,
            "email": txtPaypalEmail.text!,
            "description": txtDescription.text!
        ] as [String : Any]
        ApiCaller.shared.getMemberShipPlan(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.callApiMembedrShipPlaneDetail()
            self.txtDescription.text = ""
            //self.txtPaypalEmail.text = ""
            self.txtRedeemCredit.text = ""
        }
    }
    func showData() {
        btnPurchasePlan.setTitle(memberShipPlanRecord.purchased_membership_plan.display_text, for: .normal)
        labelAvailableBalanceValue.text = memberShipPlanRecord.purchased_membership_plan.available_balance
        labelTotalCreditsUsedValue.text = memberShipPlanRecord.purchased_membership_plan.total_credit_used
        labelRedeemValue.text = memberShipPlanRecord.purchased_membership_plan.request_for_redeem
        txtPaypalEmail.text = memberShipPlanRecord.paypal_email
        if memberShipPlanRecord.purchased_membership_plan.messaging == "y"{
            lblMessagess.text = localizedString(key: "Yes")
        }else{
            lblMessagess.text = localizedString(key: "No")
        }
        self.lblDuration.text = memberShipPlanRecord.purchased_membership_plan.duration
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Membership Plan")
        btnPurchasePlan.setTitle(localizedString(key: "Upgrade Plan"), for: .normal)
        labelAvailableBalance.text = localizedString(key: "Available Balance")
        labelTotalCreditsUsed.text = localizedString(key: "Total Credits Used")
        labelRedeem.text = localizedString(key: "Requested for Redeem")
        labelRedeemCredit.text = localizedString(key: "Redeem Credit")
        txtRedeemCredit.placeholder = localizedString(key: "Redeem Credit*")
        txtPaypalEmail.placeholder = localizedString(key: "Paypal Email*")
        btnSubmit.setTitle(localizedString(key: "Submit"), for: .normal)
        lblMsgHead.text = localizedString(key: "Messages")
        lblDurationHead.text = localizedString(key: "Plan Duration")
    }
    // MARK: - Textfield Validation
    func checkValidation() -> Bool {
        if (txtRedeemCredit.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.credit)
            return false
        }
        else if AppHelper.isValidEmail(txtPaypalEmail.text!) == false {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.validEmail)
            return false
        }
        else if (txtPaypalEmail.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.email)
            return false
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if checkValidation() {
            callApiReedemRequest()
        }
    }
    @IBAction func btnPurchasePlanAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(UpgradeMemberShipPlanVC.storyboardInstance!, animated: true)
    }
    
}
