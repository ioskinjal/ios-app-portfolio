//
//  AddEventDateVC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AddEventDateVC: UIViewController {

    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:AddEventDateVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: AddEventDateVC.identifier) as! AddEventDateVC
    }
    
    let startDtPickerView:UIDatePicker = {
        let datePick = UIDatePicker()
        let minutes30Later = TimeInterval(30.minutes)
        datePick.minimumDate = Date().addingTimeInterval(minutes30Later)
        datePick.date = Date().addingTimeInterval(minutes30Later)
        datePick.datePickerMode = .dateAndTime
        datePick.addTarget(self, action: #selector(startTimeDiveChanged), for: .valueChanged)
        return datePick
    }()
    let endDtPickerView: UIDatePicker = {
        let datePick = UIDatePicker()
        let minutes30Later = TimeInterval(60.minutes)
        datePick.minimumDate = Date().addingTimeInterval(minutes30Later)
        datePick.date = Date().addingTimeInterval(minutes30Later)
        datePick.datePickerMode = .dateAndTime
        datePick.addTarget(self, action: #selector(endTimeDiveChanged), for: .valueChanged)
        return datePick
    }()
    
    //MARK: Outlets
    @IBOutlet weak var lblStartDt: LabelSemiBold!
    @IBOutlet weak var lblEndDt: LabelSemiBold!
    @IBOutlet weak var tfStartDt: TextField!{
        didSet{
            self.tfStartDt.isPreventCaret = true
            tfStartDt.inputView = startDtPickerView
            tfStartDt.delegate = self
        }
    }
    
    @IBOutlet weak var tfEndDt: TextField!{
        didSet{
            self.tfEndDt.isPreventCaret = true
            tfEndDt.inputView = endDtPickerView
            tfEndDt.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreLoadData()
    }
    @IBAction func onClickStartDate(_ sender: Any) {
        tfStartDt.becomeFirstResponder()
    }
    
    @IBAction func onClickEndDate(_ sender: Any) {
        tfEndDt.becomeFirstResponder()
    }
    
}

//MARK: Custom function
extension AddEventDateVC{
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = DateFormatter.appDateTimeFormat
        let selectedDate = formatter2.string(from: sender.date)
        tfStartDt.text = selectedDate
    }
    
    @objc func endTimeDiveChanged(_ sender: UIDatePicker) {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = DateFormatter.appDateTimeFormat
        let selectedDate = formatter2.string(from: sender.date)
        tfEndDt.text = selectedDate
    }
    
    func isValidated() -> Bool {
        var ErrorMsg = ""
        if tfStartDt.isEmpty {
            ErrorMsg = "Please select start date"
        }
        else if tfEndDt.isEmpty{
            ErrorMsg = "Please select end date"
        }
        else if let startDt = tfStartDt._text.convertDate(dateFormate: DateFormatter.appDateTimeFormat),
            let endDt = tfEndDt._text.convertDate(dateFormate: DateFormatter.appDateTimeFormat), endDt < startDt{
            ErrorMsg = "End date must be greter than start date"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    private func saveData() -> dictionary {
        let param:dictionary = [
            "event_start_datetime": tfStartDt._text,
            "event_end_datetime": tfEndDt._text,
        ]
        return param
    }
    
    func saveDataWithOutValidate() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            eventData.event_start_datetime = tfStartDt._text
            eventData.event_end_datetime = tfEndDt._text
        }
    }
    
    func setDataForEvent( eventData: inout CreateEvent) {
        let dic = saveData()
        eventData.event_start_datetime = dic["event_start_datetime",""]
        eventData.event_end_datetime = dic["event_end_datetime",""]
    }
    
    func setUpPreLoadData() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            tfStartDt.text = eventData.event_start_datetime
            if let startDt = eventData.event_start_datetime.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                startDtPickerView.date = startDt
            }
            tfEndDt.text = eventData.event_end_datetime
            if let endDt = eventData.event_end_datetime.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                endDtPickerView.date = endDt
            }
        }
    }
    
}

//MARK: TextField delegates
extension AddEventDateVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == tfStartDt || textField == tfEndDt) && textField.isEmpty{
            textField.setCurrentDate(date: Date().addingTimeInterval(TimeInterval((textField == tfStartDt ? 30.minutes : 60.minutes))))
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfEndDt || textField == tfStartDt{
            return false
        }
        return true
    }
    
}


