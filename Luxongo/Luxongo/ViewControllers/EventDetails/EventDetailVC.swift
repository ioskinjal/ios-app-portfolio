//
//  EventDetailVC.swift
//  Luxongo
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EventDetailVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:EventDetailVC {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: EventDetailVC.identifier) as! EventDetailVC
    }
    
    @IBOutlet weak var lblWebsite: LabelRegular!
    @IBOutlet weak var lblDesc: LabelRegular!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
            self.lblDesc.isUserInteractionEnabled = true
            self.lblDesc.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var imgUserProfile: UIImageView!{
        didSet{
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickProfile))
            imgUserProfile.addGestureRecognizer(tapGest)
        }
    }
    @IBOutlet weak var lblSubCategory: LabelRegular!
    @IBOutlet weak var lblCategory: LabelRegular!
    @IBOutlet weak var lblPrice: LabelSemiBold!
    @IBOutlet weak var lblEventType: LabelRegular!
    
    @IBOutlet weak var lblDate: LabelRegular!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var lblEventTitle: LabelBold!
    @IBOutlet weak var btnFollow: BlackBgButton!
    
    @IBOutlet weak var lblUserNAme: LabelBold!{
        didSet{
            lblUserNAme.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(onClickProfile))
            lblUserNAme.addGestureRecognizer(tapGest)
        }
    }
    @IBOutlet weak var stackViewWebsite: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
            lblEventTitle.text = parentVC.eventData?.title
            lblPrice.text = (eventData.ticket_price_type == "f" ? "Free" : eventData.minticketamount)
            if let startDt = eventData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                lblDate.text = dateformatter.string(from: startDt)
            }else{
                lblDate.text = "N/A".localized
            }
            lblEventType.text = eventData.event_type_name
            lblCategory.text = eventData.category_name
            lblSubCategory.text = eventData.sub_category_name
            lblDesc.text = eventData.event_desc
            lblUserNAme.text = eventData.user_name
            imgUserProfile.downLoadImage(url: eventData.avatar)
            if eventData.checkLoggedUserFollow == "n"{
                btnFollow.setTitle("FOLLOW", for: .normal)
            }else{
                btnFollow.setTitle("UNFOLLOW", for: .normal)
            }
            if eventData.is_online == "y"{
                stackViewWebsite.isHidden = false
                lblWebsite.text = eventData.website
            }
            
        }
        // Do any additional setup after loading the view.
        
//        if lblDesc.text!.count > 1 {
//            self.lblDesc.text = "Australian open tennis tournament is one of the best live sports in the world with great experience to lorem Ipsum is simply dummy text of the printing and typesetting industry. Ipsum has been the industry's standard dummy text ever since the 1500s, At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaec"
//            DispatchQueue.main.async {
//                self.lblDesc.addTrailing(with: "... ", moreText: "more", moreTextFont: Font.SourceSerifProRegular.size(14), moreTextColor: Color.Purpel.textColor)
//            }
//        }
        
    }

    @objc func onClickProfile(_ sender: UITapGestureRecognizer){
        if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
        let nextVC = ProfileVC.storyboardInstance
        
        nextVC.isFromDetail = true
        nextVC.userId = eventData.userid
        nextVC.userSlug = eventData.userslug
            
        if let parent = self.parent as? SlideUpVC{
            parent.dismiss(animated: true, completion: nil)
        }
        navigation?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func onClickFollow(_ sender: BlackBgButton) {
         if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
        let param = ["userid":eventData.userid,
                     "requester_userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .followUnfollow, viewController: parentVC, param: param) { (response) in
            if ResponseHandler.fatchDataAsString(res: response, valueOf: .is_user_follow) == "y"{
                self.btnFollow.setTitle("UNFOLLOW", for: .normal)
            }else{
                self.btnFollow.setTitle("FOLLOW", for: .normal)
            }
            }
        }
    }
    
   
    
}


extension EventDetailVC{
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("TAP")
        print(lblDesc.maxNumberOfLines)
        print(lblDesc.numberOfVisibleLines)
        self.lblDesc.numberOfLines = 0
        self.holderView.layoutSubviews()
        self.holderView.layoutIfNeeded()
    }
}
