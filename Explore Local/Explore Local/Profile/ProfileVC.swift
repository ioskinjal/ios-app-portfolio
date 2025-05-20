//
//  ProfileVC.swift
//  Explore Local
//
//  Created by NCrypted on 11/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAboutMe: UILabel!
    @IBOutlet weak var lblTotalFriends: UILabel!
    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var lblTotalBusiness: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    
    var data:Profile?
    static var storyboardInstance: ProfileVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ProfileVC.identifier) as? ProfileVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
       // self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       // setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Profile", action: #selector(onClickMenu(_:)), isRightBtn: false)
      
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.isHidden = true
        callgetProfile()
    }
    
    func callgetProfile() {
        let param = [
            "user_id":UserData.shared.getUser()!.user_id,
            "action":"profile"
        ]
        Modal.shared.getProfile(vc: self, param: param) { (dic) in
            print(dic)
            self.data = Profile(dic: ResponseKey.fatchData(res: dic, valueOf: .user).dic)
            let data1 = ResponseKey.fatchData(res: dic, valueOf: .user).dic
            _ = UserData.shared.setUser(dic: data1)
            self.imgProfile.downLoadImage(url: (self.data?.image)!)
            self.lblUserName.text = self.data?.name
           self.lblAboutMe.text = self.data?.about_description
            self.lblEmail.text = self.data?.email
          self.lblMemberSince.text = self.data?.member_since
           self.lblTotalFriends.text = String(format: "%d", (self.data?.total_friends)!)
            self.lblTotalBusiness.text = String(format: "%d", (self.data?.total_bookmark)!)
            self.lblLocation.text = self.data?.location
            self.lblTotalReviews.text = String(format: "%d", (self.data?.total_reviews)!)
            self.lblAddress.text = self.data?.address
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickEditProfile(_ sender: UIButton) {
        let nextVC = EditProfileVC.storyboardInstance!
        nextVC.data = data
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
