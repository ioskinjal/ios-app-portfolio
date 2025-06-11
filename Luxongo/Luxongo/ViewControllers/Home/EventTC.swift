//
//  EventTC.swift
//  Luxongo
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EventTC: UITableViewCell {
    
    
    @IBOutlet weak var btnfavorite: UIButton!
    @IBOutlet weak var btnMore: UIButton!{
        didSet{
            self.btnMore.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblEventNm: LabelBold!
    @IBOutlet weak var lblLocation: LabelRegular!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblPrice: LabelSemiBold!{
        didSet{
            lblPrice.setCornerRadious(withRadious: 5.0, cornerBorderSides: [.topRight,.bottomRight])
        }
    }
    @IBOutlet weak var lblDate: LabelRegular!
    
    var popularData:EventList?
    var parentVC:HomeVC?
    var parentVCViewMore:ViewMoreHomeEventsVC?
    var parentVCMyevents:MyEventsListVC?
    var parentVCSimilarEvents:EventSimilarVC?
    
    
    var indexPath:IndexPath?
    var cellData: EventList?{
        didSet{
            loadCellUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func loadCellUI() {
        if let cellData = self.cellData{
            //print("EventImage: \(cellData.logo)")
            lblEventNm.text = cellData.title
            lblLocation.text = cellData.add_line_1
            imgEvent.downLoadImage(url: cellData.logo)
            if let startDt = cellData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                lblDate.text = dateformatter.string(from: startDt)
            }else{
                lblDate.text = "N/A".localized
            }
            lblPrice.text = (cellData.ticket_price_type == "f" ? "Free" : cellData.minticketamount)
            btnfavorite.setImage((cellData.is_user_like == "y" ? #imageLiteral(resourceName: "ic_liked") : #imageLiteral(resourceName: "ic_unliked")), for: .normal)
            
        }
    }
    
    func showPopularData(){
        lblEventNm.text = popularData?.title
        lblLocation.text = popularData?.add_line_1
        imgEvent.downLoadImage(url: popularData?.logo ?? "")
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        // let array = cellData.event_start_time.components(separatedBy: " ")
//        var str:String = popularData?.event_start_time ?? ""
//
//        // dateformatter.dateFormat = "dd MMM, yyyy"
//        let date = dateformatter.date(from:str )
//        // let str1:String = array[1]
//        dateformatter.dateFormat = "dd MMM, yyyy | HH:mm"
//
//        str = dateformatter.string(from: date!)
//        //            let date1 = dateformatter.date(from: str)
//        //            dateformatter.dateFormat = "HH:mm"
//
//        lblDate.text = str
        
        if let popularData = self.popularData, let startDt = popularData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
            self.lblDate.text = dateformatter.string(from: startDt)
        }else{
            self.lblDate.text = "N/A".localized
        }
        
        if popularData?.minticketamount == "$0"{
            lblPrice.text = "Free"
        } else{
            lblPrice.text = popularData?.minticketamount
        }
        btnfavorite.setImage((popularData?.is_user_like == "y" ? #imageLiteral(resourceName: "ic_liked") : #imageLiteral(resourceName: "ic_unliked")), for: .normal)
       if parentVCMyevents?.navTitle == "Saved Flyers"{
        btnfavorite.setImage(#imageLiteral(resourceName: "ic_liked"), for: .normal)
        }
    }
    
    @IBAction func onClickMore(_ sender: UIButton) {
        if parentVCMyevents != nil{
            let alert = UIAlertController(title: "Saved Events", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Remove Flyers", style: .default , handler:{ (UIAlertAction)in
                self.callRemoveEvent()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            parentVCMyevents!.present(alert, animated: true, completion: {
                
            })
        }else if parentVC != nil{
            let alert = UIAlertController(title: "Popular Events", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction)in
                let googleUrlString = self.popularData?.event_detail_share_url
                if let googleUrl = NSURL(string: googleUrlString!) {
                    // show alert to choose app
                    if UIApplication.shared.canOpenURL(googleUrl as URL) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(googleUrl as URL)
                        }
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            parentVC!.present(alert, animated: true, completion: {
                
            })
        }
        else if parentVCViewMore != nil{
            
            let alert = UIAlertController(title: parentVCViewMore?.navTitle, message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction)in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            parentVCViewMore!.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    func callRemoveEvent(){
        let alert = UIAlertController(title: "Remove Flyers", message: "Are You sure you want to remove this event ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            let param:dictionary = ["userid":UserData.shared.getUser()!.userid,
                         "event_slug":self.popularData?.slug ?? ""]
            
            API.shared.call(with: .removeSavedEvents, viewController: self.parentVCMyevents, param: param) { (dic) in
                
                let str = Response.fatchDataAsString(res: dic, valueOf: .message)
                let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.parentVCMyevents?.present(alert, animated: true, completion: {
                    self.parentVCMyevents?.savedObj = nil
                    self.parentVCMyevents?.savedList = [EventList]()
                    
                    self.parentVCMyevents?.getSavedEvents()
                })
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
        }))
        parentVCMyevents!.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickMapPin(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickFav(_ sender: UIButton) {
        callUnFavApi()
    }
    
    
    func callUnFavApi(){
        if let cellData = self.cellData, let user = UserData.shared.getUser(),
            let indexPath = self.indexPath, let parentVC = self.viewController as? SearchResultListVC{
            let param:dictionary = ["userid":user.userid,
                                    "event_slug":cellData.slug]
            API.shared.call(with: .favUnFav, viewController: parentVC, param: param) { (dic) in
                cellData.is_user_like = ResponseHandler.fatchDataAsString(res: dic, valueOf: .is_user_like)
                parentVC.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }/*
        else if let cellData = self.cellData, let user = UserData.shared.getUser(),
            let indexPath = self.indexPath, let parentVC = self.viewController as? HomeVC{
            let param:dictionary = ["userid":user.userid,
                                    "event_slug":cellData.slug]
            API.shared.call(with: .favUnFav, viewController: parentVC, param: param) { (dic) in
                cellData.is_user_like = ResponseHandler.fatchDataAsString(res: dic, valueOf: .is_user_like)
                parentVC.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }*/
        else if let cellData = self.cellData, let user = UserData.shared.getUser(),
            let indexPath = self.indexPath, let parentVC = self.viewController as? EventSimilarVC{
            let param:dictionary = ["userid":user.userid,
                                    "event_slug":cellData.slug]
            API.shared.call(with: .favUnFav, viewController: parentVC, param: param) { (dic) in
                cellData.is_user_like = ResponseHandler.fatchDataAsString(res: dic, valueOf: .is_user_like)
                parentVC.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        else{
            let param:dictionary = ["userid":UserData.shared.getUser()!.userid,
                                    "event_slug":popularData?.slug ?? ""]
            /*
            if parentVC != nil{
                API.shared.call(with: .favUnFav, viewController: parentVC, param: param) { (dic) in
                    self.parentVC?.popularEventObj = nil
                    self.parentVC?.popularEventList = [EventList]()
                    self.parentVC?.getPopularEvents()
                }
            }else*/
            if parentVCViewMore != nil{
                API.shared.call(with: .favUnFav, viewController: parentVCViewMore, param: param) { (dic) in
                    self.parentVCViewMore?.eventObj = nil
                    self.parentVCViewMore?.eventList = [EventList]()
                    
                    if   self.parentVCViewMore?.navTitle == "Upcoming Events"{
                        self.parentVCViewMore?.getUpcomingEvents()
                    }else{
                        self.parentVCViewMore?.getPopularEvents()
                    }
                }
            }else if parentVCMyevents != nil{
                API.shared.call(with: .favUnFav, viewController: parentVCMyevents, param: param) { (dic) in
                  
                  
                    if self.parentVCMyevents?.navTitle == "My Flyers"{
                       
                        self.parentVCMyevents?.callAPI()
                    }else{
                        self.parentVCMyevents?.callFavApi()
                    }
                   
                }
            }else{
                API.shared.call(with: .favUnFav, viewController: parentVCSimilarEvents, param: param) { (dic) in
                    self.parentVCSimilarEvents?.similarObj = nil
                    self.parentVCSimilarEvents?.similarList = [EventList]()
                    
                    self.parentVCSimilarEvents?.getSimilarEvents()
                }
            }
        }
        
        
    }
    
    
}
