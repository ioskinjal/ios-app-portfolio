//
//  ManageEventTC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageEventTC: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblEventNm: LabelBold!
    @IBOutlet weak var lblTicketSold: LabelRegular!
    @IBOutlet weak var lblDate: LabelRegular!
    @IBOutlet weak var btnMore: UIButton!
    
    var parentVC:ManageEventsListVC?
    var upcomingData:EventList?{
        didSet{
            showUpcomingData()
        }
    }
    
    func showUpcomingData(){
        if let upcomingData = upcomingData{
            lblEventNm.text = upcomingData.title
            lblTicketSold.text = "\(upcomingData.totaleventbooked) " + "Tickets Sold".localized
            imgView.downLoadImage(url: upcomingData.logo)
            if let startDt = upcomingData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                lblDate.text = dateformatter.string(from: startDt)
            }else{
                lblDate.text = "N/A".localized
            }
            
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = DateFormatter.appDateTimeFormat//"yyyy-MM-dd HH:mm:ss"
//            // let array = cellData.event_start_time.components(separatedBy: " ")
//            var str:String = upcomingData.event_start_time
//
//            if let date = dateformatter.date(from:str){
//                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
//                str = dateformatter.string(from: date)
//                lblDate.text = str
//            }
            
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
    @IBAction func onClickMore(_ sender: UIButton) {
        if let selectedTab = parentVC?.selectedTab{
            switch selectedTab{
            case .upComing:
                if upcomingData?.totaleventbooked == "0"{
                    let alert = UIAlertController(title: "Upcoming Events", message: "Please Select an Option", preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "Invite", style: .default , handler:{ (UIAlertAction)in
                        let nextVC = SelectInviteeVC.storyboardInstance
                        nextVC.delegateContact = self
                        nextVC.isFromManageEvents = true
                        self.parentVC?.present(nextVC, animated: true)
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
                        let nextVC = CreateEventsVC.storyboardInstance
                        nextVC.isEditMode = true
                        let data = self.upcomingData?.dictionaryRepresentation()
                        nextVC.eventData = CreateEvent(with: data ?? [String:Any]())
                        self.parentVC?.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
                        self.callRemoveEvent()
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                        
                    }))
                    
                    parentVC!.present(alert, animated: true, completion: {
                        
                    })
                }else{
                    let alert = UIAlertController(title: "Upcoming Events", message: "Please Select an Option", preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "Invite", style: .default , handler:{ (UIAlertAction)in
                        let nextVC = CreateEventsVC.storyboardInstance
                        nextVC.isEditMode = true
                        let data = self.upcomingData?.dictionaryRepresentation()
                        nextVC.eventData = CreateEvent(with: data ?? [String:Any]())
                        self.parentVC?.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                        
                    }))
                    
                    parentVC!.present(alert, animated: true, completion: {
                        
                    })
                }
            case .past:
                let alert = UIAlertController(title: "Past Events", message: "Please Select an Option", preferredStyle: .actionSheet)
                
                
                alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
                    self.callRemoveEvent()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                    
                }))
                
                parentVC!.present(alert, animated: true, completion: {
                    
                })
                
            case .draft:
                let alert = UIAlertController(title: "Draft Events", message: "Please Select an Option", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
                    let nextVC = CreateEventsVC.storyboardInstance
                    nextVC.isEditMode = true
                    let data = self.upcomingData?.dictionaryRepresentation()
                    nextVC.eventData = CreateEvent(with: data ?? [String:Any]())
                    self.parentVC?.navigationController?.pushViewController(nextVC, animated: true)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
                    self.callRemoveEvent()
                    
                }))
                
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                    
                }))
                
                parentVC!.present(alert, animated: true, completion: {
                    
                })
            }
        }
        
        
    }
    
    func callRemoveEvent(){
        let alert = UIAlertController(title: "Remove Flyers", message: "Are You sure you want to remove this event ?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            let param = ["userid":UserData.shared.getUser()!.userid,
                         "event_id":self.upcomingData!.id] as [String : Any]
            
            API.shared.call(with: .deleteMyCreatedEvents, viewController: self.parentVC, param: param) { (dic) in
                
                let str = Response.fatchDataAsString(res: dic, valueOf: .message)
                let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.parentVC!.present(alert, animated: true, completion: {
                    self.parentVC?.upcomingObj = nil
                    self.parentVC?.UpcomingList = []
                    
                    self.parentVC?.getUpcomingEvents()
                })
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
        }))
        parentVC?.present(alert, animated: true, completion: nil)
    }
    
}


extension ManageEventTC:SelectedInviteSingle{
    func selectedContact(_ contact: MyContactCls.List) {
        callInvite(contatct:contact)
    }
    
    func callInvite(contatct:MyContactCls.List){
        let param:dictionary = ["userid":UserData.shared.getUser()!.userid,
            "event_id":upcomingData!.id,
            "contact_id":contatct.id]
        
        API.shared.call(with: .inviteContact, viewController: parentVC, param: param) { (response) in
            let message = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
            UIApplication.alert(title: "", message: message)
        }
    }
    
    
}
