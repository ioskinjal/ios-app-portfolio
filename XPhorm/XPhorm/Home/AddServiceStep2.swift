//
//  AddServiceStep2.swift
//  XPhorm
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AddServiceStep2: BaseViewController {
    
    
    static var storyboardInstance:AddServiceStep2? {
        return StoryBoard.home.instantiateViewController(withIdentifier: AddServiceStep2.identifier) as? AddServiceStep2
    }
    @IBOutlet weak var btnIsHolidays: UIButton!
    @IBOutlet weak var btnAvailable: UIButton!
    @IBOutlet weak var btnUnavailable: UIButton!
    
    @IBOutlet weak var lblServiceAvailablity: UILabel!
    @IBOutlet weak var viewAddAvailablity: UIView!
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var btnContinue: SignInButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblSelectQ: UILabel!
    
    @IBOutlet weak var lblUnavailable: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    
    @IBOutlet weak var tblQuestion: UITableView!{
        didSet{
            tblQuestion.dataSource = self
            tblQuestion.delegate = self
            tblQuestion.tableFooterView = UIView()
            tblQuestion.separatorStyle = .singleLine
            //tblQuestion.border(side: .all, color: UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0), borderWidth: 1.0)
            tblQuestion.setRadius(10.0)
        }
    }
    @IBOutlet weak var viewUnavailable: UIView!{
        didSet{
            viewUnavailable.setRadius(5.0)
        }
    }
    @IBOutlet weak var viewAvailable: UIView!{
        didSet{
            viewAvailable.setRadius(5.0)
            viewAvailable.border(side: .all, color: UIColor(red: 181/255.0, green: 156/255.0, blue: 192/255.0, alpha: 1.0), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var viewBorder: UIView!{
        didSet{
            viewBorder.setRadius(6.0)
            viewBorder.border(side: .all, color: UIColor(red: 230/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tblQuestionHeight: NSLayoutConstraint!
    @IBOutlet weak var view1: UIView!{
        didSet{
            view1.setRadius()
        }
    }
    @IBOutlet weak var view3: UIView!{
        didSet{
            view3.setRadius()
        }
    }
    @IBOutlet weak var view2: UIView!{
        didSet{
            view2.setRadius()
        }
    }
    @IBOutlet weak var btnCloseAvailablity: UIButton!
    @IBOutlet weak var btnSubmitAvailablity: SignInButton!
    
    var selectedDate:String = ""
    var selectedAvailablity = ""
    var selectedHoliday = ""
    var selectedDates = ""
    let formatterCell = DateFormatter()
    var service_id:String = ""
    var time:String = ""
    var timeList = [TimeList]()
    var questionList = [QuestionList]()
    var data:ServiceDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Add Services".localized, action: #selector(onClickMenu(_:)), isRightBtn: true, actionRight: #selector(onClickImage(_:)), btnRightImg: #imageLiteral(resourceName: "financeIcon"))
        
        formatterCell.dateFormat = "yyyy-MM-dd"
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
           
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.minimumLineSpacing = 1
        calendarView.minimumInteritemSpacing = 0
        
        self.getQuestions()
        onClickAvailablity(self.btnAvailable)
        
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        labelMonth.text = monthName + " " + String(year)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        time = dateFormatter.string(from: startDate)
        callChangeCalender()
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard (cell as? CustomCell) != nil else { return }
        // handleCellColor(cell: cell, cellState: cellState)
        // handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func setUpViewUpdateCalendar() {
        _ = formatterCell.date(from: selectedDates)
        //        for i in 0..<arrCalendar.count {
        //            let date = formatterCell.date(from: arrCalendar[i].date)
        //            let order = Calendar.current.compare(selectDate!, to: date!, toGranularity: .day)
        //            if order == .orderedSame {
        //                txtPrice.text = arrCalendar[i].normal_price
        //                txtAvailable.text = arrCalendar[i].status
        //            }
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        lblAvailable.text = "Available".localized
        lblUnavailable.text = "Unavailable".localized
        btnBack.setTitle("BACK", for: .normal)
        btnContinue.setTitle("CONTINUE", for: .normal)
    }
    
    func callChangeCalender(){
        let param = ["action":"changecalendar",
                     "time":time,
                     "serviceId":service_id,
                     "userId":UserData.shared.getUser()!.id,
                     "lId":UserData.shared.getLanguage
        ]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            self.timeList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({TimeList(dic: $0 as! [String:Any])})
            
            self.calendarView.reloadData()
            
        }
    }
    
    func getQuestions(){
        
        let dictParam:[String:Any] = [
            "action":"getQuestionList",
            "userId":UserData.shared.getUser()?.id ?? "",
            "lId":UserData.shared.getLanguage,
            "id":service_id,
        ]
        
        Modal.shared.addService(vc: self, param: dictParam) { (dic) in
            self.questionList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            self.tblQuestion.reloadData()
            self.callChangeCalender()
        }
    }
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickSubmitAvailablity(_ sender: SignInButton) {
        
        sendAvailablity()
    }
    @IBAction func onClickCloseAvailablity(_ sender: UIButton) {
        self.viewAddAvailablity.isHidden = true
        self.navigationBar.isHidden = false
    }
    @IBAction func onClickisHolidays(_ sender: UIButton) {
        if btnIsHolidays.currentImage == #imageLiteral(resourceName: "checkedIcon"){
            btnIsHolidays.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            selectedHoliday = "off"
        }else{
           btnIsHolidays.setImage(#imageLiteral(resourceName: "checkedIcon"), for: .normal)
            selectedHoliday = "on"
        }
    }
    @IBAction func onClickAvailablity(_ sender: UIButton) {
        if sender.tag == 0{
            btnAvailable.setImage(#imageLiteral(resourceName: "radioSelectButton"), for: .normal)
            btnUnavailable.setImage(#imageLiteral(resourceName: "radioButton"), for: .normal)
            selectedAvailablity = "a"
        }else{
            btnUnavailable.setImage(#imageLiteral(resourceName: "radioSelectButton"), for: .normal)
            btnAvailable.setImage(#imageLiteral(resourceName: "radioButton"), for: .normal)
            selectedAvailablity = "n"
        }
    }
    @IBAction func onClickCloseViewAvailablity(_ sender: UIButton) {
        self.viewAddAvailablity.isHidden = true
        self.navigationBar.isHidden = false
    }
    
    @IBAction func onClickPrevious(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    @objc func onClickImage(_ sender:UIButton){
        
    }
    @IBAction func onClickNext(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func onClickContinue(_ sender: SignInButton) {
        var array = [QuestionList]()
        for i in questionList{
            if i.isChecked == true || i.queStatus == "true"{
                array.append(i)
            }
        }
//        if array.count == 0{
//            self.alert(title: "", message: "please select atleast one question".localized)
//        }else{
            callAddService()
       // }
        
    }
    
    func sendAvailablity(){
        let param = ["action":"addAvalibility",
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage,
        "listing_id":service_id,
        "date":selectedDate,
        "isHoliday":selectedHoliday,
        "status":selectedAvailablity]
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            self.viewAddAvailablity.isHidden = true
            self.navigationBar.isHidden = false
            self.callChangeCalender()
        }
        
    }
    
    func callAddService(){
        
        var param:[String:Any] = ["action":"addServiceData",
                                  "userId":UserData.shared.getUser()!.id,
                                  "lId":UserData.shared.getLanguage,
                                  "id":service_id,
                                  "step":"2"]
        
        for i in 0..<questionList.count{
            let strKey = "question_\(i)"
            param[strKey] = questionList[i].isChecked
        }
        
        Modal.shared.addService(vc: self, param: param) { (dic) in
            //   let dict:[String:Any] = dic["data"] as! [String : Any]
            let nextVC = AddServiceStep3VC.storyboardInstance!
            nextVC.service_id = self.service_id
            // nextVC.data = self.data
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickOpenCel(_ sender: UIButton) {
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


extension AddServiceStep2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as? QuestionCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
        cell.lblQuestion.text = questionList[indexPath.row].question
        cell.btnCheck.tag = indexPath.row
        if questionList[indexPath.row].isChecked == true || questionList[indexPath.row].queStatus == "true"{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "checkedCon"), for: .normal)
        }else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "uncheckedCon"), for: .normal)
        }
        cell.btnCheck.addTarget(self, action: #selector(onClickCheck(_:)), for: .touchUpInside)
        
        return cell
        
        
        
    }
    
    @objc func onClickCheck(_ sender:UIButton){
        if questionList[sender.tag].isChecked == false{
            questionList[sender.tag].isChecked = true
        }else{
            questionList[sender.tag].isChecked = false
        }
        tblQuestion.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questionList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //  reloadMoreData(indexPath: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tblQuestionHeight.constant = self.tblQuestion.contentSize.height
        }
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        //        if paymentHistoryList.count - 1 == indexPath.row &&
        //            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
        //            self.paymentHistoryAPI()
        //        }
    }
}
extension AddServiceStep2: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
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
        let month = Calendar.current.dateComponents([.month], from: dateFormatter1.date(from: labelMonth.text ?? "") ?? Date()).month!
       
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
        
       // var isWeekend:Bool = false
       // if date.get_Day() == 1 || date.get_Day() == 7 {
         //   isWeekend = true
        //}else{
          //  isWeekend = false
        //}
        
        for i in timeList{
            if i.date == convertedDate{
                if i.isAvailable == false{
                    cell.isUserInteractionEnabled=false
                    
                    cell.dateLabel.textColor = UIColor.lightGray
                    
                }
                    
                else
                    
                {
                    //if !isWeekend{
                        
                        cell.isUserInteractionEnabled=true
                    
                        cell.dateLabel.textColor = UIColor.black
                    //}else{
//                        cell.isUserInteractionEnabled=false
//
//                        cell.dateLabel.textColor = UIColor.lightGray
                    //}
                }
                if i.isHoliday == "y"{
                    cell.labelPrice.isHidden = false
                    
                }else{
                    cell.labelPrice.isHidden = true
                    
                }
            }
        }
        
        
        
        //        for i in 0..<arrCalendar.count {
        //            if dateCal == arrCalendar[i].date {
        //                if arrCalendar[i].normal_price != "0.00" {
        //                    cell.labelPrice.text = arrCalendar[i].normal_price
        //                }
        //                if arrCalendar[i].isAvailable == 1 {
        //                    cell.selectedView.backgroundColor = UIColor.white
        //                    if arrCalendar[i].isTempBooked == 1 {
        //                        cell.selectedView.backgroundColor = Color.Custom.colorFFD6AE
        //                    }
        //                    else {
        //                        //cell.selectedView.backgroundColor = Color.Custom.colorE16B0B
        //                    }
        //                }
        //                if arrCalendar[i].isAvailable == 0 {
        //                    cell.selectedView.backgroundColor = Color.Custom.colorBCBCBC
        //                }
        //                if arrCalendar[i].isTempBooked == 1 {
        //                    cell.selectedView.backgroundColor = Color.Custom.colorFFD6AE
        //                }
        //                if arrCalendar[i].isTempBooked == 0 &&  arrCalendar[i].isAvailable == 0 {
        //                    cell.selectedView.backgroundColor = Color.Custom.colorE16B0B
        //                }
        //                if arrCalendar[i].status == "unavailable" {
        //                    cell.selectedView.backgroundColor = Color.Custom.colorBCBCBC
        //                }
        //            }
        //        }
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
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        btnIsHolidays.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
        selectedHoliday = "off"
        let dateFromStringFormatter = DateFormatter()
        
        dateFromStringFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateFormatter = DateFormatter()
        var dateCurrent = Date()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let strDate = dateFormatter.string(from: dateCurrent)
        dateCurrent = dateFormatter.date(from: strDate)!
        if dateCurrent < date || dateCurrent == date{
        selectedDate = dateFormatter.string(from: date)
        for i in timeList{
            if i.date == selectedDate{
                if i.isHoliday == "y"{
                btnIsHolidays.setImage(#imageLiteral(resourceName: "checkedIcon"), for: .normal)
                selectedHoliday = "on"
                }
            }
            if i.isAvailable == true{
                onClickAvailablity(btnAvailable)
                selectedAvailablity = "a"
            }else{
                onClickAvailablity(btnUnavailable)
                selectedAvailablity = "n"
            }
        }
        
        self.viewAddAvailablity.isHidden = false
        self.navigationBar.isHidden = true
        
        }
        
    }
}

