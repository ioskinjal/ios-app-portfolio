//
//  BookServiceVC.swift
//  XPhorm
//
//  Created by admin on 7/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GooglePlaces

class BookServiceVC: BaseViewController {
    
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
    @IBOutlet weak var ConsttblHeight: NSLayoutConstraint!
    var questionList = [QuestionList]()
    static var storyboardInstance:BookServiceVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: BookServiceVC.identifier) as? BookServiceVC
    }

//    @IBOutlet weak var txtFromToDate: UITextField!{
//        didSet{
//            let startPickerview =  UIDatePicker()
//            startPickerview.datePickerMode = .time
//            startPickerview.addTarget(self, action: #selector(EndFromTime(_:)), for: UIControl.Event.valueChanged)
//            txtFromToDate.inputView = startPickerview
//
//
//        }
//    }
    @IBOutlet weak var btnBook: SignInButton!
    @IBOutlet weak var txtLocation: UITextField!{
        didSet{
            txtLocation.delegate = self
        }
    }
    @IBOutlet weak var txtToToDate: UITextField!{
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.datePickerMode = .time
            startPickerview.addTarget(self, action: #selector(EndToTime(_:)), for: UIControl.Event.valueChanged)
            txtToToDate.inputView = startPickerview
            
            
        }
    }
    
    let datePickerViewEnd =  UIDatePicker()
    @IBOutlet weak var txtToDate: UITextField!{
        didSet{
            
            datePickerViewEnd.datePickerMode = .date
            datePickerViewEnd.addTarget(self, action: #selector(ToDate(_:)), for: UIControl.Event.valueChanged)
            txtToDate.inputView = datePickerViewEnd
            
            
        }
    }
//    @IBOutlet weak var txtToStartDateTime: UITextField!{
//        didSet{
//            let startPickerview =  UIDatePicker()
//            startPickerview.datePickerMode = .time
//            startPickerview.addTarget(self, action: #selector(StartToTime(_:)), for: UIControl.Event.valueChanged)
//            txtToStartDateTime.inputView = startPickerview
//
//
//        }
//    }
    @IBOutlet weak var txtFromStartDateTime: UITextField!{
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.datePickerMode = .time
            startPickerview.addTarget(self, action: #selector(StartFromTime(_:)), for: UIControl.Event.valueChanged)
            txtFromStartDateTime.inputView = startPickerview
            
            
        }
    }
    
    @IBOutlet weak var txtFromDate: UITextField!{
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.datePickerMode = .date
            startPickerview.addTarget(self, action: #selector(FromDate(_:)), for: UIControl.Event.valueChanged)
            txtFromDate.inputView = startPickerview
            
            
        }
    }
    @IBOutlet weak var txtPilateCenter: UITextField!
    
    
    var service_id = ""
    var service_type = ""
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var ansList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Book Service".localized, action: #selector(onclickBack(_:)))
        
        txtPilateCenter.text = service_type
        txtPilateCenter.isUserInteractionEnabled = false
        getQuestions()
    }
    
    func getQuestions(){
        let param = ["action":"getQuestions",
        "serviceId":service_id,
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage]
        
        Modal.shared.requestBook(vc: self, param: param) { (dic) in
            self.questionList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({QuestionList(dic: $0 as! [String:Any])})
            self.tblQuestion.reloadData()
            self.ConsttblHeight.constant = self.tblQuestion.contentSize.height
        }
    }
    
    @objc func onclickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func FromDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        txtFromDate.text = formatter.string(from: sender.date)
    }
    
    @objc func ToDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        datePickerViewEnd.minimumDate = formatter.date(from: txtFromDate.text ?? "")
        txtToDate.text = formatter.string(from: sender.date)
        
    }
    
    @objc func StartFromTime(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        txtFromStartDateTime.text = formatter.string(from: sender.date)
    }
    
//    @objc func StartToTime(_ sender: UIDatePicker) {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        datePickerViewEnd.minimumDate = formatter.date(from: txtFromDate.text ?? "")
//        txtToStartDateTime.text = formatter.string(from: sender.date)
//
//    }
    
