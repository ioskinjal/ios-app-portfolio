//
//  ReviewsVC.swift
//  XPhorm
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReviewsVC: BaseViewController {

    static var storyboardInstance:ReviewsVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ReviewsVC.identifier) as? ReviewsVC
    }
    
    
    @IBOutlet weak var viewGivenReviews: UIView!
    @IBOutlet weak var ViewReceivedReviews: UIView!
    @IBOutlet weak var btnGivenReviews: UIButton!
//        {
//        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.btnGivenReviews.addBorder(side: .bottom, color: #colorLiteral(red: 0.2352941176, green: 0.1568627451, blue: 0.3803921569, alpha: 1), width: 2)
//            }
//        }
//    }
    @IBOutlet weak var btnReceivedReviews: UIButton!
//        {
//        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.btnReceivedReviews.addBorder(side: .bottom, color: #colorLiteral(red: 0.2352941176, green: 0.1568627451, blue: 0.3803921569, alpha: 1), width: 2)
//
//            }
//        }
//    }
    
  
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
        }
    }
    @IBOutlet weak var tblGivenReviews: UITableView!{
        didSet{
            tblGivenReviews.dataSource = self
            tblGivenReviews.delegate = self
            tblGivenReviews.tableFooterView = UIView()
            tblGivenReviews.setRadius(10.0)
            tblGivenReviews.separatorStyle = .none
            
        }
    }
    @IBOutlet weak var tblReceivedReviews: UITableView!{
        didSet{
            tblReceivedReviews.dataSource = self
            tblReceivedReviews.delegate = self
            tblReceivedReviews.tableFooterView = UIView()
            tblReceivedReviews.setRadius(10.0)
            tblReceivedReviews.separatorStyle = .none
        }
    }
   
    var receivedReviewList = [ReceivedReviewCls.ReviewList]()
    var receiveObj: ReceivedReviewCls?
    var givenReviewList = [ReceivedReviewCls.ReviewList]()
    var givenObj: ReceivedReviewCls?
    var totalWidth:Float = 0.0
      var lastContentOffset:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "My Reviews".localized, action: #selector(onClickBack(_:)))
        totalWidth = Float(UIScreen.main.bounds.size.width * 2)
        onClickReceivedReviews(btnReceivedReviews)
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func onClickGivenReviews(_ sender: UIButton) {
        self.getGivenReviews()
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(UIScreen.main.bounds.size.width), y: 0)
            , animated: true)
        
    }
    
    @IBAction func onClickReceivedReviews(_ sender: UIButton) {
        self.getReceivedReviews()
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        btnReceivedReviews.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
        btnGivenReviews.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
        
    }
    
    func getGivenReviews(){
        let nextPage = (receiveObj?.pagination?.page ?? 0 ) + 1
        let param = ["action":"getGivenReview",
                     "id":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "page":nextPage] as [String : Any]
        
        Modal.shared.getGivenReviews(vc: nil, param: param) { (dic) in
            self.givenObj = ReceivedReviewCls(dictionary: dic)
            if self.givenReviewList.count > 0{
                self.givenReviewList += self.givenObj!.reviewList
            }
            else{
                self.givenReviewList = self.givenObj!.reviewList
            }
            self.tblGivenReviews.reloadData()
        }
    }
    
    func getReceivedReviews(){
        let nextPage = (receiveObj?.pagination?.page ?? 0 ) + 1
        let param = ["action":"getReceivedReview",
                     "id":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage,
                     "pageNo":nextPage] as [String : Any]
        
        Modal.shared.getReceivedReviews(vc: nil, param: param) { (dic) in
            self.receiveObj = ReceivedReviewCls(dictionary: dic)
            if self.receivedReviewList.count > 0{
                self.receivedReviewList += self.receiveObj!.reviewList
            }
            else{
                self.receivedReviewList = self.receiveObj!.reviewList
            }
            self.tblReceivedReviews.reloadData()
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
extension ReviewsVC:UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
        //        print(scrollView.contentOffset.x)
        if scrollView.contentOffset.x < ViewReceivedReviews.frame.size.width {
            //            print("left")
            //  self.isSelectedBasicInfo = true
          
            btnReceivedReviews.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
            btnGivenReviews.addBorder(side: .bottom, color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
        } else {
            //   self.isSelectedBasicInfo = false
            
            btnGivenReviews.addBorder(side: .bottom, color: #colorLiteral(red: 0.3037160337, green: 0.2236143649, blue: 0.4564701915, alpha: 1), width: 2)
            btnReceivedReviews.addBorder(side: .bottom, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), width: 2)
            //            print("right")
        }
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
}
extension ReviewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblReceivedReviews{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedReviewCell.identifier) as? ReceivedReviewCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
            cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            let data:ReceivedReviewCls.ReviewList?
            data = receivedReviewList[indexPath.row]
            cell.imgProfile.downLoadImage(url: data?.profileImg ?? "")
            cell.lblName.text = data?.userName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.createdDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateformat.string(from: date ?? Date())
            cell.lblDesc.text = data?.desc
            cell.rateView.rating = (data!.ratting as NSString).doubleValue
            cell.lblRate.text = "(\(String(describing: data!.ratting))/5)"
            cell.lblId.text = data?.bookingId
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GivenReviewCell.identifier) as? GivenReviewCell else {
                fatalError("Cell can't be dequeue")
                
            }
            cell.selectionStyle = .none
             cell.viewContainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            let data:ReceivedReviewCls.ReviewList?
            data = givenReviewList[indexPath.row]
            cell.imgProfile.downLoadImage(url: data?.profileImg ?? "")
            cell.lblName.text = data?.userName
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformat.date(from: data?.createdDate ?? "")
            dateformat.dateFormat = "MM/dd/yyyy"
            cell.lblDate.text = dateformat.string(from: date ?? Date())
            cell.lblDesc.text = data?.desc
            cell.rateView.rating = (data!.ratting as NSString).doubleValue
            cell.lblRate.text = "(\(String(describing: data!.ratting))/5)"
            cell.lblId.text = data?.bookingId
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblReceivedReviews{
        return receivedReviewList.count
        }else{
            return givenReviewList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tblGivenReviews{
            if givenReviewList.count - 1 == indexPath.row &&
                (givenObj!.pagination!.page > givenObj!.pagination!.numPages) {
                self.getGivenReviews()
            }
        }else{
            if receivedReviewList.count - 1 == indexPath.row &&
                (receiveObj!.pagination!.page > receiveObj!.pagination!.numPages) {
                self.getGivenReviews()
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if tableView == tblGivenReviews{
        let nextVC = DashboardVC.storyboardInstance!
        isfromProfile = true
        nextVC.user_id = givenReviewList[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
         }else{
            let nextVC = DashboardVC.storyboardInstance!
            isfromProfile = true
            nextVC.user_id = receivedReviewList[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    
}
