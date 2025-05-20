//
//  RideNowVC.swift
//  Carry
//
//  Created by NCrypted on 20/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var dictParam = [String:Any]()
class RideNowVC: BaseVC {

    
    @IBOutlet weak var lblVerificationAmmount: UILabel!
    @IBOutlet weak var txtTime: UITextField!{
        didSet{
            let datePickerView =  UIDatePicker()
            datePickerView.datePickerMode = .time
            let today = Date()
            let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: today)
            datePickerView.minimumDate = nextDate
            datePickerView.addTarget(self, action: #selector(timeDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtTime.inputView = datePickerView
            
        }
    }
    @IBOutlet weak var txtDate: UITextField!{
        didSet{
            let datePickerView =  UIDatePicker()
            datePickerView.datePickerMode = .date
            let today = Date()
           // let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
            let calendar = Calendar.current
            
            let strCurrentYear = calendar.component(.year, from: today)
          //  let strCurrentMonth = calendar.component(.month, from: today)
            let strMaxDate = "31-December/-\(strCurrentYear)"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMMM-yyyy"
            let maxDate:Date = formatter.date(from: strMaxDate) ?? Date()
            datePickerView.minimumDate = today
            datePickerView.maximumDate = maxDate
            datePickerView.addTarget(self, action: #selector(dateDiveChanged(_:)), for: UIControlEvents.valueChanged)
            txtDate.inputView = datePickerView
            
        }
    }
    @IBOutlet weak var stackViewDate: UIStackView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var imgvehicle: UIImageView!
    @IBOutlet weak var lblVehichleName: UILabel!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCoins: UIView!{
        didSet{
            viewCoins.layer.borderColor = UIColor(red: 230, green: 230, blue: 230).cgColor
        }
    }
    @IBOutlet weak var viewWallet: UIView!{
        didSet{
            viewWallet.layer.borderColor = UIColor(red: 230, green: 230, blue: 230).cgColor
        }
    }
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var viewFareEstimation: UIView!
    @IBOutlet weak var imgcheck1: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var btnCash: UIButton!
    var strWalletMethod = String()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
            
        }
    }
    
    @objc func dateDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDate.text = formatter.string(from: sender.date)
        dictParam["scheduledDatetime"] = txtDate.text! + " " + txtTime.text!
    }
    
    @objc func timeDiveChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        txtTime.text = formatter.string(from: sender.date)
        dictParam["scheduledDatetime"] = txtDate.text! + " " + txtTime.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         dictParam["isScheduled"] = "0"
        if sharedAppDelegate().currentUser?.defaultPaymentMethod == "w"{
            onClickPaymentMethod(btnWallet)
        }else if sharedAppDelegate().currentUser?.defaultPaymentMethod == "c"{
            onClickPaymentMethod(btnCash)
        }else{
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickPaymentMethod(_ sender: UIButton) {
        if sender.tag == 0{
            strWalletMethod = "w"
            imgcheck1.isHidden = true
            imgCheck.isHidden = false
        }else{
            strWalletMethod = "c"
            imgcheck1.isHidden = false
            imgCheck.isHidden = true
        }
        self.callFareEstimation()
    }
    
    @IBAction func onClickScheduleRequest(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "Checkbox") {
            sender.setImage(#imageLiteral(resourceName: "Checkbox-checked"), for: .normal)
            dictParam["scheduledDatetime"] = txtDate.text! + " " + txtTime.text!
            stackViewDate.isHidden = false
            dictParam["isScheduled"] = "1"
        }else{
            sender.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)
            dictParam["isScheduled"] = "0"
             stackViewDate.isHidden = true
        }
    }
    @IBAction func onClickBookNRide(_ sender: UIButton) {
        if strWalletMethod == ""{
            self.alert(title: "", message: "please select payment method")
        }else if dictParam["isScheduled"]as! String == "1" && txtDate.text == "" {
            self.alert(title: "", message: "please select date")
        }else if dictParam["isScheduled"]as! String == "1" && txtTime.text == "" {
            self.alert(title: "", message: "please select time")
        }
        else{
            dictParam["paymentType"] = strWalletMethod
            callBookRide()
        }
        
    }
    
    func callBookRide(){
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let alert = Alert()
            
            dictParam["custId"] = sharedAppDelegate().currentUser?.uId
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Book.confirmRide, parameters: dictParam, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    let array:NSArray = jsonDict!["dataAns"]as! NSArray
                    let dataAns:NSDictionary = array[0] as! NSDictionary
                    print("Items \(dataAns)")
                    
                    
                    DispatchQueue.main.async {
                        
                    alert.showAlertWithCompletionHandler(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                        
                        UserDefaults.standard.removeObject(forKey:"lastSendId")
                            UserDefaults.standard.synchronize()
                            
                            let bookNowVC = HomeVC(nibName: "HomeVC", bundle: nil)
                        self.navigationController?.pushViewController(bookNowVC, animated: true)
                      //  let loaderView = self.view.window
                       // loaderView?.makeToast(message)
                        
                    })
                    }
                }
                else{
                    DispatchQueue.main.async {
                      
                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func callFareEstimation(){
        var param =  [String:Any]()
        param = ["verificationCodeRequired":dictParam["verificationCodeRequired"]!,
                     "logistic_category":dictParam["logistic_category"]!,
                     "carTypeId":dictParam["carTypeId"]!,
                     "subCarTypeId":dictParam["subCarTypeId"]!,
                     "pickupLat":dictParam["pickUpLat"]!,
                     "pickupLong":dictParam["pickUpLong"]!,
                     "dropoffLat":dictParam["dropOffLat"]!,
                     "dropoffLong":dictParam["dropOffLong"]! ]
        print(param)
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let alert = Alert()
            
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Fare.estimate, parameters: param, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        let array:NSArray = jsonDict!["dataAns"]as! NSArray
                        let dataAns:NSDictionary = array[0] as! NSDictionary
                        self.viewFareEstimation.isHidden = false
                        self.lblPickUpLocation.text = dataAns.value(forKey: "pickUpLocation")as? String
                        self.lblDropLocation.text = dataAns.value(forKey: "dropOffLocation")as? String
                        self.lblTime.text = String(format: "%d", dataAns.value(forKey: "estimateTime") as! Int)
                        self.lblCoin.text = dataAns.value(forKey: "fareTimeCharges") as? String
                        self.lblCurrency.text = dataAns.value(forKey: "timeChargesPerMin") as? String
                        
                        self.lblVehichleName.text = dataAns.value(forKey: "carTypeName")as? String
                        self.lblVehicleType.text = dataAns.value(forKey: "subCarTypeName")as? String
                        let strSub:String = dataAns.value(forKey: "carTypeImage")as! String
                        let imageUrl = URLConstants.Domains.CarUrl + strSub
                        
                        let cache = UIImageView.af_sharedImageDownloader.imageCache;
                        
                        let url = NSURL(string: imageUrl)!
                        
                        
                       
                      
                        if dataAns.value(forKey: "verificationCodeAmount")as? Int != 0{
                              self.lblVerificationAmmount.text = String(format: "Verification Code Ammount is: $%d", dataAns.value(forKey: "verificationCodeAmount")as? Int ?? 0)
                        }else{
                             self.lblVerificationAmmount.text = ""
                        }
                        
                        // Retrieve image from memory or disk.
                        let req = URLRequest(url: url as URL)
                        if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
                            // Image is set the second time imageForRequest is called.
                            self.imgvehicle.image = cacheImage
                            // selectedCell.carActivityIndicator.stopAnimating()
                            //print("image in cache!");
                        } else {
                            // selectedCell.carActivityIndicator.startAnimating()
                            self.imgvehicle.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                                if response.data != nil {
                                    
                                    let downloadedImage = UIImage.init(data: response.data!)
                                    if downloadedImage != nil{
                                       self.imgvehicle.image = downloadedImage;
                                        
                                    }
                                    else{
                                        self.imgvehicle.image = #imageLiteral(resourceName: "rides_icon")
                                        
                                    }
                                
                                    
                                    self.imgvehicle.contentMode = .scaleAspectFit
                                }
                                
                            })
                            
                        }
                       
                    }
                        
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
//                        self.callFareEstimation()
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewFareEstimation.isHidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
