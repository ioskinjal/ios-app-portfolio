//
//  ServiceDetailVC.swift
//  XPhorm
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos
import JTAppleCalendar

import ImageSlideshow

class ServiceDetailVC: BaseViewController {
    
    static var storyboardInstance:ServiceDetailVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: ServiceDetailVC.identifier) as? ServiceDetailVC
    }
    
    @IBOutlet weak var viewTrainer: UIView!{
        didSet{
            viewTrainer.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            viewTrainer.setRadius(8.0)
        }
    }
    @IBOutlet weak var lblServiceDesc: UILabel!
    @IBOutlet weak var lblCancellaTionPolicy: UILabel!
    @IBOutlet weak var btnFlagService: UIButton!
    @IBOutlet weak var btnFlagUser: UIButton!
    @IBOutlet weak var lblFlagTitle: UILabel!
    @IBOutlet weak var txtComment: UITextView!{
        didSet{
           txtComment.placeholder = "Enter Comment"
        txtComment.border(side: .all, color: #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1), borderWidth: 1.0)
        txtComment.setRadius(8.0)
        }
    }
    
    @IBOutlet weak var viewFlag: UIView!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var viewCalendarBorder: UIView!{
        didSet{
            viewCalendarBorder.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            viewCalendarBorder.setRadius(8.0)
        }
    }
    @IBOutlet weak var viewService: UIView!{
        didSet{
            viewService.border(side: .all, color: #colorLiteral(red: 0.8941176471, green: 0.9137254902, blue: 0.9176470588, alpha: 1), borderWidth: 1.0)
            viewService.setRadius(8.0)
        }
    }
    
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblAboutTrainer: UILabel!
   
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblVisitCharge: UILabel!
    @IBOutlet weak var lblVisitChargeHead: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblDurationHead: UILabel!
    @IBOutlet weak var tblReviewsHeight: NSLayoutConstraint!
    @IBOutlet weak var tblReviews: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblLocationService: UILabel!
    @IBOutlet weak var lblTrainerName: UILabel!
    @IBOutlet weak var imgTrainer: UIImageView!
    @IBOutlet weak var viewSlider: ImageSlideshow!
    
    @IBOutlet weak var btnBook: UIButton!{
        didSet{
            btnBook.setTitle("REQUEST TO BOOK".localized, for: .normal)
        }
    }
    
    
    var isFromUserFlag = false
    var service_id = ""
    var timeList = [TimeList]()
    var data:ServiceDetail?
    var arrImages = [ServiceDetail.ServiceImages]()
    let formatterCell = DateFormatter()
    var time:String = ""
    var reviewList = [ServiceDetailReviewCls.DetailReviewList]()
    var reviewObj: ServiceDetailReviewCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Service Detail".localized, action: #selector(onClickBack(_:)))
        getServiceDetail()
        
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        lblDate.text = monthName + " " + String(year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        time = dateFormatter.string(from: startDate)
        callChangeCalender()
        
    }
    
    func getServiceDetail(){
        let param = ["action":"getServiceInfo",
                     "userId":UserData.shared.getUser()?.id ?? "",
                     "lId":UserData.shared.getLanguage,
                     "id":service_id]
        
        Modal.shared.serviceDetail(vc: nil, param: param) { (dic) in
            
            self.data = ServiceDetail(dic: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.showDetailData(data: self.data!)
            self.getReviews()
            
        }
    }
    
    func getReviews(){
        
        let nextPage = (reviewObj?.pagination?.page ?? 0 ) + 1
        
        let param = ["action":"getReviews",
        "userId":UserData.shared.getUser()?.id ?? "",
        "lId":UserData.shared.getLanguage,
        "id":service_id,
        "pageNo":nextPage] as [String : Any]
        
        Modal.shared.serviceDetail(vc: nil, param: param) { (dic) in
            self.reviewObj = ServiceDetailReviewCls(dictionary: dic)
            if self.reviewList.count > 0{
                self.reviewList += self.reviewObj!.detailReviewList
            }
            else{
                self.reviewList = self.reviewObj!.detailReviewList
            }
            self.tblReviews.reloadData()
            self.tblReviewsHeight.constant = self.tblReviews.contentSize.height
            
        }
    }
    
    func callChangeCalender(){
        
        let param = ["action":"changecalendar",
                     "time":time,
                     "serviceId":service_id,
                     "userId":UserData.shared.getUser()?.id ?? "",
                     "lId":UserData.shared.getLanguage
            ] as [String : Any]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            self.timeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({TimeList(dic: $0 as! [String:Any])})
            
            self.calenderView.reloadData()
            
        }
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showDetailData(data:ServiceDetail){
        lblCategoryName.text = data.title
       // lblAdditionalRate.text = data.additionalRate
        lblVisitCharge.text = currency + data.price
        lblLocationService.text = data.location
       // lblServiceCharge.text = data.description
        lblLocation.text = data.address
        
        arrImages = data.serviceImages
        var alamofireSource = [AlamofireSource]()
        for i in 0..<self.arrImages.count{
            alamofireSource.append(AlamofireSource(urlString: arrImages[i].imagePath)!)
        }
        self.viewSlider.setImageInputs(alamofireSource)
        self.viewSlider.contentScaleMode = .scaleAspectFill
        self.viewSlider.slideshowInterval  = 3.0
        imgTrainer.downLoadImage(url: data.profileImg)
        lblTrainerName.text = data.userName
        //lblAdditionalRate.text = data.additionalRate
       // btnCancellationpolicy.setTitle(data.cancellationPolicy, for: .normal)
        viewRate.rating = (data.avgRating as NSString).doubleValue
        lblDuration.text = data.duration
        if data.favStatus == "false"{
            self.btnFav.setImage(#imageLiteral(resourceName: "likeIcon"), for: .normal)
        }else{
             self.btnFav.setImage(#imageLiteral(resourceName: "likeCircleIcon"), for: .normal)
        }
        let array = data.createdDate.components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date:Date = dateFormatter.date(from: array[0])!
        dateFormatter.dateFormat = "yyyy-MM"
        time = dateFormatter.string(from: date)
        
        formatterCell.dateFormat = "yyyy-MM-dd"
        self.calenderView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calenderView.minimumLineSpacing = 1
        calenderView.minimumInteritemSpacing = 0
        lblRate.text = data.avgRating + "/5"
        lblAbout.text = data.userDescription
        if data.userId == UserData.shared.getUser()?.id{
            btnFlagUser.isHidden = true
            btnFlagService.isHidden = true
            btnBook.isHidden = true
            btnFav.isHidden = true
        }
        lblCancellaTionPolicy.text = data.cancellationPolicy
        lblServiceDesc.text = data.description
        
        
    }
    @IBAction func onClickFlagUser(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user != nil{
        isFromUserFlag = true
             lblFlagTitle.text = "Flag User"
        viewFlag.isHidden = false
        self.navigationBar.isHidden = true
        }else{
            self.alert(title: "", message: "please login to flag user")
        }
    }
    @IBAction func onClickCancel(_ sender: UIButton) {
        
        viewFlag.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickAdd(_ sender: SignInButton) {
        if txtComment.text != ""{
            if isFromUserFlag{
                let param = ["action":"flagUser",
                             "userId":UserData.shared.getUser()!.id,
                             "lId":UserData.shared.getLanguage,
                             "flagUserId":data!.userId,
                             "comment":txtComment.text!] as [String : Any]
                
                Modal.shared.profile(vc: self, param: param) { (dic) in
                    let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                    self.alert(title: "", message: str, completion: {
                        self.getServiceDetail()
                        self.viewFlag.isHidden = true
                        self.navigationBar.isHidden = false
                    })
                }
            }else{
            let param = ["action":"flagService",
            "userId":UserData.shared.getUser()!.id,
            "lId":UserData.shared.getLanguage,
            "id":service_id,
                "comment":txtComment.text!] as [String : Any]
            
            Modal.shared.serviceDetail(vc: self, param: param) { (dic) in
                let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
                self.alert(title: "", message: str, completion: {
                    self.getServiceDetail()
                    self.viewFlag.isHidden = true
                    self.navigationBar.isHidden = false
                })
            }
            }
        
        }else{
            self.alert(title: "", message: "please enter comment")
        }
    }
    @IBAction func onClickCloseFlag(_ sender: Any) {
        
        viewFlag.isHidden = true
        self.navigationBar.isHidden = false
       
    }
    @IBAction func onClickFlag(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user != nil{
          isFromUserFlag = false
            lblFlagTitle.text = "Flag Service"
        viewFlag.isHidden = false
        self.navigationBar.isHidden = true
        }else{
            self.alert(title: "", message: "please login to flag service")
        }
    }
    @IBAction func onClickBook(_ sender: UIButton) {
        let user = UserData.shared.getUser()
        if user != nil{
        let nextVC = BookServiceVC.storyboardInstance!
        nextVC.service_id = service_id
        nextVC.service_type = data?.title ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            self.alert(title: "", message: "please login to book service")
        }
    }
    @IBAction func onClickPrevious(_ sender: Any) {
        self.calenderView.scrollToSegment(.previous)
        
    }
    @IBAction func onClickNext(_ sender: Any) {
        self.calenderView.scrollToSegment(.next)
    }
    @available(iOS 10.0, *)
    @IBAction func onclickCancelationPolicy(_ sender: Any) {
        guard let url = URL(string: data!.policyURL) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onClickShare(_ sender: UIButton) {
        let str = data?.serviceURL
        let activityViewController = UIActivityViewController(activityItems: [str!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickLike(_ sender: UIButton) {
         let user = UserData.shared.getUser()
           if user != nil{
        if btnFav.currentImage == #imageLiteral(resourceName: "likeIcon"){
            callAddToFav()
        }else{
            callRemoveFav()
        }
        }else{
            self.alert(title: "", message: "please login to add favorite")
        }
    }
    
    
    
    func callAddToFav(){
        let param = ["lId":UserData.shared.getLanguage,
                     "action":"updateFav",
                     "val":"favorit-o",
                     "userId":UserData.shared.getUser()?.id ?? "",
                     "id":service_id]
        
        Modal.shared.search(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.getServiceDetail()
            })
        }
    }
    
    func callRemoveFav(){
        let param = ["lId":UserData.shared.getLanguage,
                     "action":"updateFav",
                     "val":"favorit",
                     "userId":UserData.shared.getUser()?.id ?? "",
                     "id":service_id]
        
        Modal.shared.search(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.getServiceDetail()
            })
        }
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard (cell as? CustomCell) != nil else { return }
        // handleCellColor(cell: cell, cellState: cellState)
        // handleCellSelection(cell: cell, cellState: cellState)
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
extension ServiceDetailVC: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        cell.labelPrice.isHidden = true
        print(date)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMMM yyyy"
        let month = Calendar.current.dateComponents([.month], from: dateFormatter1.date(from: lblDate.text ?? "") ?? Date()).month!
        
        dateFormatter1.dateFormat = "MM"
        let date1 = dateFormatter1.string(from: date)
        let prevDate = Calendar.current.dateComponents([.month], from: dateFormatter1.date(from: date1)!).month!
        if prevDate != month
        {
            cell.dateLabel.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.labelPrice.isHidden = true
        }else{
            //  cell.labelPrice.isHidden = false
            cell.dateLabel.isHidden = false
            cell.isUserInteractionEnabled = true
        }
        
        //   let dateCal = formatterCell.string(from: date)
        
        let dateFromStringFormatter = DateFormatter()
        
        dateFromStringFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let convertedDate: String = dateFormatter.string(from: date)
        
        var isWeekend:Bool = false
        if date.get_Day() == 1 || date.get_Day() == 7 {
            isWeekend = true
        }else{
            isWeekend = false
        }
        
        for i in timeList{
            if i.date == convertedDate{
                if i.isAvailable == false{
                    cell.isUserInteractionEnabled=false
                    
                    cell.dateLabel.textColor = UIColor.lightGray
                    
                }
                    
                else
                    
                {
                    if !isWeekend{
                        
                        cell.isUserInteractionEnabled=true
                        
                        cell.dateLabel.textColor = UIColor.black
                    }else{
                        cell.isUserInteractionEnabled=false
                        
                        cell.dateLabel.textColor = UIColor.lightGray
                    }
                }
                if i.isHoliday == "y"{
                    cell.labelPrice.isHidden = false
                    
                }else{
                    cell.labelPrice.isHidden = true
                    
                }
            }
        }
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = Date() // You can use date generated from a formatter
        let endDate = formatter.date(from: "2030 02 01")!                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .off,
            firstDayOfWeek: .sunday
        )
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
}
extension ServiceDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedReviewCell.identifier) as? ReceivedReviewCell else {
                fatalError("Cell can't be dequeue")
            }
        let data:ServiceDetailReviewCls.DetailReviewList = reviewList[indexPath.row]
            cell.lblName.text = data.userName
        cell.lblDate.text = data.createdDate
        cell.lblDesc.text = data.desc
        cell.lblRate.text = data.ratting + "/5"
        cell.rateView.rating = (data.ratting as NSString).doubleValue
        cell.imgProfile.downLoadImage(url: data.profileImg)
            return cell
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.reviewList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
                if reviewList.count - 1 == indexPath.row &&
                    (reviewObj!.pagination!.page > reviewObj!.pagination!.numPages) {
                    self.getReviews()
                }
    }
}
