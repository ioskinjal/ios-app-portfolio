//
//  NotificationSettingVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class NotificationSettingVC: BaseViewController {

    static var storyboardInstance:NotificationSettingVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: NotificationSettingVC.identifier) as? NotificationSettingVC
    }
    
    @IBOutlet weak var btnCancelled: UIButton!
    @IBOutlet weak var btnInvoice: UIButton!
    @IBOutlet weak var btnDispatched: UIButton!
    @IBOutlet weak var btnPacked: UIButton!
    @IBOutlet weak var btnPlaced: UIButton!
    @IBOutlet weak var viewPlaced: UIView!
    @IBOutlet weak var viewPacked: UIView!
    @IBOutlet weak var viewDispatched: UIView!
    @IBOutlet weak var viewInvoice: UIView!
    @IBOutlet weak var viewCancelled: UIView!
    //var data:NotificationSetting?
    var newBusiness : String = ""
    var replyReview :  String = ""
    var reNewMembership :  String = ""
    var newReview :  String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Notification Settings", action: #selector(onClickMenu(_:)), isRightBtn: false)
       
        callgetNotificationSettings()
    }
    
    
    func callgetNotificationSettings() {
//        let param  = ["uid":UserData.shared.getUser()!.user_id]
//        Modal.shared.getNotificationSettings(vc: self, param: param) { (dic) in
//            print(dic)
//        self.data = NotificationSetting(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
//            if self.data?.orderPlaced == true {
//                self.orderPlaced = "y"
//                self.btnPlaced.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//                self.orderPlaced = "y"
//
//            }else{
//                self.orderPlaced = "n"
//                self.btnPlaced.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//                self.orderPlaced = "n"
//            }
//            if self.data?.orderPacked == true {
//                self.orderPacked = "y"
//                 self.btnPacked.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//            }else{
//                self.orderPacked = "n"
//                self.btnPacked.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//            }
//            if self.data?.orderDispatched == true {
//                self.orderDispatched = "y"
//                 self.btnDispatched.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//            }else{
//                self.orderDispatched = "n"
//                self.btnDispatched.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//            }
//            if self.data?.orderDelivered == true {
//                 self.btnInvoice.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//                self.orderDelivered = "y"
//            }else{
//                self.orderDelivered = "n"
//                self.btnInvoice.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//            }
//            if self.data?.orderCancelled == true {
//                self.orderCancelled = "y"
//                 self.btnCancelled.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
//            }else{
//                self.orderCancelled = "n"
//                self.btnCancelled.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//            }
//        }
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSettings(_ sender: UIButton) {
        let button = sender
       
        if button.tag == 0{
             if UserData.shared.getUser()?.user_type == "1"{
            if newBusiness == "n"{
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                newBusiness = "y"
                }else{
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                newBusiness = "n"
            }
             }else{
                if newBusiness == "n"{
                    button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                    newReview = "y"
                }else{
                    button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
                    newReview = "n"
                }
            }
            
        }else if button.tag == 1{
            if replyReview == "n" {
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                replyReview = "y"
            }else{
                replyReview = "n"
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
            }
            
        }else if button.tag == 2{
            if reNewMembership == "n" {
                button.setImage(#imageLiteral(resourceName: "On"), for: .normal)
                reNewMembership = "y"
            }else{
                reNewMembership = "n"
                button.setImage(#imageLiteral(resourceName: "Off"), for: .normal)
            }
        }
            
        callEditNotificationSettings()
    }
    
    func callEditNotificationSettings() {
        var param = [String:String]()
        if UserData.shared.getUser()?.user_type == "1"{
            param = ["user_id":UserData.shared.getUser()!.user_id,
                     "new_business":newBusiness,
                     "reply_review":replyReview,
                     "renew_membership":reNewMembership,
                     "action":"notification_settings"]
        }else{
            param = ["user_id":UserData.shared.getUser()!.user_id,
                     "new_review":newReview,
                     "action":"notification_settings"]
        }
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            //self.callgetNotificationSettings()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