//    @objc func EndFromTime(_ sender: UIDatePicker) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        txtFromToDate.text = formatter.string(from: sender.date)
//    }
//
    @objc func EndToTime(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        datePickerViewEnd.minimumDate = formatter.date(from: txtFromDate.text ?? "")
        txtToToDate.text = formatter.string(from: sender.date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpLanguage()
    }
    
    func setUpLanguage(){
       txtPilateCenter.placeholder = "Pilates Centers".localized
       txtFromDate.placeholder = "From Date".localized
       txtFromStartDateTime.placeholder = "From Time".localized
//       txtToStartDateTime.placeholder = "To Time".localized
        txtToDate.placeholder = "To Date".localized
//        txtFromToDate.placeholder = "From Time".localized
        txtToToDate.placeholder = "To Time".localized
        txtLocation.placeholder = "Location".localized
        btnBook.setTitle("REQUEST TO BOOK".localized, for: .normal)
       
    }
    
    @IBAction func onClickBook(_ sender: SignInButton) {
        if isValidated(){
            callBookService()
        }
    }
    
    
    
    func callBookService(){
        var param = ["action":"requestForBook",
        "serviceType":service_type,
        "fromDate":txtFromDate.text!,
        "timefrom1":txtFromStartDateTime.text!,
        "toDate":txtToDate.text!,
        "timefrom2":txtToToDate.text!,
        "serviceId":service_id,
        "userId":UserData.shared.getUser()!.id,
        "lId":UserData.shared.getLanguage]
        
        for i in 0..<ansList.count
        {
            let strKey = "questions[\(i)]"
            param[strKey] = ansList[i]
        }
        Modal.shared.requestBook(vc: self, param: param) { (dic) in
            let str = ResponseKey.fatchDataAsString(res: dic, valueOf: .message)
            self.alert(title: "", message: str, completion: {
                self.navigationController?.pushViewController(SentRequestVC.storyboardInstance!, animated: true)
            })
        }
        
        
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (txtPilateCenter.text?.isEmpty)! {
            ErrorMsg = "Please select pilates center".localized
        }
        else if (txtFromDate.text?.isEmpty)! {
            ErrorMsg = "Please enter start date".localized
        }else if (txtFromStartDateTime.text?.isEmpty)! {
            ErrorMsg = "Please start time for start date".localized
        }else if (txtToDate.text?.isEmpty)! {
            ErrorMsg = "Please select end date".localized
        }else if (txtToToDate.text?.isEmpty)! {
            ErrorMsg = "please select end time from end date".localized
        }else if ansList.count != questionList.count{
            ErrorMsg = "please enter all question's answers".localized
        }
        
        if ErrorMsg != "" {
            let alert = UIAlertController(title:"Error".localized, message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
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
extension BookServiceVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtLocation == textField {
            txtLocation.text = nil
            //https://developers.google.com/places/ios-api/
            //TODO: Display google place picker
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtLocation == textField {
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != txtLocation{
            if textField.text == ""{
             self.alert(title: "", message: "please enter answer")
            }else{
            ansList.append(textField.text!)
            }
            }
    }
}
extension BookServiceVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        txtLocation.text = place.formattedAddress
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}


extension BookServiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier) as? AnswerCell else {
            fatalError("Cell can't be dequeue")
            
        }
        cell.selectionStyle = .none
        cell.lblQuestion.text = questionList[indexPath.row].question
       cell.txtAnswer.tag = indexPath.row
        cell.txtAnswer.delegate = self
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
        //DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.ConsttblHeight.constant = self.tblQuestion.contentSize.height
        //}
        
    }
    
    
    func reloadMoreData(indexPath: IndexPath) {
        //        if paymentHistoryList.count - 1 == indexPath.row &&
        //            (favouriteObj!.pagination!.current_page > favouriteObj!.pagination!.total_pages) {
        //            self.paymentHistoryAPI()
        //        }
    }
}

