//
//  prefsVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 16/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MarketingCloudSDK


class prefsVC: UIViewController {
    @IBOutlet weak var lblPrefCategory: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblPrefCategory.font = UIFont(name: "Cairo-SemiBold", size: lblPrefCategory.font.pointSize)
            }
            lblPrefCategory.text = "prefsCat".localized
        }
    }
    @IBOutlet weak var lblNewsSubscription: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNewsSubscription.font = UIFont(name: "Cairo-SemiBold", size: lblNewsSubscription.font.pointSize)
            }
            lblNewsSubscription.text = "newsSub".localized
        }
    }
    @IBOutlet weak var newstableHieghtConsttraint: NSLayoutConstraint!
    @IBOutlet weak var viewNewsSection: UIView!
    @IBOutlet weak var womenBtn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                womenBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            womenBtn.setTitle("slideWomen".localized, for: .normal)
        }
    }
     @IBOutlet weak var menBtn: UIButton!{
         didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                menBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
             menBtn.setTitle("slideMen".localized, for: .normal)
         }
     }
     @IBOutlet weak var kidsBtn: UIButton!{
         didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                kidsBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
             kidsBtn.setTitle("slidKids".localized, for: .normal)
         }
     }
    
    var prefData = [String:String]()
    var userData: AddressInformation?
    @IBOutlet weak var lblNewsltr: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNewsltr.font = UIFont(name: "Cairo-Light", size: lblNewsltr.font.pointSize)
            }
            lblNewsltr.text = "newsLtr".localized
        }
    }
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblNotification: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNotification.font = UIFont(name: "Cairo-SemiBold", size: lblNotification.font.pointSize)
            }
            lblNotification.text = "accountNotification".localized
        }
    }
    @IBOutlet weak var lblPushNitificationDesc: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblPushNitificationDesc.font = UIFont(name: "Cairo-Light", size: lblPushNitificationDesc.font.pointSize)
            }
            lblPushNitificationDesc.text = "accountNotificationDesc".localized
        }
    }
    @IBOutlet weak var lblSaveChanges: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSaveChanges.font = UIFont(name: "Cairo-Regular", size: lblSaveChanges.font.pointSize)
            }
            lblSaveChanges.text = "saveChanges".localized
            lblSaveChanges.addTextSpacing(spacing: 1.5)
        }
    }
    
    @IBOutlet weak var tblCatSelection: UITableView!
    @IBOutlet weak var newltrToggle: Toggle!
    @IBOutlet weak var header: headerView!
    @IBOutlet var selectionArray: [UIButton]!
    let categories = ["Women's news","Men's news","Kid's news"]
    
     @IBOutlet weak var toggle: Toggle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderAction()
        newstableHieghtConsttraint.constant = 0
        newltrToggle.delegate = self
        toggle.delegate = self
        prefData ["category"] =  "\(UserDefaults.standard.value(forKey: "category"))"
        prefData ["news"] = String(self.newltrToggle.isOn)
        prefData ["news_selection_reason"] = ""
    }
    override func viewWillAppear(_ animated: Bool) {
         newltrToggle.setOn(UserDefaults.standard.bool(forKey: "offerNotification"))
        if UserDefaults.standard.bool(forKey: "prefNotification") {
            toggle.setOn(UserDefaults.standard.bool(forKey: "prefNotification"))
            toggle.setOn(true)
        }
        else{
            if newltrToggle.isOn {
                toggle.setOn(true)
                UserDefaults.standard.set(true, forKey: "prefNotification")
            }
        }
        updateCategoryButtonSelection()
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
        header.headerTitle.text = "accountPreference".localized.uppercased()
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - IBAction
    @IBAction func prefSelector(_ sender: UIButton) {
        for item in selectionArray {
            
            if sender.tag == item.tag {
                setCategorySelect(sender)
                UIView.animate(withDuration: 0.3) {
                    sender.backgroundColor = .black
                    sender.setTitleColor(.white, for: .normal)
                    
                }
                
            }
            else{
                UIView.animate(withDuration: 0.3) {
                    item.backgroundColor = .white
                    item.setTitleColor(.black, for: .normal)
                    
                }
            
            }
        }
         NotificationCenter.default.post(name: Notification.Name(notificationName.changeCategory), object: nil)
    }
    
    func setCategorySelect(_ sender: UIButton){
        var tag = sender.tag
        switch tag {
        case 1:
            UserDefaults.standard.setValue(CommonUsed.globalUsed.genderWomen, forKey: "category")
        case 2:
            UserDefaults.standard.setValue(CommonUsed.globalUsed.genderMen, forKey: "category")
        case 3:
            UserDefaults.standard.setValue(CommonUsed.globalUsed.genderKids, forKey: "category")
        default:
            return
        }
       
    }
    func updateCategoryButtonSelection(){
       
            self.womenBtn.backgroundColor = .white
            self.womenBtn.setTitleColor(.black, for: .normal)
          
            self.menBtn.backgroundColor = .white
            self.menBtn.setTitleColor(.black, for: .normal)
  
     
            self.kidsBtn.backgroundColor = .white
            self.kidsBtn.setTitleColor(.black, for: .normal)
 
         let selectedCategory = UserDefaults.standard.value(forKey: "category") as! String
        if selectedCategory == CommonUsed.globalUsed.genderWomen{
            UIView.animate(withDuration: 0.3) {
                self.womenBtn.backgroundColor = .black
                self.womenBtn.setTitleColor(.white, for: .normal)
                               
                           }
          
        }else if selectedCategory == CommonUsed.globalUsed.genderMen{
              UIView.animate(withDuration: 0.3) {
                          self.menBtn.backgroundColor = .black
                          self.menBtn.setTitleColor(.white, for: .normal)
                                         
                                     }
        }else if selectedCategory == CommonUsed.globalUsed.genderKids{
           UIView.animate(withDuration: 0.3) {
                                    self.kidsBtn.backgroundColor = .black
                                    self.kidsBtn.setTitleColor(.white, for: .normal)
                                                   
                                               }
        }
        
    }
    @IBAction func saveChangesSelector(_ sender: Any) {
          saveChangeApiCall()
    }
    func showThankyouPopup() {
        let storyboard = UIStoryboard(name: "thanksPopup", bundle: Bundle.main)
        let popupVC: ThanksPopupVC! = storyboard.instantiateViewController(withIdentifier: "ThanksPopupVC") as? ThanksPopupVC
       // popupVC.thanksView.lblHeader.text = ""
      //  popupVC.thanksView.lblHeader.text = "Thanks".localized
       // popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
      
    }
    
    func updateNotificationLabelColor() {
        UIView.transition(with: lblNewsltr, duration: 0.30, options: .transitionCrossDissolve,
                                  animations: {() -> Void in
                                    self.lblNewsltr.textColor = self.newltrToggle.isOn == true ? .black : UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
                                    },
                                  completion: {(finished: Bool) -> Void in
                        })
    }
    func updateNewsSection(){
        //newstableHieghtConsttraint.constant = self.newltrToggle.isOn == true ? 280 : 0
        //self.newltrToggle.isOn == true ? showNews() : hideNews()
        prefData ["news"] = String(self.newltrToggle.isOn)

    }
     func showNews() {

            UIView.animate(withDuration: 1.0) {
                self.tblCatSelection.alpha  = 1
                self.view.layoutIfNeeded()
            }

        }
        func hideNews(){
            UIView.animate(withDuration: 1.0) {
                self.tblCatSelection.alpha  = 0
                self.view.layoutIfNeeded()
            }
        }
    
    func saveChangeApiCall()  {
        var paramdata =
        [
      
            "customer": [
                "prefix": userData?.prefix ,
                "firstname": userData?.firstname,
                "lastname": userData?.lastname ,
                "email":userData?.email ,
                "middlename": "",
                "dob": "",
                "gender": "",
                "store_id": userData?.storeId ,
                "website_id": userData?.websiteId ,
                "extension_attributes":
                [
                    "is_subscribed" : self.newltrToggle.isOn,
                    
                ]
               
            ]
            
            ] as! [String : Any] 
        
        
       ApiManager.saveChangePref(params: paramdata, success: {  (response, error)  in
        
       
        print(response)
        self.showThankyouPopup()
                   
       }) {_ in
                  let alert = UIAlertController(title: "Error".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
                         alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
               }

    }
    

}
extension prefsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reasonSelectionCell", for: indexPath) as! reasonSelectionCell
        cell.lblReason.text = categories[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SeleCt your reason \(indexPath.row)")
         prefData ["news_selection_reason"] = categories[indexPath.row]
//        let storyboard = UIStoryboard(name: "pickupAddress", bundle: Bundle.main)
//                let returnReasonVC: pickupAddress! = storyboard.instantiateViewController(withIdentifier: "pickupAddress") as? pickupAddress
//        self.navigationController?.pushViewController(returnReasonVC, animated: true)
        
    }
}
extension prefsVC: ToggleDelegate {
    func toggleChanged(_ toggle: Toggle) {
        
        if toggle == newltrToggle{
            updateNotificationLabelColor()
            updateNewsSection()
        }
        else{
            if toggle.isOn{
                UserDefaults.standard.set(true, forKey: "prefNotification")
                MarketingCloudSDK.sharedInstance().sfmc_setPushEnabled(true)
                
                print(MarketingCloudSDK.sharedInstance().sfmc_pushEnabled())
            }
            else{
                UserDefaults.standard.set(false, forKey: "prefNotification")
                MarketingCloudSDK.sharedInstance().sfmc_setPushEnabled(false)
                
                print(MarketingCloudSDK.sharedInstance().sfmc_pushEnabled())
            }
        }
        
        
    }
}
