//
//  EventCC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EventCC: UICollectionViewCell {
    
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblEventNm: LabelBold!
    @IBOutlet weak var lblLocation: LabelRegular!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblPrice: LabelSemiBold!{
        didSet{
            lblPrice.setCornerRadious(withRadious: 5.0, cornerBorderSides: [.topRight,.bottomRight])
        }
    }
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblDate: LabelRegular!
    
    var upcomingData:EventList?
    var parentVC:HomeVC?
    var parentVCSearchMap:SearchResultMapVC?
    
    
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
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblEventNm.text = cellData.title
            lblLocation.text = cellData.add_line_1
            imgEvent.downLoadImage(url: cellData.logo)
            print("EventImage: \(cellData.logo)")
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            // let array = cellData.event_start_time.components(separatedBy: " ")
//            var str:String = cellData.event_start_time
//
//            // dateformatter.dateFormat = "dd MMM, yyyy"
//            let date = dateformatter.date(from:str )
//            // let str1:String = array[1]
//            dateformatter.dateFormat = "dd MMM, yyyy | HH:mm"
//
//            str = dateformatter.string(from: date!)
//            //            let date1 = dateformatter.date(from: str)
//            //            dateformatter.dateFormat = "HH:mm"
//
//            lblDate.text = str
            
            if let startDt = cellData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                self.lblDate.text = dateformatter.string(from: startDt)
            }else{
                self.lblDate.text = "N/A".localized
            }
            
            lblPrice.text = (cellData.ticket_price_type == "f" ? "Free" : cellData.minticketamount)
            btnFavorite.setImage((cellData.is_user_like == "y" ? #imageLiteral(resourceName: "ic_liked") : #imageLiteral(resourceName: "ic_unliked")), for: .normal)
            
            if parentVC == nil{
                btnFavorite.isHidden = true
                btnMore.isHidden = true
            }
        }
    }
    
    func ShowUpcomingData(){
        if let upcomingData = self.upcomingData{
            lblEventNm.text = upcomingData.title
            lblLocation.text = upcomingData.add_line_1
            imgEvent.downLoadImage(url: upcomingData.logo)
            if upcomingData.minticketamount == "$0"{
                lblPrice.text = "Free"
            } else{
                lblPrice.text = upcomingData.minticketamount
            }
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            // let array = cellData.event_start_time.components(separatedBy: " ")
//            var str:String = upcomingData.event_start_time
//
//            // dateformatter.dateFormat = "dd MMM, yyyy"
//            let date = dateformatter.date(from:str )
//            // let str1:String = array[1]
//            dateformatter.dateFormat = "dd MMM, yyyy | HH:mm"
//
//            str = dateformatter.string(from: date!)
//            //            let date1 = dateformatter.date(from: str)
//            //            dateformatter.dateFormat = "HH:mm"
//
//            lblDate.text = str

            if let upcomingData = self.upcomingData, let startDt = upcomingData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                self.lblDate.text = dateformatter.string(from: startDt)
            }else{
                self.lblDate.text = "N/A".localized
            }
            
        if upcomingData.is_user_like == "y"{
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_liked"), for: .normal)
        }else{
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_unliked"), for: .normal)
        }
    }
}

@IBAction func onClickMore(_ sender: UIButton) {
    let alert = UIAlertController(title: "Upcoming Events", message: "Please Select an Option", preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction)in
         let googleUrlString = self.upcomingData?.event_detail_share_url
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
    
    parentVC?.present(alert, animated: true, completion: {
        
    })
}

@IBAction func onClickMapPin(_ sender: UIButton) {
    
}

@IBAction func onClickFav(_ sender: UIButton) {
    callUnFavApi()
}

func callUnFavApi(){
    
    if let cellData = self.cellData, let user = UserData.shared.getUser(),
        let indexPath = self.indexPath, let parentVC = self.viewController as? SearchResultMapVC{
        let param:dictionary = ["userid":user.userid,
                                "event_slug":cellData.slug]
        API.shared.call(with: .favUnFav, viewController: parentVC, param: param, isLoader: false) { (dic) in
            cellData.is_user_like = ResponseHandler.fatchDataAsString(res: dic, valueOf: .is_user_like)
            parentVC.collectionView.reloadItems(at: [indexPath])
        }
    }else if let cellData = self.cellData, let user = UserData.shared.getUser(),
        let indexPath = self.indexPath, let parentVC = self.viewController as? HomeVC{
        let param:dictionary = ["userid":user.userid,
                                "event_slug":cellData.slug]
        API.shared.call(with: .favUnFav, viewController: parentVC, param: param, isLoader: false) { (dic) in
            cellData.is_user_like = ResponseHandler.fatchDataAsString(res: dic, valueOf: .is_user_like)
            parentVC.collectionView.reloadItems(at: [indexPath])
        }
    }
    
//    else{
//        let param = ["userid":UserData.shared.getUser()!.userid,
//                     "event_slug":upcomingData?.slug ?? ""] as [String : Any]
//
//        API.shared.call(with: .favUnFav, viewController: parentVC, param: param) { (dic) in
//            self.parentVC.upcomingEventObj = nil
//            self.parentVC.upcomingEventList = [EventList]()
//            self.parentVC.getUpcomingEvents()
//        }
//    }
    
}

}
