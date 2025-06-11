//
//  EventPreview.swift
//  Luxongo
//
//  Created by admin on 8/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import ImageSlideshow

class EventPreview: BaseViewController {

    //MARK: Variables
    var eventData:EventList?
    var event_slug:String?
    var isFromCreateMode: Bool = false
    
//    let overlayControllerVC: DTOverlayController = {
//        let slideVC = SlideUpVC.storyboardInstance
//        slideVC.eventData = eventData
//
//        let overlayController = DTOverlayController(viewController: SlideUpVC.storyboardInstance)
//
//        // View controller is automatically dismissed when you release your finger
//        overlayController.dismissableProgress = 0.6
//
//        // Enable/disable pan gesture
//        overlayController.isPanGestureEnabled = false
//
//        // Update top-left and top-right corner radius
//        //overlayController.overlayViewCornerRadius = 10
//
//        // Control the height of the view controller
//        overlayController.overlayHeight = .dynamic(0.8) // 80% height of parent controller
//        //overlayController.overlayHeight = .static(300) // fixed 300-point height
//        //overlayController.overlayHeight = .inset(50) // fixed 50-point inset from top
//        return overlayController
//    }()
    
    //MARK: Properties
    static var storyboardInstance:EventPreview {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: EventPreview.identifier) as! EventPreview
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var lblEventName: LabelBold!
    @IBOutlet weak var lblAddress: LabelRegular!
    @IBOutlet weak var lblDate: LabelRegular!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lblPrice: LabelSemiBold!
    @IBOutlet weak var btnDetails: UIButton!{
        didSet{
            btnDetails.tag = 1
        }
    }
    
    @IBOutlet weak var btnMap: UIButton!{
        didSet{
            btnDetails.tag = 2
        }
    }
    @IBOutlet weak var btnOrganizer: UIButton!{
        didSet{
            btnDetails.tag = 3
        }
    }
    @IBOutlet weak var btnSimilar: UIButton!{
        didSet{
            btnDetails.tag = 4
        }
    }
    
    @IBOutlet weak var viewSlider: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventDetail()
        
        //eventData = EventList(dictionary: [:])
    }
    
    func getEventDetail(){
        
        if let event_slug = self.event_slug{
            let param = ["event_slug":event_slug,
                         "userid":UserData.shared.getUser()!.userid] as [String : Any]
            
            API.shared.call(with: .eventDetail, viewController: self, param: param) { (response) in
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                self.eventData = EventList(dictionary: dic)
                if let eventData = self.eventData, let startDt = eventData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                    self.lblDate.text = dateformatter.string(from: startDt)
                }else{
                    self.lblDate.text = "N/A".localized
                }
                self.lblAddress.text = self.eventData?.add_line_1
                self.lblEventName.text = self.eventData?.title
                
                self.lblPrice.text = (self.eventData?.ticket_price_type == "f" ? "Free" : self.eventData?.minticketamount)
                
                self.setUpUI()
            }
        }
    }
    
    @IBAction func onClickMore(_ sender: Any) {
        let alert = UIAlertController(title: "Flyers Detail", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction)in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Report Flyers", style: .default , handler:{ (UIAlertAction)in
            self.callReportEvent()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    
    func callReportEvent(){
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "event_id":eventData!.id] as [String : Any]
        
        API.shared.call(with: .reportEvent, viewController: self, param: param) { (response) in
            let msg = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
            UIApplication.alert(title: "Success", message: msg)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if isFromCreateMode{
            popToViewController(type: ManageEventsVC.self, animated: true)
            //Fire notification for data refresh in Manage event VC
            NotificationCenter.default.post(name: .eventModify, object: ["flag":true] as [String:Any])
        }else{
            popViewController(animated: true)
        }
    }
    
    @IBAction func onClickBottom(_ sender: UIButton) {
        navigation = self.navigationController
        
        let slideVC = SlideUpVC.storyboardInstance
        slideVC.eventData = eventData
        
        let overlayController = DTOverlayController(viewController: slideVC)
        
        // View controller is automatically dismissed when you release your finger
        overlayController.dismissableProgress = 0.6
        
        // Enable/disable pan gesture
        overlayController.isPanGestureEnabled = false
        
        // Update top-left and top-right corner radius
        //overlayController.overlayViewCornerRadius = 10
        
        // Control the height of the view controller
        overlayController.overlayHeight = .dynamic(0.9) // 80% height of parent controller
        //overlayController.overlayHeight = .static(300) // fixed 300-point height
        //overlayController.overlayHeight = .inset(50) // fixed 50-point inset from top
        
        self.present(overlayController, animated: true, completion: nil)
    }
    
    
}

//MARK: Custom function
extension EventPreview{

    
    func setUpUI() {
        if let eventData = self.eventData{
          //  imgEvent.downLoadImage(url: eventData.logo)
            lblEventName.text = eventData.title
           // lblDate.text = getShortDate(dateStr: eventData.event_start_time)
            lblAddress.text = eventData.add_line_1
           
            if eventData.getAllBackImages.count != 0{
                var alamofireSource = [AlamofireSource]()
                for i in eventData.getAllBackImages{
                  
                    alamofireSource.append(AlamofireSource(urlString: i.back_image)!)
                }
                self.viewSlider.setImageInputs(alamofireSource)
                self.viewSlider.contentScaleMode = .scaleAspectFill
                self.viewSlider.slideshowInterval  = 3.0
                
                
            }
        }
        

    }
    
}

func getShortDate(dateStr:String /*= "2019-12-29 00:18:00"*/) -> String{
    if let dt = dateStr.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
        return "\(dt.dayOfMonth) \(dt.monthShort)"
    }
    return ""
}



//https://stackoverflow.com/questions/25533147/get-day-of-week-using-nsdate
extension Date {
    //https://www.zerotoappstore.com/get-year-month-day-from-date-swift.html
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
        // Sunday
    }
    
    var dayOfMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
        // Sunday
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var monthShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        return dateFormatter.string(from: self)
        //Aug
    }
    
    var monthFullName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL" //"LL" -> 08 // "LLL" -> Aug //"LLLL" -> Augest
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" //If you just want two digits, use yy instead of yyyy.
        return dateFormatter.string(from: self)
    }
    
}
//Usage
//let date = Date()
//let monthString = date.month
/*
Characters    Example    Explained
 
Year
y    2019    Year with no padding
yy    19    Year with two digits, will pad with zero if needed
yyyy    2019    Year, with four digits, will pad with zero if needed

Month
M    1    Numeric month with no padding
MM    01    Two digit numeric month with padding
MMMM    January    Full name of the month

Day
d    1    Day of the month
dd    01    Two digit day of the month with padding
E    Fri    Day of the week short-hand
EEEE    Friday    Full name of the day

Hour
h    2    Twelve hour format
hh    02    Twelve hour format with padding
H    14    24 hour format
HH    04    24 hour format with padding
a    AM    AM / PM

Minute
m    30    Minute with no padding
mm    35    Minutes with padding

Seconds
s    5    Seconds with no padding
ss    05    Seconds with padding
SSS    4321    Milliseconds

Time Zones
zzz    PST    3 letter timezone
zzzz    Pacific Standard Time    The whole timezone name
Z    -0800    RFC 822 GMT Format
ZZZZZ    -08:00    ISO 8601 Format

*/
