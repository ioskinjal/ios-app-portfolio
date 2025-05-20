//
//  PostedReviewsVC.swift
//  Explore Local
//
//  Created by NCrypted on 08/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class PostedReviewsVC: BaseViewController {

    static var storyboardInstance: PostedReviewsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: PostedReviewsVC.identifier) as? PostedReviewsVC
    }
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblPostedReviews: UITableView!{
        didSet{
            tblPostedReviews.register(PostedBusinessCell.nib, forCellReuseIdentifier: PostedBusinessCell.identifier)
            tblPostedReviews.dataSource = self
            tblPostedReviews.delegate = self
            tblPostedReviews.tableFooterView = UIView()
            tblPostedReviews.separatorStyle = .none
        }
    }
    
    var businessList = [PostedReviewsCls.ReviewList]()
    var favouriteObj: PostedReviewsCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Posted Reviews", action: #selector(onClickMenu(_:)))
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
         callPostedReviews()
    }
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func callPostedReviews(){
        let nextPage = (favouriteObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"posted_reviews",
                     "user_id":UserData.shared.getUser()!.user_id,
                     "page": nextPage] as [String : Any]
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            self.favouriteObj = PostedReviewsCls(dictionary: dic)
            if self.businessList.count > 0{
                self.businessList += self.favouriteObj!.reviewList
            }
            else{
                self.businessList = self.favouriteObj!.reviewList
            }
            if self.businessList.count != 0{
            self.tblPostedReviews.reloadData()
            }else{
                self.lblNoData.isHidden = false
            }
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
extension PostedReviewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostedBusinessCell.identifier) as? PostedBusinessCell else {
            fatalError("Cell can't be dequeue")
        }
        
        cell.selectionStyle = .none
        cell.lblname.text = businessList[indexPath.row].business_name
      cell.lblDesc.text = businessList[indexPath.row].review_description
        cell.rateView.rating = Double(businessList[indexPath.row].average_rating ?? "0.0") ?? 0.0
        cell.rateView.isUserInteractionEnabled = false
        cell.lblPostedDate.text = businessList[indexPath.row].posted_date
        cell.lblUseful.text = "Usefull(" + businessList[indexPath.row].usefull! + ")"
        cell.lblCool.text = "Cool(" + businessList[indexPath.row].cool! + ")"
        cell.lblfunny.text = "Funny(" + businessList[indexPath.row].funny! + ")"
        cell.lblLocation.text = businessList[indexPath.row].location
        cell.btncategory.setTitle(businessList[indexPath.row].category, for: .normal)
        cell.btnSubCategory.setTitle(businessList[indexPath.row].subcategory, for: .normal)
        cell.btnSubCategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        cell.btncategory.layer.borderColor = UIColor.init(hexString: "6367f9").cgColor
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(onClickDelete), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(onclickEdit), for: .touchUpInside)
        cell.btnCool.tag = indexPath.row
        cell.btnUseful.tag = indexPath.row
        cell.btnFunny.tag = indexPath.row
        cell.btnCool.addTarget(self, action: #selector(onClickCool(_:)), for: .touchUpInside)
        cell.btnUseful.addTarget(self, action: #selector(onClickUseful(_:)), for: .touchUpInside)
        cell.btnFunny.addTarget(self, action: #selector(onClickFunny(_:)), for: .touchUpInside)
        cell.imgBusiness.downLoadImage(url: businessList[indexPath.row].image!)
        
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
    
    @objc func onClickCool(_ sender:UIButton){
        
        let param = ["action":"post_opinion",
                     "business_id":businessList[sender.tag].business_id!,
                     "review_id":businessList[sender.tag].review_id!,
                     "type":"c",
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callPostedReviews()
                
            })
        }
    }
    
    @objc func onClickUseful(_ sender:UIButton){
        
        let param = ["action":"post_opinion",
                     "business_id":businessList[sender.tag].business_id!,
                     "review_id":businessList[sender.tag].review_id!,
                     "type":"u",
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callPostedReviews()
                
            })
        }
    }
    
    @objc func onClickFunny(_ sender:UIButton){
        let param = ["action":"post_opinion",
                     "business_id":businessList[sender.tag].business_id!,
                     "review_id":businessList[sender.tag].review_id!,
                     "type":"f",
                     "user_id":UserData.shared.getUser()!.user_id]
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callPostedReviews()
                
            })
        }
    }
    
    
    @objc func onClickDelete (_ sender:UIButton){
        let param = ["action":"delete_review",
                     "user_id":"15",
                     "review_id":businessList[sender.tag].review_id!]
        Modal.shared.inviteFriends(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.callPostedReviews()
            })
        }
    }
    
     @objc func onclickEdit (_ sender:UIButton){
        let parentVC = self
       
        guard let nextVC = ReviewPopUpVC.storyboardInstance else {return}
        nextVC.review = businessList[sender.tag]
         nextVC.parentVC = parentVC
        nextVC.presentAsPopUp(parentVC: parentVC)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
            reloadMoreData(indexPath: indexPath)
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        if businessList.count - 1 == indexPath.row &&
            (favouriteObj!.pagination!.current_page < favouriteObj!.pagination!.total_pages) {
            self.callPostedReviews()
        }
    }
    
}
