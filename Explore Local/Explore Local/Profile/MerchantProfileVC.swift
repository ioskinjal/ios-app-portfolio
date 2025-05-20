//
//  MerchantProfileVC.swift
//  Explore Local
//
//  Created by NCrypted on 13/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit


class MerchantProfileVC: UIViewController {

    static var storyboardInstance: MerchantProfileVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: MerchantProfileVC.identifier) as? MerchantProfileVC
    }
    
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var lblListedBusiness: UILabel!
    @IBOutlet weak var lblFaxNumber: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    
     var data:Profile?
   
    var strId:String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.shared.getUser()?.user_type == "1"{
            self.btnEdit.isHidden = true
        }
        callGetProfile()
    }
    
    func callGetProfile(){
        var param = ["action":"profile"]
        if UserData.shared.getUser()?.user_type == "1"{
            param["user_id"] = strId
        }else{
            param["user_id"] = UserData.shared.getUser()!.user_id
        }
        Modal.shared.getMerchantProfile(vc: self, param: param) { (dic) in
            if UserData.shared.getUser()?.user_type == "1" {
                
            self.data = Profile(dic: ResponseKey.fatchData(res: dic, valueOf: .user).dic)
                
                self.imgProfile.downLoadImage(url: (self.data?.image)!)
                self.lblLocation.text = self.data?.location
                self.lblEmail.text = self.data?.email
                self.lblUserName.text = self.data?.name
                self.lblFaxNumber.text = self.data?.fax
                self.lblMemberSince.text = self.data?.member_since
                self.lblListedBusiness.text = self.data?.total_business
                self.lblContactNumber.text = self.data?.contact_no
            }else{
           self.data = Profile(dic: ResponseKey.fatchData(res: dic, valueOf: .user).dic)
            let data1 = ResponseKey.fatchData(res: dic, valueOf: .user).dic
            _ = UserData.shared.setUser(dic: data1)
            let user = UserData.shared.getUser()
            self.imgProfile.downLoadImage(url: (user?.image)!)
            self.lblLocation.text = user?.location
            self.lblEmail.text = user?.email
            self.lblUserName.text = user?.name
            self.lblFaxNumber.text = user?.fax
            self.lblMemberSince.text = user?.member_since
            self.lblListedBusiness.text = user?.total_business
            self.lblContactNumber.text = user?.contact_no
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
         let nextVC = EditMerchnatProfileVC.storyboardInstance!
        nextVC.data1 = data
        self.navigationController?.pushViewController(nextVC, animated: true)
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
