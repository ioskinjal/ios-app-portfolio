//
//  AboutUSViewController.swift
//  LevelShoes
//
//  Created by Maa on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class AboutUSViewController: UIViewController {
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDesc.font = UIFont(name: "Cairo-Light", size: lblDesc.font.pointSize)
            }
        }
    }
   
   
    @IBOutlet weak var _lblTitle: UILabel!{
        didSet{
            _lblTitle.text = validationMessage.aboutCapital.localized
            _lblTitle.lineBreakMode = .byWordWrapping
            _lblTitle.numberOfLines = 0
            _lblTitle.textColor = UIColor.black
            _lblTitle.textAlignment = .center
            let textString = NSMutableAttributedString(string: _lblTitle.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 14)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.43
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: textRange)
            _lblTitle.attributedText = textString
            _lblTitle.sizeToFit()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                 _lblTitle.font = UIFont(name: "Cairo-SemiBold", size: _lblTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var _btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: _btnBack)
            }else{
                Common.sharedInstance.rotateButton(aBtn: _btnBack)
            }
        }
    }
    @IBOutlet weak var _imgView: UIImageView!
    @IBOutlet weak var _lblComanayName: UILabel!{
        didSet{
             _lblComanayName.text = validationMessage.aboutLevelShoes.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblComanayName.font = UIFont(name: "Cairo-SemiBold", size: _lblComanayName.font.pointSize)
            }
           
        }
    }
    @IBOutlet weak var _lblViewAbout: UILabel!{
        didSet{
            _lblViewAbout.lineBreakMode = .byWordWrapping
            _lblViewAbout.numberOfLines = 0
            _lblViewAbout.textColor = UIColor.black
            let textString = NSMutableAttributedString(string: _lblViewAbout.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 18)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.kern, value: 0.5, range: textRange)
            _lblViewAbout.attributedText = textString
            _lblViewAbout.sizeToFit()
        }
    }
    @IBOutlet weak var imgAbout: UIImageView!
    @IBOutlet weak var  _lblContactTitle: UILabel!{
        didSet{
            _lblContactTitle.text = validationMessage.aboutContactNumber.localized
        }
    }
    @IBOutlet weak var _lblContactNumber: UILabel!
    @IBOutlet weak var _btnContactNumber: UIButton!{
        didSet{
            _btnContactNumber.underlinesButton()
        }
    }
    @IBOutlet weak var _btnMoreDetails: UIButton!{
        didSet{
            _btnMoreDetails.titleLabel?.text = validationMessage.aboutMoreDetal.localized
            _btnMoreDetails.titleLabel?.lineBreakMode = .byWordWrapping
            _btnMoreDetails.titleLabel?.numberOfLines = 0
            _btnMoreDetails.titleLabel?.textColor = UIColor.black
            _btnMoreDetails.titleLabel?.textAlignment = .center
            let textContent = "MORE DETAILS"
            let textString = NSMutableAttributedString(string: (_btnMoreDetails.titleLabel?.text)!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Regular", size: 14)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.43
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: textRange)
            _btnMoreDetails.titleLabel?.attributedText = textString
            _btnMoreDetails.titleLabel?.sizeToFit()
        }
    }
    var AboutUsMoreView = Bundle.main.loadNibNamed("AboutUsMoreView", owner: self, options: nil)?.first as! AboutUsMoreView
    var aboutData : NewInData?
    override func viewDidLoad() {
        super.viewDidLoad()
        callAboutUs()
    }
    override func viewWillAppear(_ animated: Bool) {
        callAboutUs()
    }
    
    func callAboutUs(){
        let dictParam = ["identifier":"mobileapp_static_aboutus"]
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
                
                    self.aboutData = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
                DispatchQueue.main.async {
                    if self.aboutData != nil{
                    self.setData(data:(self.aboutData!))
                    }
                }
                    
                
            }
        }
    }

    
    func setData(data:NewInData){
        
        guard let items = data.hits?.hitsList else {
            return
        }
        if(items.count > 0){
        var containtText1 : String = data.hits?.hitsList[0]._source!.content.replaceString("\\r\\n", withString: "") ?? ""
        var containtText2 = containtText1.replaceString("\\", withString: "")
        
        if let dict = convertToDictionary(text: containtText2){
            let strDesc:String = dict["description"]as? String ?? ""
            self.lblDesc.setHTMLFromString(text: strDesc)
            //self.lblDesc.attributedText = strDesc.htmlToAttributedString
            self._lblComanayName.text = dict["subject"] as? String ?? ""
            self._btnContactNumber.setTitle(dict["tollfree"]as? String ?? "", for: .normal)
            self.imgAbout.downloadImage(from: dict["image"]as? String ?? "")
        }
        }
    }
    @IBAction func tapToBackButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapToMoreButton(_ sender: UIButton){
        self.AboutUsMoreView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 660 , width: UIScreen.main.bounds.width, height:560 )

        AboutUsMoreView.transform = CGAffineTransform(translationX: 0, y: 800)
        AboutUsMoreView._btnCloseButton.addTarget(self, action: #selector(self.closeMoreDetails), for: .touchUpInside)
        animateViewUp()
    }
    
    
    //MARK:- Animated View
    func animateViewUp() {
//        let diff = self.logoImageView.frame.maxY - (self.view.frame.height - self.chooceCountryView.frame.height)
//        let isCountryPickerOverlapLogo = diff > 0
//        if isCountryPickerOverlapLogo {
//            self.logoImageViewCenterY.constant = -diff-70
//        }
        UIView.animate(withDuration: 1.0, delay: 1, options: [.curveLinear], animations: {
            self.AboutUsMoreView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }, completion:nil)
        self.view.addSubview(AboutUsMoreView)
    }
    
    func animateViewDown() {
          UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
              self.AboutUsMoreView.frame.origin.y = self.view.bounds.height
              self.view.layoutIfNeeded()
              }, completion: { _ in
                  self.AboutUsMoreView.removeFromSuperview()
          })
      }
    @objc func closeMoreDetails(){
        animateViewDown()
    }
}
extension AboutUSViewController:NoInternetDelgate{
    func didCancel() {
        self.callAboutUs()
    }
}
extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}
