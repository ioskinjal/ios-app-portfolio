//
//  AddTicketVC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AddTicketVC: BaseViewController {

    //MARK: Variables
    var getCreatedTicket:( (MyTicketsCls.List)->() )?
    var ticketPriceType: String = "p"
    var ticketsData:MyTicketsCls.List?
    
    //MARK: Properties
    static var storyboardInstance:AddTicketVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: AddTicketVC.identifier) as! AddTicketVC
    }
    
    @IBOutlet weak var btnAdd: BlackBgButton!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnPaid: UIButton!{
        didSet{
            self.btnPaid.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
    }
    @IBOutlet weak var btnClose: GreyButton!
    @IBOutlet weak var lblAddTicket: LabelBold!
    @IBOutlet weak var lblTicketPriceType: LabelSemiBold!
    @IBOutlet weak var lblTicketName: LabelSemiBold!
    @IBOutlet weak var lblQuality: LabelSemiBold!
    @IBOutlet weak var lblPrice: LabelSemiBold!
    @IBOutlet weak var lblEndDate: LabelSemiBold!
    @IBOutlet weak var lblTicketType: LabelSemiBold!
    
    @IBOutlet weak var tfTicketName: TextField!
    @IBOutlet weak var tfQuantity: TextField!{
        didSet{
            //self.tfQuantity.isPreventCaret = true
            self.tfQuantity.delegate = self
            self.tfQuantity.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var tfPrice: TextField!{
        didSet{
            self.tfPrice.delegate = self
            self.tfPrice.keyboardType = .decimalPad
        }
    }
    let endDatePickerView =  UIDatePicker()
    @IBOutlet weak var tfEndDate: TextField!{
        didSet{
            self.tfEndDate.isPreventCaret = true
            endDatePickerView.datePickerMode = .date
            endDatePickerView.addTarget(self, action: #selector(startTimeDiveChanged), for: .valueChanged)
            tfEndDate.inputView = endDatePickerView
            tfEndDate.delegate = self
        }
    }
    @IBOutlet weak var tfTicketType: TextField!
    
    @IBOutlet weak var vwPrice: GreyView!
    @IBOutlet weak var vwTickeType: GreyView!
    @IBOutlet weak var vwEndDate: GreyView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreLoadData()
    }
    
    @IBAction func onClickAdd(_ sender: UIButton) {
        callAddTicket()
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    @IBAction func onClickPaid(_ sender: UIButton) {
        setTicketType(isFree: false)
    }
    
    @IBAction func onClickFree(_ sender: UIButton) {
        setTicketType(isFree: true)
    }
    
    @IBAction func onClickCalender(_ sender: Any) {
        tfEndDate.becomeFirstResponder()
    }
    
}

//MARK: Custom fnctions
extension AddTicketVC{
    
    func setUpPreLoadData() {
        if let ticketsData = self.ticketsData{
            btnAdd.setTitle("UPDATE".localized, for: .normal)
            lblAddTicket.text = "Edit Ticket".localized
            tfTicketName.text = ticketsData.ticket_name
            tfQuantity.text = "\(ticketsData.ticket_qty)"
            
            if ticketsData.ticket_price_type.caseInsensitiveCompare(string: "p"){
                vwPrice.isHidden = false
                vwTickeType.isHidden = false
                vwEndDate.isHidden = false
                
                tfTicketType.text = ticketsData.ticket_type
                let price = ticketsData.ticket_price.replacingOccurrences(of: "$", with: "")
                tfPrice.text = ( price == "0" ? "" : price )
                if let endDt = ticketsData.created_at.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                    endDatePickerView.date = endDt
                    if let dt = endDt.convertDate(dateFormate: DateFormatter.appDateFormat){
                        tfEndDate.text = dt
                    }
                }
                self.btnFree.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
                self.btnPaid.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                self.ticketPriceType = "p"
            }else{
                vwPrice.isHidden = true
                vwTickeType.isHidden = true
                vwEndDate.isHidden = true
                self.btnFree.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
                self.btnPaid.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
                self.ticketPriceType = "f"
            }

        }
    }
    
    @objc func startTimeDiveChanged(_ sender: UIDatePicker) {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = DateFormatter.appDateFormat
        let selectedDate = formatter2.string(from: sender.date)
        tfEndDate.text = selectedDate
    }
    
    func setTicketType(isFree : Bool) {
        self.btnPaid.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        self.btnFree.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        if(isFree) {
            vwPrice.isHidden = true
            vwTickeType.isHidden = true
            vwEndDate.isHidden = true
            self.ticketPriceType = "f"
            self.btnFree.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        } else {
            vwPrice.isHidden = false
            vwTickeType.isHidden = false
            vwEndDate.isHidden = false
            self.ticketPriceType = "p"
            self.btnPaid.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
    }

    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (tfTicketName.text ?? "").isBlank {
            ErrorMsg = "Please enter an Ticket name"
        }
        else if (tfTicketType.text ?? "").isBlank && !vwTickeType.isHidden{
            ErrorMsg = "Please enter Ticket type"
        }
        else if (tfQuantity.text ?? "").isBlank {
            ErrorMsg = "Please enter Quantity"
        }
        else if tfQuantity.text!.count == 1 && tfQuantity.text! == "0" {
            ErrorMsg = "Please enter Quantity"
        }
        else if self.ticketPriceType == "p" && !(tfPrice.text ?? "").isValidFloatNumber && !vwPrice.isHidden{
            ErrorMsg = "Please enter valid Price"
        }
        else if (tfEndDate.text ?? "").isBlank && !vwEndDate.isHidden{
            ErrorMsg = "Please enter end date"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
}

//MARK: API methods
extension AddTicketVC{
    func callAddTicket() {
        if isValidated(){
            var param:dictionary = ["userid":UserData.shared.getUser()!.userid,
                "ticket_price_type":ticketPriceType,
                "ticket_name":tfTicketName.text!,
                "ticket_qty":tfQuantity.text!,
                "ticket_type":tfTicketType.text!,
                "ticket_price": (tfPrice.isEmpty ? "0" : tfPrice._text),
                "ticket_last_date": tfEndDate.text!,
            ]
            
            if let ticketsData = self.ticketsData{
                param["ticket_id"] = ticketsData.id
                API.shared.call(with: .editUserTicket, viewController: self, param: param, success: { (response) in
                    //let newTkt = MyTicketsCls.List(dictionary: ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data))
                    let msg = ResponseHandler.fatchDataAsString(res: response, valueOf: .message)
                    UIApplication.alert(title: "Success", message: msg, completion: {
                        //self.getCreatedTicket?(newTkt)
                        self.popViewController(animated: true)
                    })
                })
            }
            else{
                API.shared.call(with: .addNewUserTicket, viewController: self, param: param, success: { (response) in
                    let newTkt = MyTicketsCls.List(dictionary: ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data))
                    self.getCreatedTicket?(newTkt)
                    self.popViewController(animated: true)
                })
            }
        }
    }
}


//MARK: TextField delegates
extension AddTicketVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfEndDate{
            return false
        }else if textField == tfQuantity{
            //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            return string.allowCharacterSets(with: "01234567789")
        }else if textField == tfPrice{
            if textField.text?.count == 0 && (string == "." || string == "0") {
                return false
            }
            return string.allowCharacterSets(with: ".01234567789")
        }
        else{ return true }
    }
    
}
