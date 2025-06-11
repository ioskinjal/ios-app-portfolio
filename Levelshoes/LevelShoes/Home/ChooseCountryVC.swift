//
//  ChooseCountryVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 24/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVFoundation
import SwiftSVG

class ChooseCountryVC: UIViewController {

    static var storyboardInstance:ChooseCountryVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: ChooseCountryVC.identifier) as? ChooseCountryVC
        
    }
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblChoose: UILabel!{
        didSet{
            lblChoose.text = "Choose a country".localized
        }
    }
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            btnContinue.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            btnContinue.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            
            
            btnContinue.setTitle("CONTINUE".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnContinue.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var btnNotfy: UIButton!
    
     var player: AVPlayer?
    var selectedStoreCode = ""
    var selectedCountry = ""
    let countryPicker = UIPickerView()
    @IBOutlet weak var lblEnable: UILabel!{
        didSet{
            lblEnable.textColor=UIColor(hexString: "616161")
            lblEnable.font = lblEnable.font.withSize(16)
            lblEnable.addTextSpacing(spacing:0)
            
            lblEnable.text = "Enable Notifications to stay up - to - date on latest collections and offers".localized
        }
    }
    @IBOutlet weak var txtCountry: UITextField!{
        didSet{
            countryPicker.delegate = self
                      self.txtCountry.inputView = self.countryPicker
                       //txtCountry.delegate = self
            let image = SVGView.init(SVGNamed: "ic_dropdown")
            txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
            txtCountry.placeholder = "Select Country".localized
            txtCountry.addTarget(self, action: #selector(onTap(_:)), for: .touchDown)
            txtCountry.addTarget(self, action: #selector(onEnd(_:)), for: .editingDidEnd)
            
        }
        
    }
    
    @objc func onTap(_ sender:UITextField){
        txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_up"))
        if txtCountry.text == ""{
        btnContinue.isUserInteractionEnabled = false
               btnContinue.alpha = 0.5
        }else{
            btnContinue.isUserInteractionEnabled = true
            btnContinue.alpha = 1.0
        }
        txtCountry.text = data?._source?.countryList[0].name
        selectedStoreCode = data!._source?.countryList[0].storecode as! String
        selectedCountry = data?._source?.countryList[0].name as! String
        selectedCountry =  selectedCountry.replaceString(" ", withString: "")
        
    }
    @objc func onEnd(_ sender:UITextField){
           txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
        if txtCountry.text == ""{
        btnContinue.isUserInteractionEnabled = false
               btnContinue.alpha = 0.5
        }else{
            btnContinue.isUserInteractionEnabled = true
            btnContinue.alpha = 1.0
        }
       }
    @IBOutlet weak var imgFlag: UIImageView!
    var data : onBoardingData?

         
       
    override func viewDidLoad() {
        super.viewDidLoad()
       data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
         self.countryPicker.reloadAllComponents()
        btnContinue.isUserInteractionEnabled = false
        btnContinue.alpha = 0.5
        
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
       
     
        
         let top = CGAffineTransform(translationX: 0, y: -430)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
            
              self.viewCountry.transform = top
            self.viewOverlay.isHidden = false
           
            
        }, completion: nil)
        
        if data?._source?.onBoardingList[0].type == "video"{
            if data?._source?.onBoardingList[0].status == "active" {
                self.loadVideo()
            }
        }else{
            imgLogo.sd_setImage(with: URL(string:(data?._source?.introImage)!), placeholderImage: UIImage(named: "logo_white"))
            self.imgBack.downLoadImage(url: (data?._source?.onboardingImage)!)
        }
        
       
    }
    
    
    private func loadVideo() {
        
        
        player = AVPlayer(url: URL(string: (data?._source?.onBoardingList[0].url)!)!)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        self.view.layer.addSublayer(playerLayer)
        
        player?.seek(to:kCMTimeZero)
        player?.play()
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
   
    
    //MARK:- UIButton Click Events
    
   
    @IBAction func onClickNotify(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "ic_switch_on"){
            UIView.transition(with: sender, duration: 1.0, options: .transitionCrossDissolve, animations: {
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
            }, completion: nil)
        }else{
            UIView.transition(with: sender, duration: 1.0, options: .transitionCrossDissolve, animations: {
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
            }, completion: nil)
            
        }
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
         
         UserDefaults.standard.setValue(selectedCountry, forKey: "country")
        self.navigationController?.pushViewController(SelectCategoryViewController.storyboardInstance!, animated: true)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChooseCountryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?._source?.countryList.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCountry.text = data?._source?.countryList[row].name
        selectedStoreCode = data?._source?.countryList[row].storecode as!
        String
        
        selectedCountry = data?._source?.countryList[row].name as! String
       selectedCountry =  selectedCountry.replaceString(" ", withString: "")
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = data?._source?.countryList[row].name
        return label
    }
}
//extension ChooseCountryVC:UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
//        return true
//    }
//     func textFieldDidEndEditing(_ textField: UITextField) {
//
//           txtCountry.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "ic_dropdown"))
//    }
//
//}
