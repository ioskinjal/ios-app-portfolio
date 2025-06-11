//
//  TicketPopUpVC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TicketPopUpVC: BaseViewController {

    //MARK: Variables
    var history: PaymentHistoryCls.HistoryList?
    
    //MARK: Properties
    static var storyboardInstance:TicketPopUpVC {
        return (StoryBoard.purchaseTicket.instantiateViewController(withIdentifier: TicketPopUpVC.identifier) as! TicketPopUpVC)
    }
    
    
    @IBOutlet weak var containtView: UIView!{
        didSet{
            self.containtView.setRadius(radius: 15)
        }
    }
    @IBOutlet weak var lblEventNm: LabelSemiBold!
    @IBOutlet weak var lblBy: LabelRegular!
    @IBOutlet weak var imgEvent: UIImageView!{
        didSet{
            self.imgEvent.setRadius(radius: 10)
        }
    }
    
    @IBOutlet weak var lblDateTime: LabelRegular!
    @IBOutlet weak var lblLocation: LabelRegular!
    @IBOutlet weak var lblQuantity: LabelRegular!
    @IBOutlet weak var lblBookingNm: LabelRegular!
    
    @IBOutlet weak var lblValDateTime: LabelSemiBold!
    @IBOutlet weak var lblValLocation: LabelSemiBold!
    @IBOutlet weak var lblValQuantity: LabelSemiBold!
    @IBOutlet weak var lblValBookingNm: LabelSemiBold!
    
    @IBOutlet weak var lblTotal: LabelRegular!
    @IBOutlet weak var lblValTotal: LabelSemiBold!
    
    
    @IBOutlet weak var btnDownload: BlackBgButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func onClickDownloadTicket(_ sender: UIButton) {
        downloadTicket()
    }
}


//MARK: Custom function
extension TicketPopUpVC{
    
    func setUpUI() {
        if let history = self.history{
            lblEventNm.text = history.ticket_name
            lblBy.text = history.title
            imgEvent.downLoadImage(url: history.logo)
            if let startDt = history.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
                lblDateTime.text = dateformatter.string(from: startDt)
            }else{
                lblDateTime.text = "N/A".localized
            }
            lblLocation.text = history.add_line_1
            lblQuantity.text = "\(history.ticket_booked_qty)"
            lblValTotal.text = "\((history.ticket_price_type == "f" ? "Free".localized : "\(history.total_paid_amount)"))"
        }
    }
    
    func downloadTicket() {
        if let history = self.history, !history.ticket_download_link.isBlank{
            print("Ticket: \(history.ticket_download_link)")
            if let url = URL(string: history.ticket_download_link) {
                Downloader.loadFileAsync(url: url, fileName: "\(history.ticket_name)_\(Date()).pdf".removingAllWhitespacesAndNewlines) { (downloadedURL, error) in
                    if error == nil {
                        print("downloadedURL : \((downloadedURL ?? ""))")
                        //UIApplication.alert(title: "Saved!", message: "Doument is saved")
                        let ac = UIAlertController(title: "Saved!", message: "Documents is saved.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    } else {
                        print("error : \((error?.localizedDescription ?? ""))")
                        //UIApplication.alert(title: "Error", message: error?.localizedDescription ?? "")
                        let ac = UIAlertController(title: "Error", message: error?.localizedDescription ?? "", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            }
        }
        else{
            print("No URL found")
        }
    }
    
}

