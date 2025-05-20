//
//  ProfileVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 30/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit


class ProfileVC: BaseViewController {

    static var storyboardInstance:ProfileVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ProfileVC.identifier) as? ProfileVC
    }
    
    @IBOutlet weak var viewBlank: UIView!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var viewCredits: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewUserEmail: UIView!
    
    var data:Profile?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Profile", action: #selector(onClickMenu(_:)))
       
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         callgetProfile()
    }
    func callgetProfile() {
        let param = [
            "uid":UserData.shared.getUser()!.user_id
        ]
        Modal.shared.getProfile(vc: self, param: param) { (dic) in
            print(dic)
            self.viewBlank.isHidden = true
            self.data = Profile(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.imgProfile.downLoadImage(url: (self.data?.user_image)!)
            self.lblName.text = (self.data?.fname)! + " " + (self.data?.lname)!
            self.lblEmail.text = self.data?.email
            self.lblNumber.text = self.data?.phone
            //self.lblCredits.text = String.init(format: "%.1f", (self.data?.credits)!)
            self.lblCredits.text = "Rs " + self.data!.credits
            
        }
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickEditProfile(_ sender: UIButton) {
        let nextVC = EditProfileVC.storyboardInstance!
        nextVC.data = data
        nextVC.selectedImg = imgProfile.image
        self.navigationController?.pushViewController(nextVC, animated: true)
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


