//
//  PrivacyPolicyViewController.swift
//  LevelShoes
//
//  Created by Maa on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    var screenType = ""
    
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
            }else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = validationMessage.privacyCapital.localized
            lblTitle.lineBreakMode = .byWordWrapping
            lblTitle.numberOfLines = 0
            lblTitle.textColor = UIColor.black
            lblTitle.textAlignment = .center
            let textString = NSMutableAttributedString(string: lblTitle.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 14)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.43
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: textRange)
            lblTitle.attributedText = textString
            lblTitle.sizeToFit()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var txtViewContent: UITextView!{
        didSet{
            
        }
    }
    @IBOutlet weak var lblFirstQuestion: UILabel!{
        didSet{
//            let textLayer = UILabel(frame: CGRect(x: 30, y: 140, width: 315, height: 54))
            lblFirstQuestion.lineBreakMode = .byWordWrapping
            lblFirstQuestion.numberOfLines = 0
            lblFirstQuestion.textColor = UIColor.black
//            let textContent = "Privacy policy of Level Shoes mobile application"
            let textString = NSMutableAttributedString(string: lblFirstQuestion.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 20)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.35
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            lblFirstQuestion.attributedText = textString
            lblFirstQuestion.sizeToFit()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFirstQuestion.font = UIFont(name: "Cairo-SemiBold", size: lblFirstQuestion.font.pointSize)
            }
//            self.view.addSubview(textLayer)
        }
    }
    @IBOutlet weak var lblSecondQuestion: UILabel!{
           didSet{
               lblSecondQuestion.lineBreakMode = .byWordWrapping
               lblSecondQuestion.numberOfLines = 0
               lblSecondQuestion.textColor = UIColor.black
            let textString = NSMutableAttributedString(string: lblSecondQuestion.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 18)!
               ])
               let textRange = NSRange(location: 0, length: textString.length)
               let paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
               lblSecondQuestion.attributedText = textString
               lblSecondQuestion.sizeToFit()
           }
       }
    @IBOutlet weak var lblFirstAnswer: UILabel!{
           didSet{
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                   lblFirstAnswer.font = UIFont(name: "Cairo-Light", size: lblFirstAnswer.font.pointSize)
               }
           }
       }
    @IBOutlet weak var lblSecondAnswer: UILabel!{
        didSet{
            
        }
    }
    @IBOutlet weak var txtBackgowndView: UIView!
    
     var privacyData : NewInData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callPrivasyPolicy()
        // Do any additional setup after loading the view.
    }
    
    
    func callPrivasyPolicy(){
         var dictParam = ["identifier":""]
        if screenType == "PrivacyPolicy" {
            dictParam["identifier"] = "mobileapp_static_privacypolicy"
        }else if screenType == "TermsAndCondition" {
             dictParam["identifier"] = "mobileapp_static_terms"
        }
       
        var dictMatch = [String:Any]()
        dictMatch["match"] = dictParam
        var arrMust = [[String:Any]]()
        arrMust.append(dictMatch)
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        let param = ["query":dictBool]
        print(param)
        
        let storeCode="\(CommonUsed.globalUsed.productIndexName)_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        
        let url = CommonUsed.globalUsed.main + "/" +  storeCode + "/" + CommonUsed.globalUsed.cmsBlockDoc + "/" + CommonUsed.globalUsed.ESSearchTag
        
        ApiManager.apiPost(url: url, params: param as [String : Any]) { (response, error) in
            
            if let error = error{
                //print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            
            // try! realm.add(response)
            
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                    self.privacyData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async {
                    if self.privacyData != nil{
                    self.setData(data:(self.privacyData!))
                    }
                }
                    
                
            }
        }
    }
    
    func setData(data:NewInData){
        guard let items = data.hits?.hitsList else {
            return
        }
        if (data.hits?.hitsList.count)! > 0 {
            self.lblTitle.text = data.hits?.hitsList[0]._source?.title
            
            let d = convertToDictionary(text: data.hits?.hitsList[0]._source!.content ?? "")
            
            let strDesc:String = d?["description"]as? String ?? ""
            self.lblFirstQuestion.text = d?["title"]as? String ?? ""
            self.lblFirstAnswer.setHTMLFromString(text: strDesc)
            //self.lblFirstAnswer.attributedText = strDesc.htmlToAttributedString
        }
        
    }
    
    @IBAction func onClickDeviceInfo(_ sender: Any) {
        //let deviceId = Bundle.main.deviceId
        let deviceId = "device_id".localized
        let build = "build".localized
        let versionBuild = Bundle.main.releaseVersionNumber! + " (" + Bundle.main.buildVersionNumber! + ")"
        var message = "\(deviceId) " + adjustDeviceId + "\n"
        message = message + "\(build) " + versionBuild
        
        let alert = UIAlertController(title: "device_info".localized , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action) in
                     
                  }))
            
        alert.addAction(UIAlertAction(title: "copy".localized, style: .cancel, handler: {
            (action) in
            UIPasteboard.general.string = message
        }))
                        
                  self.present(alert, animated: true, completion: nil)
    }
    
     @IBAction func TapToBack(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
       
       func textViewDidBeginEditing(_ textView: UITextView) {
           print("print1")
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           print("print2")
       }

}
extension PrivacyPolicyViewController:NoInternetDelgate{
    func didCancel() {
        self.callPrivasyPolicy()
    }
}
