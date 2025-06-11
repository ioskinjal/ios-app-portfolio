//
//  HDDeliverySelectionTableCell.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol HDDeliveryOptionProtocol {
    func hdExpress()
    func hdToday()
    func hdTomorrow()
    func hdParentExpress()
    func hdParentToday()
    func hdParentTomorrow()
}

class HDDeliverySelectionTableCell: UITableViewCell {
    @IBOutlet weak var todayConstraint: NSLayoutConstraint!
    @IBOutlet weak var expressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var todayTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var tomorrowConstraint: NSLayoutConstraint!
    @IBOutlet weak var TotalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var todayDeliveryHeight: NSLayoutConstraint!
    @IBOutlet weak var tomorrowDeliveryHeight: NSLayoutConstraint!
    @IBOutlet weak var _viewExpressDelivery: UIView!
    @IBOutlet weak var _viewToday: UIView!
    @IBOutlet weak var _viewTomorrow: UIView!
    @IBOutlet weak var expressDeliveryTimeView: UIView!
    @IBOutlet weak var todaysDeliveryTimeView: UIView!
    @IBOutlet weak var tomorrowDeliveryTimeView: UIView!
    @IBOutlet weak var txtExpressDelivary: UITextField!
    @IBOutlet weak var txtTodayDelivery: UITextField!{
        didSet{
            txtTodayDelivery.placeholder = "10-12PM".localized
        }
    }
    @IBOutlet weak var txtTomorrowDelivery: UITextField!{
        didSet{
            txtTomorrowDelivery.placeholder = "10-12PM".localized
        }
    }
    @IBOutlet weak var _lblExpressDelivery: UILabel!{
        didSet{
            _lblExpressDelivery.text = "delivery_express".localized
        }
    }
    @IBOutlet weak var _lblToday: UILabel!{
        didSet{
            _lblToday.text = "Today".localized
        }
    }
    @IBOutlet weak var lblSelectTime: UILabel!{
        didSet{
            lblSelectTime.text = "select_time".localized
        }
    }
    @IBOutlet weak var _lblTomorrow: UILabel!{
        didSet{
            _lblTomorrow.text = "Tomorrow".localized
        }
    }
    @IBOutlet weak var lblSelectTime1: UILabel!{
        didSet{
            lblSelectTime1.text = "Select time".localized
        }
    }
    @IBOutlet weak var _btnRadioExpressDelivery: UIButton!
    @IBOutlet weak var _btnRadioToday: UIButton!
    @IBOutlet weak var _btnRadioTomorrow: UIButton!
    
    @IBOutlet weak var _btnExpressSelectTime: UIButton!
    @IBOutlet weak var _btnTodaySelectTime: UIButton!
    @IBOutlet weak var _btnTomorrowSelectTime: UIButton!
    
    @IBOutlet weak var _lblSelectTimeTitle1: UILabel!
    @IBOutlet weak var _lblSelectTimeTitle2: UILabel!
    @IBOutlet weak var _lblSelectTimeTitle3: UILabel!
    
    var delegate: HDDeliveryOptionProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        todayDeliveryHeight.constant = 0
        // Initialization code
//        TotalViewHeight.constant = 390
//        tomorrowDeliveryHeight.constant = 0
        todaysDeliveryTimeView.isHidden = true
        tomorrowDeliveryTimeView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- Delivery Option
    
    @IBAction func expressDeliveryAction(_ sender: Any) {
          delegate?.hdParentExpress()
           UIView.animate(withDuration: 0.3) {
            self._viewToday.backgroundColor = UIColor(hexString: "FAFAFA")
            self._viewExpressDelivery.backgroundColor = UIColor(hexString: "FFFFFF")
            self._viewTomorrow.backgroundColor = UIColor(hexString: "FAFAFA")
               self.todayDeliveryHeight.constant = 0
            
               self.todaysDeliveryTimeView.isHidden = true
               self.tomorrowDeliveryTimeView.isHidden = true
//               self._viewExpressDelivery.shadowOpacity = 0
//               self._viewExpressDelivery.shadowOffset = CGSize(width: 0, height: 0)
//               self._viewExpressDelivery.shadowColor = .clear
               
               self._btnRadioExpressDelivery.setImage(UIImage(named: "radio_on"), for: .normal)
               self._btnRadioToday.setImage(UIImage(named: "radio_off"), for: .normal)
               self._btnRadioTomorrow.setImage(UIImage(named: "radio_off"), for: .normal)
           }
       }
    
       @IBAction func todaysDeliveryAction(_ sender: UIButton) {
        delegate?.hdParentToday()
           UIView.animate(withDuration: 0.3) {
            self.todayDeliveryHeight.constant = 87
            self.todaysDeliveryTimeView.isHidden = false
//               self.tomorrowDeliveryHeight.constant = 0
               self.tomorrowDeliveryTimeView.isHidden = true
//               self._viewToday.shadowOpacity = 0
//                self._viewToday.shadowOffset = CGSize(width: 0, height: 0)
//                self._viewToday.shadowColor = .clear
               
               
           self._btnRadioToday.setImage(UIImage(named: "radio_on"), for: .normal)
            self._btnRadioTomorrow.setImage(UIImage(named: "radio_off"), for: .normal)
            self._btnRadioExpressDelivery.setImage(UIImage(named: "radio_off"), for: .normal)
            self._viewToday.backgroundColor = UIColor(hexString: "FFFFFF")
            self.todaysDeliveryTimeView.backgroundColor =  UIColor(hexString: "FFFFFF")
            self._viewExpressDelivery.backgroundColor = UIColor(hexString: "FAFAFA")
            self._viewTomorrow.backgroundColor = UIColor(hexString: "FAFAFA")
           }
       }
       @IBAction func tomorrowDeliveryAction(_ sender: UIButton) {
        delegate?.hdParentTomorrow()
           UIView.animate(withDuration: 0.3) {
            self._viewToday.backgroundColor = UIColor(hexString: "FAFAFA")
            self._viewExpressDelivery.backgroundColor = UIColor(hexString: "FAFAFA")
            self._viewTomorrow.backgroundColor = UIColor(hexString: "FFFFFF")
            self.tomorrowDeliveryTimeView.backgroundColor = UIColor(hexString: "FFFFFF")
            self.todayDeliveryHeight.constant = 0
            self.todaysDeliveryTimeView.isHidden = true
            self._viewTomorrow.shadowOpacity = 0
            self._viewTomorrow.shadowOffset = CGSize(width: 0, height: 0)
            self._viewTomorrow.shadowColor = .clear
            self.tomorrowDeliveryHeight.constant = 87
            self.tomorrowDeliveryTimeView.isHidden = false

            self._btnRadioTomorrow.setImage(UIImage(named: "radio_on"), for: .normal)
            self._btnRadioToday.setImage(UIImage(named: "radio_off"), for: .normal)
               self._btnRadioExpressDelivery.setImage(UIImage(named: "radio_off"), for: .normal)
         }
       }
    
    @IBAction func expressSelectTimeAction(_ sender: Any) {
           
           delegate?.hdExpress()
       }
    @IBAction func todaySelectTimeAction(_ sender: Any) {
        delegate?.hdToday()
    }

    @IBAction func tomorrowSelectTimeAction(_ sender: UIButton) {
        delegate?.hdTomorrow()
    }
}
