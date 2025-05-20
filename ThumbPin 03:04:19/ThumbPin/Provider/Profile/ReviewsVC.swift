//
//  ReviewsVC.swift
//  ThumbPin
//
//  Created by NCT109 on 03/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ReviewsVC: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var viewTableview: UIView!
    @IBOutlet weak var conTblvwReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tblvwReview: UITableView!{
        didSet{
            tblvwReview.delegate = self
            tblvwReview.dataSource = self
            tblvwReview.register(ReviewsCell.nib, forCellReuseIdentifier: ReviewsCell.identifier)
            //tblvwReview.rowHeight  = UITableViewAutomaticDimension
            //tblvwReview.estimatedRowHeight = 130
            tblvwReview.separatorStyle = .singleLine
        }
    }
    var pageNo = 1
    var reviewList = ReviewsList()
    var arrReview = [ReviewsList.Reviews]()
    var selectedIndex: Int!
    var userType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userIdCustomerBusiness.isEmpty {
            userIdCustomerBusiness = UserData.shared.getUser()!.user_id
            userType = UserData.shared.getUser()!.user_type
            
        }else {
            userType = "2"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isConnectedToInternet {
            print("Yes! internet is available.")
            callApiGetReview()
        }else {
            print("No! internet is available.")
            pageNo = 1
            let dict = retrieveFromJsonFile()
            self.arrReview = ResponseKey.fatchData(res: dict, valueOf: .user_review).ary.map({ReviewsList.Reviews(dic: $0 as! [String:Any])})
            self.showData()
        }
        //NotificationCenter.default.post(name: .setContainerHeight, object:
        //    ["containerHeight":self.scrollview.contentSize.height] as [String:Any])
        //NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":self.scrollview.contentSize.height], userInfo: nil)
    }
    func callApiGetReview() {
        let dictParam = [
            "action": Action.review,
            "lId": UserData.shared.getLanguage,
            "user_type": userType,
            "user_id": userIdCustomerBusiness,
            "page": pageNo
        ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.tblvwReview.backgroundView = bgImage
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.reviewList = ReviewsList(dic: dict)
            if self.pageNo > 1 {
                self.arrReview.append(contentsOf: self.reviewList.arrReviews)
            }else {
                self.arrReview.removeAll()
                self.arrReview = self.reviewList.arrReviews
            }
            self.showData()            
        }
    }
    func callApiFlagReview(_ flagId: String) {
        let dictParam = [
            "action": Action.setStatus,
            "lId": UserData.shared.getLanguage,
            "flag_type": "review",
            "user_id": UserData.shared.getUser()!.user_id,
            "page": pageNo,
            "flag_id": flagId,
        ] as [String : Any]
        ApiCaller.shared.setFlagStatus(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            if self.arrReview[self.selectedIndex].isFlag == "y" {
                self.arrReview[self.selectedIndex].isFlag = "n"
            }else {
                self.arrReview[self.selectedIndex].isFlag = "y"
            }
            self.tblvwReview.reloadData()
        }
    }
    func showData() {
        self.tblvwReview.reloadData()
       // self.tblvwReview.layoutIfNeeded()
     //   self.conTblvwReviewHeight.constant = self.tblvwReview.contentSize.height
       // DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
       //     self.conTblvwReviewHeight.constant = self.tblvwReview.contentSize.height
         //   self.tblvwReview.layoutIfNeeded()
           // print(self.conTblvwReviewHeight.constant)
            //print(self.scrollview.contentSize.height)
            //NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":self.scrollview.contentSize.height], userInfo: nil)
        //}
        //            self.viewTableview.layoutIfNeeded()
        //            self.viewTableview.layoutSubviews()
        //            self.viewTableview.setNeedsLayout()
        // self.scrollview.contentSize.height = self.tblvwReview.contentSize.height + 20
        //  self.view.layoutIfNeeded()
      //  DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
           // NotificationCenter.default.post(name: .setContainerHeight, object:
            //    ["containerHeight":self.scrollview.contentSize.height] as [String:Any])
//            NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":self.scrollview.contentSize.height], userInfo: nil)
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func pressButtonFlag(_ sender: UIButton) {
        selectedIndex = sender.tag
        callApiFlagReview(arrReview[sender.tag].reviewId)
    }
    // MARK: - Button Action

}
extension ReviewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.identifier) as? ReviewsCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrReview[indexPath.row].service_title
        cell.lblUserName.text = "By (\(arrReview[indexPath.row].user_name))"
        cell.labelDescription.text = arrReview[indexPath.row].review_desc
        cell.labelTime.text = arrReview[indexPath.row].review_date_time
        cell.labelRating.text = String(Double(arrReview[indexPath.row].user_rating))
        if let strUrl = arrReview[indexPath.row].user_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            cell.imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            cell.imgvwProfile.sd_setShowActivityIndicatorView(true)
            cell.imgvwProfile.sd_setIndicatorStyle(.gray)
        }
        if arrReview[indexPath.row].isFlag == "y" {
            cell.btnFlagThisReview.setTitle("  \(localizedString(key: "Remove from flag"))  ", for: .normal)
        }else {
            cell.btnFlagThisReview.setTitle("  \(localizedString(key: "Flag this review"))  ", for: .normal)
        }
        cell.btnFlagThisReview.tag = indexPath.row
        cell.btnFlagThisReview.addTarget(self, action: #selector(self.pressButtonFlag(_:)), for: .touchUpInside)
        cell.btnFlagThisReview.setImage(#imageLiteral(resourceName: "Gray_Flag"), for: .normal)
        if arrReview[indexPath.row].isFlag == "y" {
            cell.btnFlagThisReview.setImage(#imageLiteral(resourceName: "Orange_Flag"), for: .normal)
        }
        if UserData.shared.getUser()!.user_type == "1" {
            cell.btnFlagThisReview.isHidden = true
        }else {
            cell.btnFlagThisReview.isHidden = false
        }
        cell.communicationreview.rating = Double(arrReview[indexPath.row].communication_rating) ?? 0.0
        cell.productReview.rating = Double(arrReview[indexPath.row].material_service_quantity_rating) ?? 0.0
        cell.deliveryreview.rating = Double(arrReview[indexPath.row].delivery_on_time_rating) ?? 0.0
        cell.selectionStyle = .none
        cell.updateConstraints()
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReview.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrReview.count - 1
        let page = reviewList.pagination.current_page
        let numPages = reviewList.pagination.total_pages
        let totalRecords = reviewList.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiGetReview()
           // showData()
        }
    }
}
