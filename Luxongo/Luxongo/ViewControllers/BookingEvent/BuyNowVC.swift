//
//  BuyNowVC.swift
//  Luxongo
//
//  Created by admin on 7/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BuyNowVC: BaseViewController {
    
    //MARL: Variables
    var eventData:EventList?
    //var ticket: MyTicketsCls.List?
    var listOfTicketType:[MyTicketsCls.List] = []
    var selectedTicket:MyTicketsCls.List?
    
    //MARK: Properties
    static var storyboardInstance:BuyNowVC {
        return StoryBoard.bookingEvent.instantiateViewController(withIdentifier: BuyNowVC.identifier) as! BuyNowVC
    }
    
    @IBOutlet weak var lblBuyNow: LabelRegular!
    //@IBOutlet weak var lblBasePrice: LabelRegular!
    @IBOutlet weak var lblValBasePrice: LabelSemiBold!
    @IBOutlet weak var lblQuatity: LabelRegular!
    @IBOutlet weak var lblValQua: LabelSemiBold!
    @IBOutlet weak var lblTotal: LabelRegular!
    @IBOutlet weak var lblValTotal: LabelSemiBold!
    @IBOutlet weak var lblDesc: LabelRegular!
    @IBOutlet weak var btnCheckOut: BlackBgButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var lblSoldTicket: LabelSemiBold!
    @IBOutlet weak var lblAvailableTkt: LabelSemiBold!
    
    
    @IBOutlet weak var tfTicketType: TextField!{
        didSet{
            tfTicketType.isPreventCaret = true
            tfTicketType.delegate = self
            tfTicketType.addDropDownArrow()
        }
    }
    
    @IBOutlet weak var qualityView: UIView!{
        didSet{
            //self.qualityView.setbo
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func onClickCheckOut(_ sender: Any) {
        callCheckTicket()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickMinus(_ sender: Any) {
        if let eventData = self.eventData, let val = lblValQua.text, !val.isBlank, val != "1", let ticket = selectedTicket {//eventData?.ticketsArray.first {
            let quantity = (Double(lblValQua.text ?? "1") ?? 1) - 1
            if quantity <= 0{
                return
            }
            //let price = String(ticket.ticket_price.dropFirst()) //ticket.ticket_price.replacingOccurrences(of: "$", with: "")
            let price = String(ticket.ticket_price.replacingOccurrences(of: eventData.currency_sign_symbol, with: ""))
            lblValQua.text = "\(quantity)"
            if !price.isBlank{
                let prc = Double(price) ?? 1
                lblValTotal.text = /*String(ticket.ticket_price.prefix(1))*/ eventData.currency_sign_symbol + "\(quantity * prc)" //"$ \(quantity * prc)"
                print("quantity * prc => \(quantity) * \(prc) = \(quantity * prc)")
            }
        }
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        if let eventData = self.eventData, let val = lblValQua.text, !val.isBlank, let ticket = selectedTicket {//eventData?.ticketsArray.first{
            let quantity = (Double(lblValQua.text ?? "0") ?? 0) + 1
            //let price = String(ticket.ticket_price.dropFirst()) //ticket.ticket_price.replacingOccurrences(of: "$", with: "")
            let price = String(ticket.ticket_price.replacingOccurrences(of: eventData.currency_sign_symbol, with: ""))
            lblValQua.text = "\(quantity)"
            if !price.isBlank{
                let prc = Double(price) ?? 1
                lblValTotal.text = /*String(ticket.ticket_price.prefix(1))*/ eventData.currency_sign_symbol + "\(quantity * prc)"//lblValTotal.text = "$ \(quantity * prc)"
                print("quantity * prc => \(quantity) * \(prc) = \(quantity * prc)")
            }
        }
    }
    
}

//MARK: Custom function
extension BuyNowVC{
    
    func setUpUI() {
        if let eventData = self.eventData{
            lblValBasePrice.text = (eventData.minticketamount == "$0" || eventData.minticketamount == "$" ? "Free" : eventData.minticketamount)
            lblValQua.text = "1"
            lblValTotal.text = ""
            
            lblSoldTicket.text = "Sold Tickets : ".localized + "\(eventData.totalBookedTickets)"
            lblAvailableTkt.text = "Available Tickets : ".localized + "\(eventData.totaltickets)"
            
            //(eventData.minticketamount == "$0" || eventData.minticketamount == "$" ? "Free" : eventData.minticketamount)
//            if let ticket = eventData.ticketsArray.first{
//                lblValBasePrice.text = ticket.ticket_price
//                self.ticket = ticket
//            }
            
            listOfTicketType = eventData.ticketsArray
            //Sort as per minimum price first
          
            //listOfTicketType.sort(by: { $0.ticket_price.replacingOccurrences(of: eventData.currency_sign_symbol, with: "") < $1.ticket_price.replacingOccurrences(of: eventData.currency_sign_symbol, with: "") })
            selectedTicket = listOfTicketType.first//eventData.ticketsArray.first
            //selectedTicket = eventData.ticketsArray.first
//            if let ticket = selectedTicket{
//                lblValBasePrice.text = ticket.ticket_price
//                self.ticket = ticket
//            }

            setTotalAsPerTicket()
//            if let val = lblValQua.text, !val.isBlank, let ticket = selectedTicket {//eventData?.ticketsArray.first{
//                let quantity = (Double(lblValQua.text ?? "0") ?? 1)
//                let price = String(ticket.ticket_price.dropFirst()) //ticket.ticket_price.replacingOccurrences(of: "$", with: "")
//                lblValQua.text = "\(quantity)"
//                if !price.isBlank{
//                    let prc = Double(price) ?? 1
//                    lblValTotal.text = String(ticket.ticket_price.prefix(1)) + "\(quantity * prc)"//lblValTotal.text = "$ \(quantity * prc)"
//                    print("quantity * prc => \(quantity) * \(prc) = \(quantity * prc)")
//                }
//                //For default value selected
//                tfTicketType.text = ticket.ticket_name
//            }
        }else{
            lblValTotal.text = ""
            lblValBasePrice.text = ""
            lblValQua.text = ""
        }
    }
    
}

//MARK: API methods
extension BuyNowVC{
    
    func openTicketTypePickerView() {
        if self.listOfTicketType.count > 0{
            let nextVC = PickerVC.storyboardInstance
            nextVC.setUp(delegate: self, textField: tfTicketType)
            PickerVC.UIDisplayData.title = "Select Ticket type"
            //TODO: Selected Ticket
            nextVC.selectedLanguage = PickerData(id: "", title: tfTicketType._text, value: "")
            nextVC.listOfDataSource = self.listOfTicketType.map({ PickerData(id: String($0.id), title: $0.ticket_name, value: $0.ticket_type) })
            present(asPopUpView: nextVC)
        }else{
            //callEventType()
        }
    }
    
    func callCheckTicket() {
        if let eventData = eventData, let ticket = selectedTicket{
            let param:dictionary = [
                "book_userid":UserData.shared.getUser()!.userid,
                "event_id":eventData.id,
                "event_add_userid":eventData.userid,
                "ticket_id":ticket.id,
                "ticket_qty":Int(lblValQua.text!) ?? 1,
            ]
            API.shared.call(with: .checkEventTicket, viewController: self, param: param, success: { (response) in
                /*"data": {
                 "paypalURL": "https://www.davidevent.ncryptedprojects.com/admin/api/paypal-loader/30",
                 "paypalSuccess": "payment-complete/success",
                 "paypalError": "payment-complete/error"
                 },*/
                let paypalData = PayPalData(dictionary: ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data))
                
                //TODO: PayPal add
                if !paypalData.paypalURL.isEmpty{
                    let view = WebViewController(url: paypalData.paypalURL, success: paypalData.paypalSuccess, fail: paypalData.paypalError, navigationTitle: "PayPal", isNavBar: true)
                        
//                        WebViewController(url: paypalData.paypalURL, success: paypalData.paypalSuccess, fail: paypalData.paypalError)
                    view.isPaymentDone = { [weak self] isSuccess in
                        guard let self = self else { return }
                        //                        print("Paymnet Done")
                        self.dismiss(animated: true, completion: {
                            self.dismiss(animated: true, completion: {
                                
                            })
                            
                        })
                        
                    }
                    let nav = UINavigationController(rootViewController: view)
                    nav.navigationBar.tintColor = Color.Orange.theme
                    self.present(nav, animated: true, completion: nil)
                }
                
                
//                if paypalData.paypalURL.isEmpty{
//                    let view = WebViewController(url: paypalData.paypalURL, success: paypalData.paypalSuccess, fail: paypalData.paypalError)
//                    view.isPaymentDone = { [weak self] isSuccess in
//                        guard let _ = self else { return }
//                        print("Paymnet Done")
//                    }
//                    self.present(view, animated: true, completion: nil)
//                }
                
                /*
                 let alertController = UIAlertController(title: "", message: message.localized, preferredStyle: .alert)
                 let OKAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { (action) in
                 //self.dismiss(animated: true)
                 //TODO: PayPal add
                 let view = WebViewController(url: <#T##String#>, success: <#T##String#>, fail: <#T##String#>)
                 view.isPaymentDone = { [weak self] isSuccess in
                 guard let self = self else { return }
                 print("Paymnet Done")
                 
                 }
                 })
                 alertController.addAction(OKAction)
                 self.present(alertController, animated: true, completion: nil)
                 */
            })
            
        }
        
        
    }
    
}

extension BuyNowVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === tfTicketType{
            openTicketTypePickerView()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfTicketType{
            return false
        }
        return true
    }
    
}


