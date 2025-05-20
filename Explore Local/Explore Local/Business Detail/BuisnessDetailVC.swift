//
//  BuisnessDetailVC.swift
//  Explore Local
//
//  Created by NCrypted on 01/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import ImageSlideshow
import MessageUI
import MapKit

class BuisnessDetailVC: BaseViewController {
 
    static var storyboardInstance: BuisnessDetailVC? {
        return StoryBoard.businessDetail.instantiateViewController(withIdentifier: BuisnessDetailVC.identifier) as? BuisnessDetailVC
    }
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var txtReply: UITextView!{
        didSet{
            txtReply.placeholder = "Reply"
            txtReply.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
        }
    }
    
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var stackviewComments: UIStackView!
    @IBOutlet weak var btnMessage: UIButton!
//    @IBOutlet weak var btnViewAllRelatedBusiness: UIButton!
    @IBOutlet weak var btnViewAllComments: UIButton!
    var user = UserData.shared.getUser()
    var strBus_id:String = ""
    var arrFacility:NSMutableArray = []
    var arrImages:NSMutableArray = []
    var arrOperatingHours:NSMutableArray = []
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var tblFacilityConst: NSLayoutConstraint!
    @IBOutlet weak var tblFacility: UITableView!{
        didSet{
            tblFacility.register(UITableViewCell.nib, forCellReuseIdentifier: UITableViewCell.identifier)
            tblFacility.dataSource = self
            tblFacility.delegate = self
            tblFacility.tableFooterView = UIView()
            tblFacility.separatorStyle = .none
        }
    }
    var selectedIndexReply:Int = -1
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var lblMerchantMobile: UILabel!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.border(side: .all, color: UIColor.lightGray, borderWidth: 1.5)
        }
    }
    @IBOutlet weak var btnClaimBusiness: UIButton!{
        didSet{
            btnClaimBusiness.layer.borderColor = UIColor.init(hexString: "6367F9").cgColor
        }
    }
   
   
//    @IBOutlet weak var collectionViewHightConst: NSLayoutConstraint!
//    @IBOutlet weak var collectionViewItems: UICollectionView!{
//        didSet{
//            collectionViewItems.delegate = self
//            collectionViewItems.dataSource = self
//            collectionViewItems.register(FavouriteBusinessCell.nib, forCellWithReuseIdentifier: FavouriteBusinessCell.identifier)
//        }
//    }
    @IBOutlet weak var tblComments: UITableView!{
        didSet{
            tblComments.register(CommentCell.nib, forCellReuseIdentifier: CommentCell.identifier)
            tblComments.register(CommentReplyCell.nib, forCellReuseIdentifier: CommentReplyCell.identifier)
            tblComments.dataSource = self
            tblComments.delegate = self
            tblComments.tableFooterView = UIView()
            tblComments.separatorStyle = .none
        }
    }
   
