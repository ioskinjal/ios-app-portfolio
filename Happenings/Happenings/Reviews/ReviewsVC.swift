//
//  ReviewsVC.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReviewsVC: BaseViewController {

    static var storyboardInstance:ReviewsVC? {
        return StoryBoard.reviews.instantiateViewController(withIdentifier: ReviewsVC.identifier) as? ReviewsVC
    }
    
    @IBOutlet weak var tblReviews: UITableView!{
        didSet{
            tblReviews.register(ReviewCell.nib, forCellReuseIdentifier: ReviewCell.identifier)
            tblReviews.dataSource = self
            tblReviews.delegate = self
            tblReviews.tableFooterView = UIView()
            tblReviews.separatorStyle = .none
        }
    }
    
    var reviewList = [ReviewsCls.ReviewList]()
    var reviewObj: ReviewsCls?
    
    var merchantReviewList = [MerchantReviewsCls.MerchantReviewList]()
    var merchantReviewObj: MerchantReviewsCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setUpUI()
        if UserData.shared.getUser()?.user_type == "c"{
        callReviewsAPI()
        }else{
            callMerchantReviews()
        }
    }
    
    func callMerchantReviews(){
        let nextPage = (merchantReviewObj?.currentPage ?? 0 ) + 1
        let param = ["per_page":10,
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.merchantReviews(vc: self, param: param, failer: { (dic) in
            
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.tblReviews.backgroundView = bgImage
            
        }) { (dic) in
            self.merchantReviewObj = MerchantReviewsCls(dictionary: dic)
            if self.merchantReviewList.count > 0{
                self.merchantReviewList += self.merchantReviewObj!.merchantReviews
            }
            else{
                self.merchantReviewList = self.merchantReviewObj!.merchantReviews
            }
            if self.merchantReviewList.count != 0{
                self.tblReviews.reloadData()
            }
        }
       
    }
    
    func callReviewsAPI(){
        
         let nextPage = (reviewObj?.currentPage ?? 0 ) + 1
        let param = ["action":"posted-reviews",
                     "user_id":"203",
                     "page_no":nextPage] as [String : Any]
        
        Modal.shared.getPostedReviews(vc: self, param: param, failer: { (dic) in
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.tblReviews.backgroundView = bgImage
        }) { (dic) in
            self.reviewObj = ReviewsCls(dictionary: dic)
            if self.reviewList.count > 0{
                self.reviewList += self.reviewObj!.reviews
            }
            else{
                self.reviewList = self.reviewObj!.reviews
            }
            if self.reviewList.count != 0{
                self.tblReviews.reloadData()
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
extension ReviewsVC {
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Reviews", action: #selector(onClickMenu(_:)))
        
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
extension ReviewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier) as? ReviewCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
         if UserData.shared.getUser()?.user_type == "c"{
            
            cell.viewContainer.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            cell.viewContainer.layer.cornerRadius = 2.0
            cell.viewContainer.layer.masksToBounds = true
            cell.lblCat.text = reviewList[indexPath.row].categoryName! + "&" + reviewList[indexPath.row].subcategoryName!
            cell.lblDate.text = reviewList[indexPath.row].reviewPostedOn
            cell.lblReview.text = reviewList[indexPath.row].review_description
            cell.lblDealName.text = reviewList[indexPath.row].deal_title
            cell.lblUsername.text = reviewList[indexPath.row].MerchantName
            cell.rateView.rating = (reviewList[indexPath.row].review_rating! as NSString).doubleValue
            cell.imgMerchant.downLoadImage(url: reviewList[indexPath.row].merchant_profile!)
         }else{
      
            cell.viewContainer.layer.borderColor = UIColor.init(hexString: "CBCBCB").cgColor
            cell.viewContainer.layer.borderWidth = 1.0
            cell.viewContainer.layer.cornerRadius = 2.0
            cell.viewContainer.layer.masksToBounds = true
           // cell.lblCat.text = merchantReviewList[indexPath.row].categoryName! + "&" + merchantReviewList[indexPath.row].subcategoryName!
            cell.lblDate.text = merchantReviewList[indexPath.row].reviewPostedOn
            cell.lblReview.text = merchantReviewList[indexPath.row].review_description
            cell.lblDealName.text = merchantReviewList[indexPath.row].deal_title
            cell.lblUsername.text = merchantReviewList[indexPath.row].customerFirstName! + " " + merchantReviewList[indexPath.row].customerLastName!
            cell.rateView.rating = (merchantReviewList[indexPath.row].review_rating! as NSString).doubleValue
            cell.imgMerchant.downLoadImage(url: merchantReviewList[indexPath.row].customerProfileImg!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserData.shared.getUser()?.user_type == "c"{
        return reviewList.count
        }else{
            return merchantReviewList.count
        }
    }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            reloadMoreData(indexPath: indexPath)
    
    
        }
    
    
        func reloadMoreData(indexPath: IndexPath) {
            if UserData.shared.getUser()?.user_type == "c"{
            if reviewList.count - 1 == indexPath.row &&
                (reviewObj!.currentPage > reviewObj!.TotalPages) {
                self.callReviewsAPI()
            }
            }else{
                if merchantReviewList.count - 1 == indexPath.row &&
                    (merchantReviewObj!.currentPage > merchantReviewObj!.TotalPages) {
                    self.callMerchantReviews()
                }
            }
        }
}