//MARK: PickerView delegate
extension BuyNowVC: pickerViewData{
    
    func setTotalAsPerTicket(){
        if let eventData = self.eventData, let val = lblValQua.text, !val.isBlank, let ticket = selectedTicket {//eventData?.ticketsArray.first{
            lblValBasePrice.text = ticket.ticket_price
            let quantity = (Double(lblValQua.text ?? "0") ?? 1)
            let price = String(ticket.ticket_price.replacingOccurrences(of: eventData.currency_sign_symbol, with: "")/*ticket.ticket_price.dropFirst()*/) //ticket.ticket_price.replacingOccurrences(of: "$", with: "")
            lblValQua.text = "\(quantity)"
            if !price.isBlank{
                let prc = Double(price) ?? 1
                lblValTotal.text = /*String(ticket.ticket_price.prefix(1))*/ eventData.currency_sign_symbol + "\(quantity * prc)"//lblValTotal.text = "$ \(quantity * prc)"
                print("quantity * prc => \(quantity) * \(prc) = \(quantity * prc)")
            }
            //For default value selected
            tfTicketType.text = ticket.ticket_name
        }
    }
    
    
    func fatchData(element: PickerData, textField: UITextField) {
        if textField == tfTicketType{
            tfTicketType.text = element.title
            if let tkt = self.listOfTicketType.filter({$0.ticket_name == element.title}).first{
                self.lblValBasePrice.text = tkt.ticket_price
                self.selectedTicket = tkt
            }
            //Fatch Id to send to the server
            //selectedCategoryId = element.id
            setTotalAsPerTicket()
        }
    }
}
