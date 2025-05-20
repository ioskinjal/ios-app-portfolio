//
//  DealDetailVC.swift
//  Happenings
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos
import SafariServices
import ImageSlideshow

class DealDetailVC: BaseViewController {

    static var storyboardInstance: DealDetailVC? {
        return StoryBoard.dealDetail.instantiateViewController(withIdentifier: DealDetailVC.identifier) as? DealDetailVC
    }
    @IBOutlet weak var btnAddReview: UIButton!
    @IBOutlet weak var viewMerchantDetail: UIView!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { self.viewMerchantDetail.layer.borderColor = UIColor.init(hexString: "E6E6E6").cgColor
                
                self.viewMerchantDetail.layer.borderWidth = 1.0
            }
            
        }
    }
    
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var btnReportAbuse: UIButton!
    
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "Description"
        }
    }
    @IBOutlet weak var stackVieShare: UIStackView!
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.borderColor = UIColor.init(hexString: "E0171E").cgColor
        }
    }
    @IBOutlet weak var viewSimilarDeal: UIView!
    @IBOutlet weak var viewReviews: UIView!
    @IBOutlet weak var viewReportAbuse: UIView!
    @IBOutlet weak var viewSlider: ImageSlideshow!
    @IBOutlet weak var tblOptionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var collectionViewHeightconst: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var tblDealOption: UITableView!{
        didSet{
            tblDealOption.register(DealDetailOptionCell.nib, forCellReuseIdentifier: DealDetailOptionCell.identifier)
            tblDealOption.dataSource = self
            tblDealOption.delegate = self
            tblDealOption.tableFooterView = UIView()
            tblDealOption.separatorStyle = .none
        }
    }
    @IBOutlet weak var lblRateView: CosmosView!
    @IBOutlet weak var lblDealName: UILabel!
    
    @IBOutlet weak var collectionViewDeal: UICollectionView!{
        didSet{
            collectionViewDeal.delegate = self
            collectionViewDeal.dataSource = self
            collectionViewDeal.register(NearByDealCell.nib, forCellWithReuseIdentifier: NearByDealCell.identifier)
        }
    }
    @IBOutlet weak var lblMerchantUrl: UILabel!
    @IBOutlet weak var lblMerchantEmail: UILabel!
    
    @IBOutlet weak var lblMerchantPhone: UILabel!
    
    @IBOutlet weak var tblReviews: UITableView!{
        didSet{
            tblReviews.register(ReviewProfileCell.nib, forCellReuseIdentifier: ReviewProfileCell.identifier)
            tblReviews.dataSource = self
            tblReviews.delegate = self
            tblReviews.tableFooterView = UIView()
        }
    }
    var selectedOption:Int = -1
    var strId:String = ""
    var dealDeatil:DealDetailCls?
    var selectedDealOption:OptionList?
    var isSelectedOption:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callDealDetail()
        
    }
    
    func callDealDetail(){
        var param = ["deal_id":strId]
        
        let user = UserData.shared.getUser()
        if user != nil{
            param["user_id"] = UserData.shared.getUser()!.user_id
        }else{
            param["user_id"] = ""
        }
        Modal.shared.getDealDetail(vc: self, param: param) { (dic) in
            print(dic)
            //self.dealDeatil = DealDetailCls(dictionary: dic["data"] as! [String : Any])
            let a = ResponseKey.fatchData(res: dic, valueOf: .data).dic
            let b = a["deal"] as! [String:Any]
            self.dealDeatil = DealDetailCls(dictionary:b)
            self.setData(data: self.dealDeatil!)
            self.tblDealOption.reloadData()
            self.tblReviews.reloadData()
            
            //self.setAutoHeight()
           self.setAutoHeighttbl()
                var alamofireSource = [AlamofireSource]()
            if let data = self.dealDeatil?.imageList {
                for i in 0..<data.count{
                    alamofireSource.append(AlamofireSource(urlString:
                        (self.dealDeatil?.imageList[i].dealImage)!)!)
                }
            }
                self.viewSlider.setImageInputs(alamofireSource)
                self.viewSlider.contentScaleMode = .scaleAspectFill
            self.viewSlider.clipsToBounds = true
                self.viewSlider.slideshowInterval  = 3.0
            self.btnFavorite.bringToFront()
            
        }
       
    }
    
    func setData(data:DealDetailCls){
        self.lblCategory.text = dealDeatil?.categoryName
        self.lblSubCategory.text = dealDeatil?.subcategoryName
        self.lblDesc.text = dealDeatil?.description
        self.lblMerchantName.text = dealDeatil?.merchantName
        self.lblMerchantUrl.text = dealDeatil?.merchantWebsite
        self.lblMerchantEmail.text = dealDeatil?.merchantEmail
        self.lblMerchantPhone.text = dealDeatil?.merchantContact
        self.lblUserName.text = dealDeatil?.merchantName
        self.lblDealName.text = dealDeatil?.deal_title
        if dealDeatil?.isPurchased == "n"{
            btnAddReview.isHidden = false
        }
        if dealDeatil?.isFavotite == "y"{
            btnFavorite.setImage(#imageLiteral(resourceName: "heart_fill"), for: .normal)
        }else{
            btnFavorite.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        if dealDeatil?.reviewsList.count == 0{
            viewReviews.isHidden = true
        }
        if dealDeatil?.similarDealList.count == 0{
        viewSimilarDeal.isHidden = true
        }else{
            self.collectionViewDeal.reloadData()
            
        }
        var strLocation:String = ""
        if let data = self.dealDeatil?.locationList {
            for i in 0..<data.count{
                if strLocation == ""{
                    strLocation = (dealDeatil!.locationList[i].deal_location ?? "")
                }else{
                    strLocation = String(format: "%@ || %@", strLocation,dealDeatil!.locationList[i].deal_location ?? "")
                }
            }
        }
        self.lblLocation.text = strLocation
    }
    @IBAction func onClickShareEmail(_ sender: UIButton) {
        displayAlret { (email) in
        let param = ["user_id":UserData.shared.getUser()!.user_id,
                     "deal_id":self.strId,
                     "email_address":email,
                     "action":"share-deal-by-email"]
            
            Modal.shared.shareDealByMail(vc: self, param: param, success: { (dic) in
                let data = ResponseKey.fatchData(res: dic, valueOf: .message).str
                self.alert(title: "", message: data)
            })
        }
    }
    
    func displayAlret(callback:@escaping (_ txtStr1:String) -> Void ) {
        let alertController = UIAlertController(title: "Share Deal", message: "Enter email id for share deal", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Share Deal", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.keyboardType = .emailAddress
            print("firstTxtValues: \(firstTextField.text!)")
            if !(firstTextField.text?.isEmpty)! || (firstTextField.text?.isValidEmailId)! {
                callback(firstTextField.text!)
            }
            else {
                self.alert(title: "Error", message: "Please enter valid email id")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email id"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickAddReview(_ sender: UIButton) {
        let parentVC = self
        guard let nextVC = ReviewPopUpVC.storyboardInstance else {return}
        nextVC.businessDetail = self.dealDeatil
        nextVC.str_id = strId
        nextVC.parentVC = parentVC
        nextVC.presentAsPopUp(parentVC: parentVC)
        
    }
    @IBAction func onClickFavorite(_ sender: UIButton) {
        if btnFavorite.currentImage == #imageLiteral(resourceName: "heart_fill") {
            let param = ["action":"remove-deal-from-favorite",
                         "user_id":UserData.shared.getUser()!.user_id,
                         "favorite_id":strId]
            
            Modal.shared.removeToFavorite(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callDealDetail()
                })
            }
        }else{
            let param = ["action":"add-deal-as-favorite",
                         "user_id":UserData.shared.getUser()!.user_id,
                         "deal_id":strId]
            
            Modal.shared.addDealToFavorite(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.callDealDetail()
                })
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewReportAbuse.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickReport(_ sender: UIButton) {
        if txtDesc.text == ""{
            self.alert(title: "", message: "please enter description to report")
        }else{
        let param = ["action":"report-abuse",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "deal_id":strId,
                     "message":txtDesc.text!]
            
            Modal.shared.reportAbuse(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                    self.viewReportAbuse.isHidden = true
                    self.navigationBar.isHidden = false
                    self.dealDeatil = nil
                    self.callDealDetail()
                    
                })
            }
        }
    }
    @IBAction func onClickReportAbuse(_ sender: UIButton) {
        viewReportAbuse.isHidden = false
        self.navigationBar.isHidden = true
        
    }
    
    @IBAction func onClickFB(_ sender: UIButton) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToFacebook]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickTwitter(_ sender: UIButton) {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.postToTwitter]
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickInstagram(_ sender: UIButton) {
       let instagramURL = NSURL(string: "instagram://app")
        
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let imageView = UIImageView()
            imageView.downLoadImage(url: (dealDeatil?.imageList[0].dealImage)!)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let saveImagePath = (documentsPath as NSString).appendingPathComponent("Image.igo")
            let imageData = imageView.image!.pngData()
            do {
                
                try imageData?.write(to: URL(fileURLWithPath: saveImagePath), options: NSData.WritingOptions(rawValue: 0))
            } catch {
                print("Instagram sharing error")
            }
        }
        else {
            print("Instagram not found")
        }
        
        
    }
    @IBAction func onClickBuyDeal(_ sender: UIButton) {
    }
    @IBAction func onClickAddToCart(_ sender: UIButton) {
        if isSelectedOption == false{
            self.alert(title: "", message: "please select deal option")
        }else{
            let param = ["user_id":UserData.shared.getUser()!.user_id,
                         "deal_id":strId,
            "deal_option_id":selectedDealOption!.option_id] as! [String:String]
            
            Modal.shared.addToCart(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                    
                })
            }
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
extension DealDetailVC:SFSafariViewControllerDelegate{
    
}
extension DealDetailVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Manage Deals", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension DealDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealDeatil?.similarDealList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByDealCell.identifier, for: indexPath) as? NearByDealCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
        cell.layer.borderWidth = 1.0
        cell.lblDistance2.isHidden = true
        cell.viewRound2.isHidden = true
        cell.btnFavorite.isHidden = true
        cell.viewRound.isHidden = true
        cell.lblDistance.isHidden = true
        let data = dealDeatil?.similarDealList[indexPath.row]
        cell.lblCategory.text = (data?.categoryName)! + " & " + (data?.subcategoryName)!
       cell.lblDealName.text = data?.deal_title
        cell.imgDeal.downLoadImage(url: (data?.dealImages)!)
        
       return cell
        
    }
    
    @objc func onClickUnsubscribe(_ sender:UIButton){
        
    }
    
    func setAutoHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.collectionViewHeightconst.constant = self.collectionViewDeal.contentSize.height
            self.collectionViewDeal.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width / 2 - 5 ), height: 230)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
        self.collectionViewHeightconst.constant = self.collectionViewDeal.contentSize.height
        }
    }

    
}
extension DealDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblReviews {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewProfileCell.identifier) as? ReviewProfileCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.lblUserName.text = dealDeatil?.reviewsList[indexPath.row].customer_name
        cell.lblDate.text = dealDeatil?.reviewsList[indexPath.row].reviewPostedOn
            cell.rateView.rating = (dealDeatil?.reviewsList[indexPath.row].review_rating! as NSString?)?.doubleValue ?? 0.0
            cell.imgUser.downLoadImage(url: (dealDeatil?.reviewsList[indexPath.row].customer_profile)!)
              cell.lblReview.text = dealDeatil?.reviewsList[indexPath.row].review_description
        return cell
    }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DealDetailOptionCell.identifier) as? DealDetailOptionCell else {
                fatalError("Cell can't be dequeue")
            }
            if selectedOption != indexPath.row{
                cell.viewContent.backgroundColor = UIColor.white
                cell.lblPrice.textColor = UIColor.black
                cell.lblDiscountPrice.textColor = UIColor.init(hexString: "E0171E")
                cell.lblDiscount.textColor = UIColor.init(hexString: "E0171E")
                cell.lblDealTitle.textColor = UIColor.init(hexString: "E0171E")
                
                 cell.viewLine.backgroundColor = UIColor.init(hexString: "E0171E")
            }else{
                cell.viewContent.backgroundColor = UIColor.init(hexString: "E0171E")
                cell.lblDiscountPrice.textColor = UIColor.white
                cell.lblDiscount.textColor = UIColor.white
                cell.lblDealTitle.textColor =  UIColor.white
               cell.viewLine.backgroundColor = UIColor.white
                cell.lblPrice.textColor = UIColor.white
                  }
            cell.lblDealTitle.text = dealDeatil?.optionList[indexPath.row].option_title
            cell.lblPrice.text = String(format: "%@ %@",(UserData.shared.getUser()?.currency) ?? "$",(dealDeatil?.optionList[indexPath.row].option_price)!)
            cell.lblDiscountPrice.text = String(format: "%@ %@",(UserData.shared.getUser()?.currency) ?? "$",(dealDeatil?.optionList[indexPath.row].discount_price)!)
            cell.lblDiscount.text = String(format: "%@ %% off", (dealDeatil?.optionList[indexPath.row].option_discount)!)
            return cell
    }
    }
    
    func setAutoHeighttbl() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            
            self.heightConst.constant = self.tblReviews.contentSize.height
            self.tblReviews.layoutIfNeeded()
            
            self.tblOptionHeightConst.constant = self.tblDealOption.contentSize.height
            self.tblDealOption.layoutIfNeeded()
        
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblReviews{
        return dealDeatil?.reviewsList.count ?? 0
        }else{
        return dealDeatil?.optionList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblReviews {
            self.heightConst.constant = self.tblReviews.contentSize.height
        }else{
            self.tblOptionHeightConst.constant = self.tblDealOption.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblDealOption{
            isSelectedOption = true
            selectedOption = indexPath.row
            tblDealOption.reloadData()
            selectedDealOption = dealDeatil?.optionList[indexPath.row]
        }
    }
   
}
