// YPDrawSignatureView is open source
// Version 1.2.0
//
// Copyright (c) 2014 - 2018 The YPDrawSignatureView Project Contributors
// Available under the MIT license
//
// https://github.com/GJNilsen/YPDrawSignatureView/blob/master/LICENSE   License Information
// https://github.com/GJNilsen/YPDrawSignatureView/blob/master/README.md Project Contributors

import UIKit
import Alamofire

class ViewController: BaseVC, YPSignatureDelegate {
    
   
    @IBOutlet weak var signStack: UIStackView!
    // Connect this Outlet to the Signature View
    @IBOutlet weak var txtVerificationCode: UITextField!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var viewVerification: UIView!
    var strCode:String = ""
    var originalTimeStamp:String?
    var selectedRide:Rides?
 var timeInMinutes:String?
    var signatureImage:UIImage?
     var dataAns = NSMutableDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting this view controller as the signature view delegate, so the didStart(_ view: YPDrawSignatureView) and
        // didFinish(_ view: YPDrawSignatureView) methods below in the delegate section are called.
        let parameters = ["driverId":sharedAppDelegate().currentUser!.uId,
                          "tripId":selectedRide!.rideId]
        if dataAns.object(forKey: "verificationCodeRequired")as! String == "y" {
            signStack.isHidden = true
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.sendVerificationCode, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: "OK", completionBlock: {
                        let dict:NSDictionary = jsonDict?.value(forKey: "data") as! NSDictionary
                        self.strCode = String(format: "%d", dict.value(forKey: "verification_code")as? Int ?? 0)
                        self.txtVerificationCode.text = self.strCode
                        self.viewVerification.isHidden = false
                    })
                }
            }){ (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }
        
        
        signatureView.delegate = self
    }
    
    func callVerifyCode(){
        let alert = Alert()
        
        let parameters = ["driverId":sharedAppDelegate().currentUser!.uId,
                          "tripId":selectedRide!.rideId,
                          "verificationCode":txtVerificationCode.text!]
        
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.verifyCode, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: "OK", completionBlock: {
                        self.viewVerification.isHidden = true
                        self.signStack.isHidden = false
                    })
                }
            }){ (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClicksend(_ sender: UIButton) {
        if txtVerificationCode.text == "" {
            self.alert(title: "", message:"please enter verification code")
        }else if txtVerificationCode.text != strCode{
            self.alert(title: "", message:"please enter valid verification code")
        }else{
            self.callVerifyCode()
        }
    }

    @IBAction func clearSignature(_ sender: UIButton) {
        // This is how the signature gets cleared
        self.signatureView.clear()
    }
    
    // Function for saving signature
    @IBAction func saveSignature(_ sender: UIButton) {
        
        // Getting the Signature Image from self.drawSignatureView using the method getSignature().
        if let signature = self.signatureView.getSignature(scale: 10) {
        signatureImage = signature
            
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
        UIImageWriteToSavedPhotosAlbum(signature, nil, nil, nil)
        
            // Since the Signature is now saved to the Photo Roll, the View can be cleared anyway.
            //self.signatureView.clear()
       
        let endVC = FareSummaryVC(nibName:"FareSummaryVC", bundle: nil)
        
        endVC.originalTimeStamp = self.originalTimeStamp
        endVC.selectedRide = self.selectedRide
        endVC.signatureImg = signatureImage
        endVC.timeInMinutes = timeInMinutes
        self.navigationController?.pushViewController(endVC, animated: true)
        }
    }
    
    // MARK: - Delegate Methods
    
    // The delegate functions gives feedback to the instanciating class. All functions are optional,
    // meaning you just implement the one you need.
    
    // didStart() is called right after the first touch is registered in the view.
    // For example, this can be used if the view is embedded in a scroll view, temporary
    // stopping it from scrolling while signing.
    func didStart(_ view : YPDrawSignatureView) {
        print("Started Drawing")
    }
    
    // didFinish() is called rigth after the last touch of a gesture is registered in the view.
    // Can be used to enabe scrolling in a scroll view if it has previous been disabled.
    func didFinish(_ view : YPDrawSignatureView) {
        print("Finished Drawing")
         signatureImage = view.getSignature(scale: 10)!
    }
}
