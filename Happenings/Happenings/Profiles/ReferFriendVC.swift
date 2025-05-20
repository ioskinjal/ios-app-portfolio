//
//  ReferFriendVC.swift
//  Happenings
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReferFriendVC: BaseViewController {

    static var storyboardInstance: ReferFriendVC? {
        return StoryBoard.profile.instantiateViewController(withIdentifier: ReferFriendVC.identifier) as? ReferFriendVC
    }
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
    }
    }
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblCurrentReferalAmount: UILabel!
    @IBOutlet weak var lblReferalLink: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callRefralLink()
       
    }
    
    func callRefralLink(){
        let param = ["user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.getRefralLink(vc: self, param: param) { (dic) in
            print(dic)
            let dict:NSDictionary = dic["data"] as! NSDictionary
            self.lblReferalLink.text = dict.value(forKey: "referral_link") as? String
            self.lblCurrentReferalAmount.text = dict.value(forKey: "referral_amoun") as? String
        }
    }
    

    @IBAction func onClickSend(_ sender: UIButton) {
        if txtEmail.text == "" {
            self.alert(title: "", message: "please enter email address")
        }else if !(txtEmail.text?.isValidEmailId)! {
            self.alert(title: "", message: "please enter valid email address")
        }else{
            let param = ["email_id":txtEmail.text!,
                         "user_id":UserData.shared.getUser()!.user_id]
            
            Modal.shared.sendRefralLink(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                   self.txtEmail.text = ""
                    
                })
            }
        }
    }
    
    @IBAction func onClickFacebook(_ sender: UIButton) {
        
        
        if let myWebsite = NSURL(string: lblReferalLink.text ?? "") {
            let objectsToShare = [myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToFacebook]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickTwitter(_ sender: UIButton) {
        
        
        
        if let myWebsite = NSURL(string: lblReferalLink.text ?? "") {
            let objectsToShare = [myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToTwitter]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReferFriendVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Refer A Friend", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}
