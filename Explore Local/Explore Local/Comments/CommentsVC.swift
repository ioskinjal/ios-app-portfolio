//
//  CommentsVC.swift
//  Explore Local
//
//  Created by admin on 1/10/19.
//  Copyright © 2019 NCrypted. All rights reserved.
//

import UIKit

class CommentsVC: BaseViewController {

    static var storyboardInstance:CommentsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: CommentsVC.identifier) as? CommentsVC
    }
    
    @IBOutlet weak var lblNodata: UILabel!
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
 
    var reviewList = [CommentCls.ReviewList]()
    var reviewObj: CommentCls?
    var strBusiness_id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        callCommentsAPI()
        setUpUI()
        
    }
    
    func callCommentsAPI(){
         let nextPage = (reviewObj?.pagination?.current_page ?? 0 ) + 1
        let param = ["action":"reviews",
                     "business_id":strBusiness_id,
                     "user_id":UserData.shared.getUser()?.user_id ?? "",
                     "page":nextPage] as [String : Any]
        
        Modal.shared.businessDetail(vc: self, param: param) { (dic) in
            self.reviewObj = CommentCls(dictionary: dic)
            if self.reviewList.count > 0{
                self.reviewList += self.reviewObj!.reviewsList
            }
            else{
                self.reviewList = self.reviewObj!.reviewsList
            }
            if self.reviewList.count != 0{
            self.tblComments.reloadData()
            }else{
                self.lblNodata.isHidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle:"Messages", action: #selector(onClickMenu(_:)))
        let user = UserData.shared.getUser()
        if user?.user_type == "1" {
            setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Messages", action: #selector(onClickMenu(_:)))
        }
        
    }
    @objc func onClickSearch() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickMenu(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if reviewList[indexPath.row].comment == "" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            if reviewList[indexPath.row].reported == "n" {
                cell.btnFlag.tag = indexPath.row
                cell.btnFlag.addTarget(self, action: #selector(onClickFlag(_:)), for: .touchUpInside)
            }else{
                cell.btnFlag.isHidden = true
            }
            cell.lblname.text = reviewList[indexPath.row].user_name
            cell.lblComment.text = reviewList[indexPath.row].review_description
            let rate:String = reviewList[indexPath.row].rating!
            cell.viewRate.rating = Double(rate)!
            
            let startDate = reviewList[indexPath.row].posted_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatedStartDate = dateFormatter.date(from: startDate! )
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
            
            cell.imgView.downLoadImage(url: reviewList[indexPath.row].user_image!)
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentReplyCell.identifier) as? CommentReplyCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .none
            cell.lblComment.text = reviewList[indexPath.row].comment
            cell.lblName.text = reviewList[indexPath.row].user_name
            
            let startDate = reviewList[indexPath.row].posted_date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatedStartDate = dateFormatter.date(from: startDate! )
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
            
            cell.imgView.downLoadImage(url: reviewList[indexPath.row].user_image!)
            return cell
        }
    }
    
    @objc func onClickFlag(_ sender:UIButton){
        if sender.currentImage == #imageLiteral(resourceName: "Flag"){
            let param = ["action":"report_review",
                         "business_id":strBusiness_id,
                         "user_id":UserData.shared.getUser()!.user_id,
                         "review_id":reviewList[sender.tag].review_id!]
            Modal.shared.businessDetail(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    
                })
            }
        }else{
            
        }
        
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
}
