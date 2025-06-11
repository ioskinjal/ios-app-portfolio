//
//  CodeVCViewController.swift
//  LevelShoes
//
//  Created by apple on 4/29/20.
//  Copyright © 2020 Mayank Bajpai. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import MBProgressHUD

class CodeVCViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var codeFirstTf: SkyFloatingLabelTextField!
    @IBOutlet weak var codeSecondTf: SkyFloatingLabelTextField!
    @IBOutlet weak var codeThirdTf: SkyFloatingLabelTextField!
    @IBOutlet weak var resendLbl: UILabel! {
        didSet {
            let strDont:String = "resend_code".localized
            resendLbl.attributedText = underlinedString(string: strDont as NSString, term: "Resend Code" as NSString)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                resendLbl.font = UIFont(name: "Cairo-Regular", size: resendLbl.font.pointSize)
            }
            
        }
    }
    @IBOutlet weak var topParentView: UIView!
    @IBOutlet weak var codeParentView: UIView!{
        didSet{
            //codeParentView.appearance
            //UIView.appearance().semanticContentAttribute = .forceLeftToRight
            //Locale(identifier: "en")
            codeParentView.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    
    @IBOutlet weak var codeFourth: SkyFloatingLabelTextField!
    @IBOutlet weak var timerLbl: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                timerLbl.font = UIFont(name: "Cairo-Regular", size: timerLbl.font.pointSize)
            }
            
        }
    }
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var resendBtn: UIButton!
    var codeCheck = ""
    @IBOutlet weak var createBtn: UIButton!
       {
           didSet{
            createBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            createBtn.setTitle("VERIFY & PROCEED".localized, for: .normal)
            createBtn.setBackgroundColor(color: colorNames.c7C7, forState: .normal)
            createBtn.isUserInteractionEnabled = false
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                createBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
           }
       }
    var fourUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 4 leading zeros with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
            // generate another random number if the set of characters count is less than four
        } while Set(result).count < 4
        return result    // ran 5 times
    }
    @IBOutlet weak var titleLbl: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                titleLbl.font = UIFont(name: "Cairo-SemiBold", size: titleLbl.font.pointSize)
            }
        }
    }
    @IBOutlet weak var verifyLbl: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                verifyLbl.font = UIFont(name: "Cairo-SemiBold", size: verifyLbl.font.pointSize)
            }
        }
    }
    @IBOutlet weak var enterLbl: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                enterLbl.font = UIFont(name: "Cairo-SemiBold", size: enterLbl.font.pointSize)
            }
        }
    }
    var strEmail = ""
    var reseToken = ""
    var Seconds = 60
    var timer = Timer()
    static var storyboardInstance:CodeVCViewController? {
        return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: CodeVCViewController.identifier) as? CodeVCViewController
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "codeval_lbl".localized
        enterLbl.text = "fourdigit_lbl".localized
        verifyLbl.text = "verify_lbl".localized
        codeFirstTf.addTarget(self, action: #selector(didChangeTextValue), for: .editingChanged)
        codeSecondTf.addTarget(self, action: #selector(didChangeSecondTextValue), for: .editingChanged)
        codeThirdTf.addTarget(self, action: #selector(didChangethirdTextValue), for: .editingChanged)
        codeFourth.addTarget(self, action: #selector(didChangeFourthTextValue), for: .editingChanged)
        codeFirstTf.textAlignment = .center
        codeSecondTf.textAlignment = .center
        codeThirdTf.textAlignment = .center
        codeFourth.textAlignment = .center
        
        self.setupTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(true)
           codeFirstTf.becomeFirstResponder()
    }
    
    func underlinedString(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: string as String)
        let underlineRange = string.range(of: term as String)
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)

        return output
    }
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    func activateButton(){
        codeCheck = codeFirstTf.text! + codeSecondTf.text! + codeThirdTf.text! + codeFourth.text!
        
        if codeCheck.count == 4 {
            createBtn.setBackgroundColor(color: .black, forState: .normal)
            createBtn.isUserInteractionEnabled = true
        }else{
            createBtn.setBackgroundColor(color: colorNames.c7C7, forState: .normal)
            createBtn.isUserInteractionEnabled = false
        }
    }
    @objc func onTimerFires() {
        Seconds -= 1
       // timerLbl.text = "Code expires in :" + "\(Seconds) seconds left"
        timerLbl.text = "code_expire".localized + " : " + "00:\(Seconds)"
        var myMutableStringTitle = NSMutableAttributedString()
                      let Name: String?  = timerLbl.text
                   myMutableStringTitle = NSMutableAttributedString(string:Name!)
                   let range = (myMutableStringTitle.string as NSString).range(of: "00:\(Seconds)")
                   myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)
         timerLbl.attributedText = myMutableStringTitle

        if Seconds <= 0 {
            self.timer.invalidate()
            self.timerLbl.isHidden = true
            self.resendBtn.isHidden = false
            self.resendLbl.isHidden = false
            UserDefaults.standard.set("00", forKey: "defaultToken")
        }
    }

    @objc func didChangeTextValue(textField :SkyFloatingLabelTextField)
       {
        if textField.text?.count == 1 {
        codeSecondTf.becomeFirstResponder()
        textField.errorMessage = nil
        codeFirstTf.text  = textField.text!
        imageOne.isHidden = true
        codeFirstTf.lineColor = UIColor.lightGray
            activateButton()
        }
       }
    @objc func didChangeSecondTextValue(textField :SkyFloatingLabelTextField)
         {
                   if textField.text?.count == 1{
                     codeThirdTf.becomeFirstResponder()
                     textField.errorMessage = nil
                     codeSecondTf.text  = textField.text!
                     imageTwo.isHidden = true
                    codeSecondTf.lineColor = UIColor.lightGray
                    activateButton()
                     }
             else{
                   activateButton()
              codeFirstTf.becomeFirstResponder()
            }
         }
    @objc func didChangethirdTextValue(textField :SkyFloatingLabelTextField)
         {
                   if textField.text?.count == 1 {
                     codeFourth.becomeFirstResponder()
                     textField.errorMessage = nil
                     codeThirdTf.text  = textField.text!
                     imageThree.isHidden = true
                    codeThirdTf.lineColor = UIColor.lightGray
                    activateButton()
                     }
             else{
                activateButton()
              codeSecondTf.becomeFirstResponder()
                
            }

         }
    @objc func didChangeFourthTextValue(textField :SkyFloatingLabelTextField)
         {
                   if textField.text?.count == 1 {
                     codeFourth.becomeFirstResponder()
                     textField.errorMessage = nil
                     codeFourth.text  = textField.text!
                     imageFour.isHidden = true
                    codeFourth.lineColor = UIColor.lightGray
                    print("CHECKER \(codeCheck.count) and value \(codeCheck)")
                    activateButton()
                     }
                   else{
                     activateButton()
                    codeThirdTf.becomeFirstResponder()
                  }
         }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return false
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        print("INside Delegate Method \(codeCheck)")

        return newString.length <= maxLength
    }
    func checkcode ()
    {
         //let languageStr  = Locale.current.languageCode
        var combineCode : String  = codeFirstTf.text! + codeSecondTf.text! + codeThirdTf.text! + codeFourth.text!
        print("COmbine Code \(combineCode)")
        
//        if languageStr != string.en {
//            let reversedString = String(combineCode.reversed())
//            combineCode = reversedString
//        }
         if (combineCode == "")
           {
                 self.alert(title:"Error", message: "Please enter code")
           }
       else if (combineCode !=  UserDefaults.standard.value(forKey: "defaultToken") as? String) {
             self.alert(title:"Error", message: "Please enter valid code")
        }
        else
        {
            self.navigationController?.pushViewController(ChangePasswordVC.storyboardInstance!, animated: true)
        }
    }
    
    
    func callResetPasswordApi ()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
              //let randonToken = Int.random(in: 0 ... 3)
             let randonToken = fourUniqueDigits
        UserDefaults.standard.set(randonToken, forKey: "defaultToken")
        print("Usr RESENT PASS -- \(randonToken)")
              let params = [
                "email" :UserDefaults.standard.value(forKey: "userEmail") as Any ,
                  "mobiletoken" : randonToken,
                  "websiteid": getWebsiteId()
                  ] as [String : Any] as [String : Any]
              let storeCode:String = UserDefaults.standard.value(forKey: "storecode") as! String
              let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.kResetPasword
        print("Print RESEND COde \(url) \n \(params)")
              ApiManager.apiPut(url: url, params: params) { (response, error) in
                  MBProgressHUD.hide(for: self.view, animated: true)
                  if let error = error{
                      print(error)
                      if error.localizedDescription.contains(s: "offline"){
                          let nextVC = NoInternetVC.storyboardInstance!
                          nextVC.modalPresentationStyle = .fullScreen
                          nextVC.delegate = self
                      }
                      self.sharedAppdelegate.stoapLoader()
                      return
                  }
                  if response != nil{
                    UserDefaults.standard.set(response?.description, forKey: "userTokenforchangePassword")
                     self.alert(title:"LevelShoes", message: "Varification code resent")
                     self.afterResendButtonClick()

                    
//                      let dict = ["token" : response?.rawString()]
//                      let nextVC = ChangePasswordVC.storyboardInstance!
//                      nextVC.strEmail = self.strEmail
//                      if response?.dictionaryObject?.count != 1  && response?.dictionaryObject?.count != nil{
//                      self.alert(title:"Error", message: "Something went wrong")
//
//                      }else{
//                        let alert = UIAlertController(title: "LevelShoes", message:"Varification code resent " , preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                            self.afterResendButtonClick()
//                        }))
////                          nextVC.reseToken = dict["token"]! ?? ""
////                           self.navigationController?.pushViewController(nextVC, animated: true)
//                      }
                  }
              }
    }
    func afterResendButtonClick(){
        if self.timerLbl.isHidden {
            Seconds = 60
            
            timerLbl.text = "code_expire".localized + " : " + "00:\(Seconds)"
            var myMutableStringTitle = NSMutableAttributedString()
                          let Name: String?  = timerLbl.text
                       myMutableStringTitle = NSMutableAttributedString(string:Name!)
                       let range = (myMutableStringTitle.string as NSString).range(of: "00:\(Seconds)")
                       myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)
             timerLbl.attributedText = myMutableStringTitle
            timerLbl.isHidden = false
            resendLbl.isHidden = true
            resendBtn.isHidden = true
            self.setupTimer()
        }
    }
    
    // MARK : UIButton Actions
    
    @IBAction func onClickResendBtn(_ sender: Any) {
        self.callResetPasswordApi()
//        if isAllValid()
//        {
//
//            let finalCode = "\(codeFirstTf.text!)" + "\(codeSecondTf.text!)" + "\(codeThirdTf.text!)" + "\(codeFourth.text!)"
//                  if (finalCode ==  UserDefaults.standard.value(forKey: "defaultToken") as? String) {
//                       self.alert(title:"Error", message: "Please enter valid code")
//                  }
//                  else
//                  {
//                    self.callResetPasswordApi()
//                  }
//        }
    }
    
    @IBAction func onClickValidateBt(_ sender: Any) {
        
        if isAllValid() {
            self.checkcode()
        }
    }
    
    @IBAction func onClickCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK : Validation
    
  func isAllValid() -> Bool {
    var isValid = false
        if codeFirstTf.text == "" {
            imageOne.isHidden = false
            codeFirstTf.lineColor = UIColor.red
            
        }
        else if codeSecondTf.text == "" {
            imageTwo.isHidden = false
            codeSecondTf.lineColor = UIColor.red
        
        }
       else if codeThirdTf.text == "" {
            imageThree.isHidden = false
            codeThirdTf.lineColor = UIColor.red
        }
       else if codeFourth.text == "" {
            imageFour.isHidden = false
            codeFourth.lineColor = UIColor.red
        }
        else
        {
            isValid = true
        }
   
       return isValid
    }
}
extension CodeVCViewController:NoInternetDelgate{
    func didCancel() {
        self.callResetPasswordApi()
    }
}
