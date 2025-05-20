//
//  ReceivedReviewsListVC.swift
//  Explore Local
//
//  Created by NCrypted on 14/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class ReceivedReviewsListVC: BaseViewController {

    static var storyboardInstance: ReceivedReviewsListVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ReceivedReviewsListVC.identifier) as? ReceivedReviewsListVC
    }
    
    @IBOutlet weak var txtReply: UITextView!{
        didSet{
            txtReply.placeholder = "Reply"
            txtReply.border(side: .bottom, color: .lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var viewReply: UIView!
    @IBOutlet weak var tblReviews: UITableView!{
        didSet{
            tblReviews.register(ReceivedReviewCell.nib, forCellReuseIdentifier: ReceivedReviewCell.identifier)
            tblReviews.dataSource = self
            tblReviews.delegate = self
            tblReviews.tableFooterView = UIView()
            tblReviews.separatorStyle = .none
        }
    }
    
    var businessList = [PostedReviewsCls.ReviewList]()
    var favouriteObj: PostedReviewsCls?
    var strReview_id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Received Reviews & Ratings", action: #selector(onClickMenu(_:)))
       callReceivedReview()
    }
    
    func callReceivedReview(){
        let nextPage = (favouriteObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"received_reviews",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page":nextPage] as [String : Any]
        Modal.shared.postedBusiness(vc: self, param: param) { (dic) in
            self.favouriteObj = PostedReviewsCls(dictionary: dic)
            if self.businessList.count > 0{
                self.businessList += self.favouriteObj!.reviewList
            }
            else{
                self.businessList = self.favouriteObj!.reviewList
            }
            self.tblReviews.reloadData()
        }
    }

    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickReplybtn(_ sender: UIButton) {
        var ErrorMsg = ""
        
        if txtReply.text.isEmpty {
            ErrorMsg = "please enter reply"
        }else{
        let param = ["action":"reply_review",
                     "reply_text":txtReply.text!,
                     "review_id":strReview_id]
        Modal.shared.postedBusiness(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
            self.viewReply.isHidden = true
                self.navigationBar.isHidden = false
                self.callReceivedReview()
            })
        }
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
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
extension ReceivedReviewsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedReviewCell.identifier) as? ReceivedReviewCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
        
        cell.lblBusinessName.text = businessList[indexPath.row].business_name
        cell.lblReview.text = businessList[indexPath.row].review_description
        cell.rateView.rating = Double(businessList[indexPath.row].rating!)!
        cell.rateView.isUserInteractionEnabled = false
        cell.lblLocation.text = businessList[indexPath.row].location
        cell.imgBusiness.downLoadImage(url: businessList[indexPath.row].image!)
        cell.imgReview.downLoadImage(url: businessList[indexPath.row].reviewer_image!)
        
        let startDate = businessList[indexPath.row].posted_date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: startDate!)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.day, .month, .year,.weekday,.second,.minute,.hour])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        
        print (differenceOfDate)
        if differenceOfDate.minute == 0 {
            cell.lblRate.text = String(format: "updated %d seconds ago", differenceOfDate.second!)
        }else if differenceOfDate.hour == 0 {
            cell.lblRate.text = String(format: "updated %d minutes ago", differenceOfDate.minute!)
        }else if differenceOfDate.day == 0 {
            cell.lblRate.text = String(format: "updated %d hours ago", differenceOfDate.hour!)
        }else if differenceOfDate.weekday == 0 {
            cell.lblRate.text = String(format: "updated %d days ago", differenceOfDate.day!)
        }else if differenceOfDate.month == 0 {
            cell.lblRate.text = String(format: "updated %d weeks ago", differenceOfDate.weekday!)
        }else if differenceOfDate.year == 0 {
            cell.lblRate.text = String(format: "updated %d months ago", differenceOfDate.month!)
        }else {
            cell.lblRate.text = String(format: "updated %d years ago", differenceOfDate.year!)
        }
      //  cell.lblMerchantReply.text =
        cell.lblUsername.text = businessList[indexPath.row].reviewer_name
        if businessList[indexPath.row].is_replied == "n"{
        cell.btnReply.tag = indexPath.row
        cell.btnReply.isHidden = false
        cell.btnReply.addTarget(self, action: #selector(onClickReply(_:)), for: .touchUpInside)
        }else{
            cell.btnReply.setTitle("Replied", for: .normal)
            cell.lblMerchantReply.text = businessList[indexPath.row].merchant_reply_message
        }
        if businessList[indexPath.row].is_approved == "approved"{
            if businessList[indexPath.row].is_active == "y"{
                cell.lblStatus.text = "Approved & Visible"
                cell.lblView.backgroundColor = UIColor.init(hexString: "52B052")
            }else{
                cell.lblStatus.text = "Invisible by Administrator"
                cell.lblView.backgroundColor = UIColor.red
            }
        }else if businessList[indexPath.row].is_approved == "reject"{
            cell.lblStatus.text = "Rejected"
            cell.lblView.backgroundColor = UIColor.red
        }else if businessList[indexPath.row].is_approved == "pending"{
            cell.lblStatus.text = "Approval pending by Administrator"
            cell.lblView.backgroundColor = UIColor.init(hexString: "DB9D2B")
        }
        
        
        
        
        return cell
    }
    
    @objc func onClickReply(_ sender:UIButton){
        strReview_id = businessList[sender.tag].review_id!
        viewReply.isHidden = false
        self.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        reloadMoreData(indexPath: indexPath)
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if businessList.count - 1 == indexPath.row &&
            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
            self.callReceivedReview()
        }
    }
    
    
}
