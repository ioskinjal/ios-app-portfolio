//
//  ProfileVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class ProfileVC: BaseVC {
    
    @IBOutlet weak var viewPayment: UIView!{
        didSet{
            viewPayment.layer.borderColor = UIColor(red: 230, green: 230, blue: 230).cgColor
        }
    }
    @IBOutlet weak var viewImg: UIView!{
        didSet{
            viewImg.applyCorner(radius: viewImg.frame.size.width/2)
            viewImg.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    @IBOutlet weak var paymentModeImgView: UIImageView!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var navTitle:UILabel!

    
    var userProfile = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserProfile(){
        
        
        startIndicator(title: "")
        
        let params: Parameters = ["userId":sharedAppDelegate().currentUser!.uId]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.profile, parameters: params, successBlock: { (json, urlResponse) in
            
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                print("Items \(dataAns)")
                
                let person = User.initWithResponse(dictionary: userDict as? [String : Any])
                self.userProfile = person
                DispatchQueue.main.async {
                    
                    self.displayUser(loggedInUser: person)
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    func displayUser(loggedInUser:User){
        
        lblName.text = String(format:"%@ %@",loggedInUser.firstName,loggedInUser.lastName)
        lblMobileNumber.text = loggedInUser.mobileNo
        lblEmail.text = loggedInUser.email
        
        if loggedInUser.defaultPaymentMethod == "c" {
            lblPaymentMode.text = appConts.const.cASH
            paymentModeImgView.image = #imageLiteral(resourceName: "Coins")
        }
        else{
            lblPaymentMode.text = appConts.const.wALLET
            paymentModeImgView.image = #imageLiteral(resourceName: "Wallet")
        }
        
        paymentModeImgView.contentMode = .scaleAspectFit
        
        sharedAppDelegate().currentUser = loggedInUser
       // User.saveUser(loggedUser: loggedInUser)
        
        let profileImage = String(format:"%@/%@/%@",URLConstants.Domains.profileUrl,(sharedAppDelegate().currentUser?.uId)!,(sharedAppDelegate().currentUser?.profileImage)!)

        self.profileImgView.af_setImage(withURL: URL(string: profileImage)!)
        self.profileImgView.applyCorner(radius: self.profileImgView.frame.size.width/2)
        self.profileImgView.clipsToBounds = true
        
    }
    
    
    // MARK: - Button events
  
    @IBAction func btnMenuClicked(_ sender: Any) {
        openMenu()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        openMenu()
    }
    
    @IBAction func btnEditProfileClicked(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    @IBAction func btnEditPaymentModeClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let editProfileController = storyBoard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func navigateToAddEditLocation(type:Bool){
        
        let favoriteVC = FavoriteVC(nibName: "FavoriteVC", bundle: nil)
        favoriteVC.isHomelocation = type
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    
}