//    @IBOutlet weak var stackViewCoupons: UIStackView!
    @IBOutlet weak var lblMarchantSite: UILabel!{
        didSet{
            lblMarchantSite.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickUrl(_:)))
            lblMarchantSite.addGestureRecognizer(tapGest)
        }
    }
    @IBOutlet weak var lblMarchantLandline: UILabel!{
        didSet{
            lblMarchantLandline.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickPhoneNumber(_:)))
            lblMarchantLandline.addGestureRecognizer(tapGest)
        }
    }
    @IBOutlet weak var lblmarchantEmail: UILabel!
    @IBOutlet weak var lblTimeDuration: UILabel!
    @IBOutlet weak var lblDurationDays: UILabel!
    @IBOutlet weak var lblBusinessFeature: UILabel!
    @IBOutlet weak var lblItemDesc: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!{
        didSet{
            btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367F9").cgColor
        }
    }
    @IBOutlet weak var btnCategory: UIButton!{
        didSet{
            btnCategory.layer.borderColor = UIColor.init(hexString: "6367F9").cgColor
        }
    }
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var couponHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTimeMon: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var viewSlider: ImageSlideshow!
    @IBOutlet weak var stackViewWeek: UIStackView!
    
    @IBOutlet weak var tblCoupon: UITableView!{
        didSet{
            tblCoupon.register(CouponCell.nib, forCellReuseIdentifier: CouponCell.identifier)
            tblCoupon.dataSource = self
            tblCoupon.delegate = self
            tblCoupon.tableFooterView = UIView()
            tblCoupon.separatorStyle = .none
        }
    }
    @IBOutlet weak var viewCoupons: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblTimeSun: UILabel!
    @IBOutlet weak var lblTimeSat: UILabel!
    @IBOutlet weak var lblTimeFri: UILabel!
    @IBOutlet weak var lblTimeThu: UILabel!
    @IBOutlet weak var lblTimewed: UILabel!
    @IBOutlet weak var lblTimeTue: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    
    
    var dataDetail:BusinessDetail!
    var arrCoupons:NSMutableArray = []
    var arrReviews:NSMutableArray = []
    var arrRelatedBusiness:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Business Detail", action: #selector(onClickMenu(_:)))
        
        if UserData.shared.getUser()?.user_type == "2" {
        viewCoupons.isHidden = true
            tblCoupon.isHidden = true
            self.btnAddReview.isHidden = true
        }
       
        //setAutoHeight()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        user = UserData.shared.getUser()
        callBusinessDetail()
    }
    
    @IBAction func onClickCall(_ sender: UIButton) {
        self.callOn(PhoneNumber: (lblMerchantMobile.text)!)
    }
    @IBAction func onClickWeb(_ sender: UIButton) {
        guard let url = URL(string: lblMarchantSite.text!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func onClickInsta(_ sender: UIButton) {
        let googleUrlString = self.dataDetail.inst_link
        if let googleUrl = NSURL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
            }
        }
    }
    @IBAction func onClickMap(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString((self.dataDetail.address)) { (placemarks, error) in
            let placemarks = placemarks
            let location = placemarks?.first?.location
            let latitude: CLLocationDegrees = (location?.coordinate.latitude)!
            let longitude: CLLocationDegrees = (location?.coordinate.longitude)!
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.dataDetail.address
            mapItem.openInMaps(launchOptions: options)
        }
        
    }
    
    @objc func onClickPhoneNumber(_ sender: UITapGestureRecognizer){
        self.callOn(PhoneNumber: (sender.view as! UILabel).text!)
    }
    
    @objc func onClickUrl(_ sender: UITapGestureRecognizer){
        guard let url = URL(string: (sender.view as! UILabel).text!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func callBusinessDetail(){
        let param = ["action":"business",
                     "business_id":strBus_id,
                     "user_id":UserData.shared.getUser()?.user_id ?? ""]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            print(dic)
            
            self.arrCoupons = NSMutableArray()
             self.arrReviews = NSMutableArray()
             self.arrRelatedBusiness = NSMutableArray()
            self.dataDetail = BusinessDetail(dictionary: ResponseKey.fatchData(res: dic, valueOf: .business).dic)
            self.lblItemName.text = self.dataDetail.name
            if self.dataDetail.inst_link == ""{
                self.btnInsta.isHidden = true
            }
            if self.dataDetail.url == ""{
                self.btnWeb.isHidden = true
            }
            if self.dataDetail.merchant_contact_no == ""{
                self.btnCall.isHidden = true
            }
            if self.dataDetail.fb_link == ""{
                self.btnFacebook.isHidden = true
            }
            if self.dataDetail.gp_link == ""{
                self.btnGoogle.isHidden = true
            }
            if self.dataDetail.tw_link == ""{
                self.btnTwitter.isHidden = true
            }
            if self.dataDetail.url == ""{
                self.btnWeb.isHidden = true
            }
            self.lblLocation.text = self.dataDetail.address
            if self.dataDetail.isFav == "n"{
                self.btnFavorite.setImage(#imageLiteral(resourceName: "Heart"), for: .normal)
            }else{
                self.btnFavorite.setImage(#imageLiteral(resourceName: "heart-fill"), for: .normal)
            }
            if self.dataDetail.isAddReview == "y"{
//                self.btnAddReview.isUserInteractionEnabled = false
//                self.btnAddReview.alpha = 0.5
                self.btnAddReview.isHidden = true
            }
            self.btnCategory.setTitle(self.dataDetail.category_name, for: .normal)
            self.btnSubCategory.setTitle(self.dataDetail.sub_category_name, for: .normal)
            self.lblBusinessFeature.text = self.dataDetail.add_info
            self.lblmarchantEmail.text = self.dataDetail.merchant_email
            self.lblmarchantEmail.underline()
            self.lblMarchantLandline.text = self.dataDetail.merchant_fax
            self.lblMarchantLandline.underline()
            self.lblMerchantMobile.text = self.dataDetail.merchant_contact_no
            self.lblMerchantMobile.underline()
            self.lblMerchantName.text = self.dataDetail.merchant_name
            self.lblItemDesc.text = self.dataDetail.desc
            if self.dataDetail.merchant_id == UserData.shared.getUser()?.user_id {
                self.btnMessage.isHidden = true
            }
            self.lblMarchantSite.text = self.dataDetail.url
            self.lblMarchantSite.underline()
            let dict:NSDictionary = dic["business"] as! NSDictionary
            self.arrFacility = NSMutableArray()
            self.arrFacility.addObjects(from:dict.value(forKey: "facility") as! [Any])
            if self.arrFacility.count != 0{
                self.tblFacility.reloadData()
                self.setAutoHeightTable()
            }
            self.arrImages.addObjects(from: dict.value(forKey: "images") as! [Any])
            if self.arrImages.count != 0{
                var alamofireSource = [AlamofireSource]()
                for i in 0..<self.arrImages.count{
                    let dict:NSDictionary = self.arrImages[i]as! NSDictionary
                    alamofireSource.append(AlamofireSource(urlString: dict.value(forKey: "image") as! String)!)
                }
                self.viewSlider.setImageInputs(alamofireSource)
                    self.viewSlider.contentScaleMode = .scaleAspectFill
                self.viewSlider.slideshowInterval  = 3.0
                  
            }
            
            self.arrRelatedBusiness.addObjects(from: dict.value(forKey: "related_business") as! [Any])
//            if self.arrRelatedBusiness.count != 0 {
//                self.collectionViewItems.reloadData()
//                if self.arrRelatedBusiness.count == 4{
//                    self.btnViewAllRelatedBusiness.isHidden = false
//                }else{
//                    self.btnViewAllRelatedBusiness.isHidden = true
//                }
//                self.setAutoHeight()
//            }
            
            
            self.arrReviews.addObjects(from: dict.value(forKey: "reviews") as! [Any])
            if self.arrReviews.count != 0 {
                if self.arrReviews.count == 2 || self.arrReviews.count < 2 {
                  self.btnViewAllComments.isHidden = false
                }else{
                   self.btnViewAllComments.isHidden = true
                }
                self.tblComments.reloadData()
                self.setAutoHeightTable()
            }else{
                self.btnViewAllComments.isHidden = true
                self.stackviewComments.isHidden = true
            }
            self.arrCoupons.addObjects(from: dict.value(forKey: "coupons") as! [Any])
            if self.arrCoupons.count != 0 {
                self.viewCoupons.isHidden = false
                self.tblCoupon.reloadData()
                self.couponHeightConst.constant = self.tblCoupon.contentSize.height
            }else{
                self.viewCoupons.isHidden = true
                self.couponHeightConst.constant = 0
            }
           
            self.arrOperatingHours.addObjects(from: dict.value(forKey: "operating_hours") as! [Any])
            if self.arrOperatingHours.count != 0{
                var dictWeek: NSDictionary = self.arrOperatingHours[0]as! NSDictionary
                if dictWeek.value(forKey: "mon")as? String == "c" {
                    self.lblTimeMon.text = "Close"
                }else{
                    self.lblTimeMon.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[1]as! NSDictionary
                 if dictWeek.value(forKey: "tue")as? String == "c" {
                    self.lblTimeTue.text = "Close"
                }else{
                    self.lblTimeTue.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[2]as! NSDictionary
                if dictWeek.value(forKey: "wed")as? String == "c" {
                    self.lblTimewed.text = "Close"
                }else{
                    self.lblTimewed.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[3]as! NSDictionary
                if dictWeek.value(forKey: "thu")as? String == "c" {
                    self.lblTimeThu.text = "Close"
                }else{
                    self.lblTimeThu.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[4]as! NSDictionary
                if dictWeek.value(forKey: "fri")as? String == "c" {
                    self.lblTimeFri.text = "Close"
                }else{
                    self.lblTimeFri.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[5]as! NSDictionary
                if dictWeek.value(forKey: "sat")as? String == "c" {
                    self.lblTimeSat.text = "Close"
                }else{
                    self.lblTimeSat.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
                dictWeek = NSDictionary()
                dictWeek = self.arrOperatingHours[6]as! NSDictionary
                if dictWeek.value(forKey: "sun")as? String == "c" {
                    self.lblTimeSun.text = "Close"
                }else{
                    self.lblTimeSun.text = String(format: "%@-%@", dictWeek.value(forKey: "start_time") as! CVarArg,dictWeek.value(forKey: "end_time") as! CVarArg)
                }
                
            }
            
            
        }
    }
    
//    func setAutoHeight() {
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//            self.collectionViewHightConst.constant = self.collectionViewItems.contentSize.height
//            self.view.layoutIfNeeded()
//        }
//
//    }
    
    func setAutoHeightTable() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblFacilityConst.constant = self.tblFacility.contentSize.height
          //  self.couponHeightConst.constant = self.tblCoupon.contentSize.height
             self.tblHeightConst.constant = self.tblComments.contentSize.height
            self.view.layoutIfNeeded()
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
    
    
    @IBAction func onClickCloseViewReply(_ sender: UIButton) {
        viewReply.isHidden = true
        self.navigationBar.isHidden = false
    }
    
    @IBAction func onClickMerchantName(_ sender: UIButton) {
        let nextvc = MerchantProfileVC.storyboardInstance!
        nextvc.strId = self.dataDetail.merchant_id
        self.navigationController?.pushViewController(nextvc, animated: true)
        
    }
    @IBAction func onClickReplyComment(_ sender: UIButton) {
        if txtReply.text != "" {
        var dict = NSDictionary()
        dict = arrReviews[selectedIndexReply] as! NSDictionary
        
        let param = ["action":"reply_review",
                     "reply_text":txtReply.text!,
                     "review_id":dict.value(forKey: "review_id")as! String,
                     "user_id":UserData.shared.getUser()!.user_id]
        
        Modal.shared.postedBusiness(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.viewReply.isHidden = true
                self.navigationBar.isHidden = false
                self.callBusinessDetail()
            })
        }
        }else{
            self.alert(title: "", message: "Please enter comment")
        }
    }
    
    
    @IBAction func onClickOperatingHours(_ sender: UIButton) {
        if self.stackViewWeek.isHidden == true {
        stackViewWeek.isHidden = false
        }else{
            stackViewWeek.isHidden = true
        }
    }
    
    @IBAction func onClickMessage(_ sender: UIButton) {
      
        if user == nil{
           self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
       // if UserData.shared.getUser()?.user_type == "1"{
        let dic:[String:Any] = ["action":"conversation",
                                "user_id":UserData.shared.getUser()!.user_id,
                                "receiver_id":self.dataDetail.merchant_id
        ]
        let nextVC = ChatVC.storyboardInstance!
        nextVC.param = dic
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func onClickFavorite(_ sender: UIButton) {
        if user == nil{
            self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
        let param = ["action":"favorite",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "business_id":strBus_id]
        
        Modal.shared.favUnfav(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                    self.callBusinessDetail()
            })
        }
        }
    }
    @IBAction func onClickAddReview(_ sender: UIButton) {
        if user == nil{
            self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
        if dataDetail.ispaid == "n"{
            
//            let OKAction = UIAlertAction(title: "Purchase Membership Plan", style: .default, handler: { _ -> Void in
//                self.dismiss(animated: true, completion: nil)
              self.navigationController?.pushViewController(MembershipPlanListVC.storyboardInstance!, animated: true)
          //  })

//            self.alert(title: "", message: "You didn't purchase any membership plan to review this business", actions:[OKAction])
        }else{
        let parentVC = self
        guard let nextVC = ReviewPopUpVC.storyboardInstance else {return}
        nextVC.businessDetail = self.dataDetail
        nextVC.bus_id = strBus_id
        nextVC.parentVC1 = parentVC
        nextVC.presentAsPopUp(parentVC: parentVC)
        }
        }
    }
    @IBAction func onClickViewAllComments(_ sender: UIButton) {
//        if user == nil{
//            self.navigationController?.popToRootViewController(animated: true)
//        }else{
        let nextVC = CommentsVC.storyboardInstance!
        nextVC.strBusiness_id = strBus_id
        self.navigationController?.pushViewController(nextVC, animated: true)
        //}
        
    }
    @IBAction func onClickNumber(_ sender: Any) {
        self.callOn(PhoneNumber: (lblMerchantMobile.text)!)
    }
    
    @IBAction func onClickEmail(_ sender: UIButton) {
        sendEmail(emails: [lblmarchantEmail.text!])
    }
    @IBAction func onclickTwitter(_ sender: UIButton) {
       
        let googleUrlString = self.dataDetail.tw_link
        if let googleUrl = NSURL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
            }
        }
    }
    
    @IBAction func onClickGoogle(_ sender: UIButton) {
        let googleUrlString = self.dataDetail.gp_link
        if let googleUrl = NSURL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
            }
        }
    }
    @IBAction func onClickFB(_ sender: UIButton) {
      
        let googleUrlString = self.dataDetail.fb_link
        if let googleUrl = NSURL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
            }
        }
    }
    @IBAction func onClickViewAll(_ sender: Any) {
        let nextVC = RelatedBusinessVCViewController.storyboardInstance!
        nextVC.business_id = strBus_id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func onClickPost(_ sender: UIButton) {
    }
    @IBAction func onClickRedeemCoupon(_ sender: UIButton) {
    }
    @IBAction func onClickSendToFriend(_ sender: Any) {
//        if user == nil{
//            self.navigationController?.popToRootViewController(animated: true)
//        }else{
        let nextVC = SendInviteVC.storyboardInstance!
        nextVC.strbus_id = strBus_id
        self.navigationController?.pushViewController(nextVC, animated: true)
        //}
    }
    @IBAction func onClickClaimBusiness(_ sender: UIButton) {
        if user == nil{
            self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
    let nextVC = ClaimBusinessVC.storyboardInstance!
    nextVC.strBus_id = strBus_id
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

}
extension BuisnessDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblCoupon{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CouponCell.identifier) as? CouponCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            var dict = NSDictionary()
            dict = arrCoupons[indexPath.row] as! NSDictionary
            print(dict)
            cell.lblDesc.text = dict.value(forKey: "coupon_description") as? String
            
            cell.lblDuration.text = dict.value(forKey: "coupon_name") as? String
           
             cell.lblDiscount.text = String(format: "$%@", dict.value(forKey: "coupon_value")as! String)
         
            if dict.value(forKey: "coupon_expiry")as! String == "" {
                cell.imgRedeem.isHidden = true
               cell.lblPromocode.text = ""
                cell.headPromocode.isHidden = true
                cell.btnRedeem.isHidden = false
             
                  //  cell.btnRedeem.border(side: .all, color: UIColor.init(hexString: "006300"), borderWidth: 1.0)
               
                cell.btnRedeem.tag = indexPath.row
                cell.lblDesc.text = dict.value(forKey: "coupon_description")as? String
                cell.btnRedeem.addTarget(self, action: #selector(onClickRedeem), for: .touchUpInside)
               cell.lblValidDate.isHidden = true
                
            }else{
              
                cell.lblValidDate.text = String(format: "Available again on %@", (dict.value(forKey: "coupon_expiry")as? String)!)
                cell.lblValidDate.isHidden = false
                cell.btnRedeem.isHidden = true
                    cell.lblPromocode.text = String(format: "%@",(dict.value(forKey: "promo_code")as! String))
                 cell.headPromocode.isHidden = false
                cell.imgRedeem.isHidden = false
            }
            
            if dict.value(forKey: "last_redeemed_date")as! String == "" || dict.value(forKey: "coupon_expiry")as! String == ""{
                cell.lblRedeemedDate.text = ""
            }else{
                cell.lblRedeemedDate.text = String(format: "Redeemed On: %@",(dict.value(forKey: "last_redeemed_date")as! String))
            }
            return cell
        }else if tableView == tblFacility {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            var dict = NSDictionary()
            dict = arrFacility[indexPath.row] as! NSDictionary
            cell.textLabel?.text = String(format: "- %@", dict.value(forKey: "value") as! CVarArg)
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont(name: "Montserrat-Light", size: 15.0)
            cell.textLabel?.numberOfLines = 0
            return cell
           
        }else{
            var dict = NSDictionary()
            dict = arrReviews[indexPath.row] as! NSDictionary
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
            if dict.value(forKey: "reported")as? String == "n" {
            cell.btnFlag.tag = indexPath.row
            cell.btnFlag.addTarget(self, action: #selector(onClickFlag(_:)), for: .touchUpInside)
            }else{
                cell.btnFlag.isHidden = true
            }
            cell.lblname.text = dict.value(forKey: "user_name")as? String
            cell.lblComment.text = dict.value(forKey: "review_description") as? String
            cell.viewRate.rating = ((dict.value(forKey: "rating")as? NSString)?.doubleValue)!
            
            let startDate = dict.value(forKey: "posted_date")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatedStartDate = dateFormatter.date(from: startDate! as! String)
            let currentDate = Date()
            let components = Set<Calendar.Component>([.day, .month, .year,.weekday,.second,.minute,.hour])
            let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
            
            print (differenceOfDate)
            if differenceOfDate.minute == 0 {
                cell.lblTime.text = String(format: "updated %d seconds ago", differenceOfDate.second!)
            }else if differenceOfDate.hour == 0 {
                cell.lblTime.text = String(format: "updated %d minutes ago", differenceOfDate.minute!)
            }else if differenceOfDate.day == 0 {
                cell.lblTime.text = String(format: "updated %d hours ago", differenceOfDate.hour!)
            }else if differenceOfDate.weekday == 0 {
                cell.lblTime.text = String(format: "updated %d days ago", differenceOfDate.day!)
            }else if differenceOfDate.month == 0 {
                cell.lblTime.text = String(format: "updated %d weeks ago", differenceOfDate.weekday!)
            }else if differenceOfDate.year == 0 {
                cell.lblTime.text = String(format: "updated %d months ago", differenceOfDate.month!)
            }else {
                cell.lblTime.text = String(format: "updated %d years ago", differenceOfDate.year!)
            }
             if dict.value(forKey: "comment")as? String != "" {
                cell.viewComment.isHidden = false
                cell.lblNameMerchant.text = dict.value(forKey: "merchantName")as? String
                cell.lblMerchantComment.text = dict.value(forKey: "comment")as? String
               
                let startDate = dict.value(forKey: "commentDate")as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formatedStartDate = dateFormatter.date(from: startDate )
                let currentDate = Date()
                let components = Set<Calendar.Component>([.day, .month, .year,.weekday,.second,.minute,.hour])
                let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
                
               
                print (differenceOfDate)
                if differenceOfDate.minute == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d seconds ago", differenceOfDate.second!)
                }else if differenceOfDate.hour == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d minutes ago", differenceOfDate.minute!)
                }else if differenceOfDate.day == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d hours ago", differenceOfDate.hour!)
                }else if differenceOfDate.weekday == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d days ago", differenceOfDate.day!)
                }else if differenceOfDate.month == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d weeks ago", differenceOfDate.weekday!)
                }else if differenceOfDate.year == 0 {
                    cell.lblDateMerchant.text = String(format: "updated %d months ago", differenceOfDate.month!)
                }else {
                    cell.lblDateMerchant.text = String(format: "updated %d years ago", differenceOfDate.year!)
                }
                cell.btnReply.isHidden = true
             }else{
                cell.viewComment.isHidden = true
                cell.btnReply.tag = indexPath.row
                cell.btnReply.addTarget(self, action: #selector(onClickReply(_:)), for: .touchUpInside)
                cell.btnReply.isHidden = false
            }
            cell.imgView.downLoadImage(url: dict.value(forKey: "user_image") as! String)
            cell.imgMerchant.downLoadImage(url: dict.value(forKey: "merchantProfile") as! String)
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width/2
            cell.imgMerchant.layer.cornerRadius = cell.imgMerchant.frame.size.width/2
            cell.imgView.layer.masksToBounds = true
            cell.imgMerchant.layer.masksToBounds = true
            
            
            
            
        return cell
        }
    }
    
    @objc func onClickRedeem(_ sender:UIButton){
        if user == nil{
            isFromPlan = true
            self.navigationController?.pushViewController(SignUpVC.storyboardInstance!, animated: true)
        }else{
        if dataDetail.ispaid == "n"{
            
//            let OKAction = UIAlertAction(title: "Purchase Membership Plan", style: .default, handler: { _ -> Void in
//                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(MembershipPlanListVC.storyboardInstance!, animated: true)
           // })
            
//            self.alert(title: "", message: "You didn't purchase any membership plan to redeem coupon", actions:[OKAction])
            
        }else{
        var dict = NSDictionary()
        dict = arrCoupons[sender.tag] as! NSDictionary
        
        let param = ["action":"redeem_coupon",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "coupon_id":dict.value(forKey: "id")!,
                     "business_id":strBus_id]
        
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callBusinessDetail()
            })
        }
        }
        }
    }
    
    @objc func onClickReply(_ sender:UIButton){
        if user == nil{
            self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
        selectedIndexReply = sender.tag
        self.navigationBar.isHidden = true
       self.viewReply.isHidden = false
        }
    }
    
    @objc func onClickFlag(_ sender:UIButton){
        if user == nil{
            self.navigationController?.pushViewController(LoginVC.storyboardInstance!, animated: true)
        }else{
        let dict:NSDictionary = arrReviews[sender.tag] as! NSDictionary
        if sender.currentImage == #imageLiteral(resourceName: "Flag"){
        let param = ["action":"report_review",
                     "business_id":strBus_id,
                     "user_id":UserData.shared.getUser()!.user_id,
                     "review_id":dict.value(forKey: "review_id")as! String]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callBusinessDetail()
            })
            }
        }else{
            
        }
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblFacility{
         return self.arrFacility.count
        }else if tableView == tblCoupon{
            return arrCoupons.count
        }
        else{
        return arrReviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblCoupon{
            DispatchQueue.main.async {
                self.couponHeightConst.constant = self.tblCoupon.contentSize.height
            }
//            self.tblCoupon.layoutIfNeeded()
//            self.view.layoutIfNeeded()
        }else if tableView == tblComments{
            DispatchQueue.main.async {
             self.tblHeightConst.constant = self.tblComments.contentSize.height
            }
        }
    }
    
    
}
extension BuisnessDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRelatedBusiness.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteBusinessCell.identifier, for: indexPath) as? FavouriteBusinessCell else {
            fatalError("Cell can't be dequeue")
        }
        let dict:NSDictionary = arrRelatedBusiness[indexPath.row] as! NSDictionary
        cell.lblName.text = dict.value(forKey: "business_name")as? String
       cell.lblCat.text = dict.value(forKey: "category")as? String
       cell.lblSubCat.text = dict.value(forKey: "subcategory")as? String
        cell.imgView.downLoadImage(url: (dict.value(forKey: "businessImage")as? String)!)
        cell.lblTotal.text = String(format: "%d", dict.value(forKey: "totalRating") as! Int)
        cell.lblRate.text = dict.value(forKey: "averageReview") as? String
        cell.btnRemove.isHidden = true
        cell.viewCat.layer.borderColor = UIColor.white.cgColor
        cell.viewSubCat.layer.borderColor = UIColor.white.cgColor
        cell.contentView.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 241)
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        // create a cell size from the image size, and return the size
    //        let imageSize = model.images[indexPath.row].size
    //
    //        return imageSize
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
//MARK: mail compose delegate
extension BuisnessDetailVC: MFMailComposeViewControllerDelegate{
    
    func sendEmail(emails:[String]) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(emails)
            //mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
            self.alert(title: "Error", message: "Can't send mail")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print("failed")
        }
        
        controller.dismiss(animated: true)
    }
    
}


class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle, value:NSUnderlineStyle.styleSingle.rawValue , range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
