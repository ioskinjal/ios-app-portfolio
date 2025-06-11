//
//  ControllerExtension.swift
//  LevelShoes
//
//  Created by Maa on 04/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SDWebImage

struct DateUtils{
    static func compareDate(date1:Date, date2:Date ) -> Int{
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        
        switch order {
        case .orderedDescending:
            return 2 // greater than
        case .orderedAscending:
            return 1 // less than
        case .orderedSame:
            return 0 // same
        }
    }
}

extension  UIViewController {
    
    func checkForBlank(text: String) -> Bool {
        
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    func showIndicator(withTitle title: String, and Description:String) {
          
          let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
          Indicator.label.text = title
          Indicator.isUserInteractionEnabled = false
          Indicator.detailsLabel.text = Description
          Indicator.show(animated: true)
      }
      func hideIndicator() {
          
          MBProgressHUD.hide(for: self.view, animated: true)
      }
      
      
      func showIndicatorForGIF(to:UIView, withTitle:String, subTitle:String, animated:Bool, gifName:String, ofType:String, isBackgroundShadow:Bool = false){
          
          var progressHud = MBProgressHUD()
          progressHud = MBProgressHUD.showAdded(to: to, animated: animated)
          
          progressHud.label.text = withTitle
          progressHud.detailsLabel.text = subTitle
          progressHud.bezelView.color = UIColor.clear
          let imageViewAnimatedGif = UIImageView()
          //The key here is to save the GIF file or URL download directly into a NSData instead of making it a UIImage. Bypassing UIImage will let the GIF file keep the animation.
          let filePath = Bundle.main.path(forResource: gifName, ofType: ofType)
          let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
          imageViewAnimatedGif.image = UIImage.sd_image(with: gifData)
          //imageViewAnimatedGif.image = UIImage.sd_animatedGIF(with: gifData)
          progressHud.customView = UIImageView(image: imageViewAnimatedGif.image)
          var rotation: CABasicAnimation?
          rotation = CABasicAnimation(keyPath: "transform.rotation")
          rotation?.fromValue = nil
          // If you want to rotate Gif Image Uncomment
          //  rotation?.toValue = CGFloat.pi * 2
          rotation?.duration = 0.7
          rotation?.isRemovedOnCompletion = false
          progressHud.customView?.layer.add(rotation!, forKey: "Spin")
          progressHud.mode = MBProgressHUDMode.customView
          // Change hud bezelview Color and blurr effect
          progressHud.bezelView.color = UIColor.clear
          progressHud.bezelView.tintColor = UIColor.clear
          progressHud.bezelView.style = .solidColor
          progressHud.bezelView.blurEffectStyle = .dark
          // Speed
          rotation?.repeatCount = .infinity
          progressHud.backgroundColor = UIColor.black.withAlphaComponent(0.5)
          progressHud.show(animated: true)
      }
      
      
      func getDocumentPath(fileExtension: String) -> String {
          
          let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileExtension)
          
          return paths
      }
      
      func stringFromDate(date: Date, format: String) -> String{
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = format //Your date format
          dateFormatter.timeZone = TimeZone.current
          let date = dateFormatter.string(from: date)
          return date
      }
      
      
      func getUpdatedDate(date: String, isShowToday : Bool) -> String
      {
          if date != "" {
              
              let dateFormatterGet = DateFormatter()
              dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
              
              let dateFormatterPrint = DateFormatter()
              dateFormatterPrint.dateFormat = "MMM dd, yyyy"
              
              
              let dates: NSDate? = dateFormatterGet.date(from: date) as NSDate?
              
              
              
              
              let currentDateTime = Date()
              let format = DateFormatter()
              format.dateFormat = "MM-dd-YYYY"
              
              //            let formattedDate = format.string(from: currentDateTime)
              if isShowToday
              {
                  if  DateUtils.compareDate(date1: dates! as Date, date2: currentDateTime) == 0
                  {
                      return "Today"
                  }else
                  {
                      return dateFormatterPrint.string(from: dates! as Date)
                  }
              }
              else
              {
                  return dateFormatterPrint.string(from: dates! as Date)
              }
          }else
          {
              return ""
          }
      }
      var topbarHeight: CGFloat {
          
          let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
              (self.navigationController?.navigationBar.frame.height ?? 0.0)
          
          return topBarHeight
          //return (view.window?.windowLevel.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
      }
      
      
      //1 STRING FROM ANY VALUE
      func stringFromAny( value:Any?) -> String {
          
          if let nonNil = value, !(nonNil is NSNull) {
              return String(describing: nonNil)
          }
          return ""
      }
      
      
      
      //2 BOOL FROM ANY VALUE
      func boolFromAny(_ value:Any?) -> Bool {
          
          if let nonNil = value, !(nonNil is NSNull) {
              if (nonNil is Bool) {
                  return nonNil as! Bool
              }
              if (nonNil is String) {
                  if (nonNil as! String).isEmpty {return false}
              }
              
              return (Int(nonNil as! String)! > 0) ? true : false
          }
          return false
      }
      
      //3 BOOL FROM ANY VALUE
      func intFromAny(_ value:Any?) -> Int {
          
          if let nonNil = value, !(nonNil is NSNull) {
              if (nonNil is NSNumber) {
                  return nonNil as! Int
              }
              if (nonNil is String) {
                  if (nonNil as! String).isEmpty {return 0}
              }
              return (Int(nonNil as! String)! > 0) ? Int(nonNil as! String)! : 0
          }
          return 0
      }
      
      
      func check_for_blank_text(text:String)->Bool {
          if(text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0) {
              return true
          }
          return false
      }
}
