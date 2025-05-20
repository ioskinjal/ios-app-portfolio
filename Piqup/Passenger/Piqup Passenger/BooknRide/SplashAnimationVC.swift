//
//  SplashAnimationVC.swift
//  BooknRide
//
//  Created by NCrypted on 09/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import IQKeyboardManagerSwift

class SplashAnimationVC: UIViewController {
    
    @IBOutlet weak var animationImgView: UIImageView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageSelectionView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!{
        didSet{
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
    @IBOutlet weak var selectLanguageBtn: UIButton!
    var languageSelectionsItems = [Language]()
    var selectedLanguage:Language?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLanguage()
       
       

        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeAnimation), userInfo: nil, repeats: false)
        
        
        let jeremyGif = UIImage.gif(name: "white_bg_animation")
        
        //        let allImages = jeremyGif!.images
        //
        var final = [UIImage]()
        //
        for element in (jeremyGif?.images!)! {
            
            final.append(element)
        }
        
        //
        //        print(final)
        
//        animationImgView.animationImages = final
//        animationImgView.animationDuration = 3.0
//        animationImgView.animationRepeatCount = 1
//        animationImgView.startAnimating()
        
        //  var count = 0
        // animate( c: count, imageCount:final as NSArray)
        
    }
    
    @objc func removeAnimation(){
        
        let pausedTime:CFTimeInterval = animationImgView.layer .convertTime(CACurrentMediaTime(), from: nil)
        animationImgView.layer.speed = 0.0;
        animationImgView.layer.timeOffset = pausedTime;
        if Language.getLanguage().languageName.isEmpty{
            languageView.isHidden = false
        }else{
            languageView.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.removeSplashAndNavigateToRoot()
        }
        
    }
    
    @IBAction func btnSelectLanguageClicked(_ sender: Any) {
        languageSelectionView.isHidden = false
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        languageSelectionView.isHidden = true
        Language.saveLanguage(loggedUser: selectedLanguage!)
        fetchLanguageConst {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.removeSplashAndNavigateToRoot()
        }
    }
    
    
    func fetchLanguage(){
        WebRequester.shareManager.fetchLanguage { (language) in
            self.languageSelectionsItems = language
            self.pickerView.reloadAllComponents()
        }
    }
    func fetchLanguageConst(complete:@escaping()->Void){
        let alert = Alert()
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.languageConst, parameters: ["deviceId":CustomerDefaults.getDeviceToken(),"lId":Language.getLanguage().id], successBlock: { (json, urlResponse) in
            
            //            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                let data = jsonDict?.object(forKey: "response") as! [String:Any]
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = documentDirectory.appending("BooknRideConts.plist")
                
                
                let appConstData = NSDictionary(dictionary: data)
                let isWritten = appConstData.write(toFile: path, atomically: true)
                AppConst.shared.setConst(data: data)
                //                NotificationCenter.default.post(name: NSNotification.Name("ConstChnage"), object: nil)
                print("is the file created: \(isWritten)")
                complete()
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    //    func animate(c:Int, imageCount:NSArray){
    //
    //
    //        UIView.animate(withDuration: TimeInterval(1.0), animations: {
    //
    //            self.animationImgView.image = (imageCount.object(at: c) as! UIImage)
    //
    //
    //        }, completion: {
    //            (value: Bool) in
    //
    //            if c<imageCount.count-1{
    //            self.animate(c: c + 1, imageCount: imageCount)
    //            }
    //        })
    //    }
    
    //        // An animated UIImage
    //        let image = UIImage(named: "white_bg_animation.gif", in: Bundle(for: type(of: self)), compatibleWith: nil)
    //
    //        var test = AnimatedImage.init(source: image as! CGImageSource)
    //
    //
    //
    //        var images = [UIImage]()
    //       // let animation:UIImage = UIImage.animatedImageNamed("anim", duration: 10.0)!
    //
    //
    //        let img:UIImage = UIImage.animatedImageNamed("animat",duration: 5.0)!
    //
    //        animationImgView.image = img
    //        images = slice(image: image!, into: 2)
    //
    //        animationImgView.animationImages = images
    //        animationImgView.animationDuration = 10.0
    //        animationImgView.animationRepeatCount = 0
    //        animationImgView.startAnimating()
    
    
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Slice image into array of tiles
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - howMany: How many rows/columns to slice the image up into.
    ///
    /// - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
}

extension SplashAnimationVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageSelectionsItems.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return appConts.const.LBL_SELECT_LANGUAGE
        } else {
            return languageSelectionsItems[row - 1].languageName
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(row == 0) {
            
            self.selectedLanguage = Language(data: [:])
        } else{
            if languageSelectionsItems.count > 0{
                selectLanguageBtn.setTitle(self.languageSelectionsItems[row - 1].languageName, for: UIControlState.normal)
                self.selectedLanguage = self.languageSelectionsItems[row - 1]
            }
        }
    }
}


