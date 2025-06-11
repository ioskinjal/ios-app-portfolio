//
//  common.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
class Common: NSObject {
    typealias orderStatus = (name: String, color: UIColor)
    typealias contryWithCode = (countryName: String, countryCode: String)
    // Declare class instance property
    static let sharedInstance = Common()
    static let blackColor : String = "#000000"
    static let whiteColor : String = "#FFFFFF"
    // Declare an initializer
    override init() {
        print("Singleton class Chalu")
        
    }
    func getOrderStatus(stat : String) -> orderStatus {
        if stat == "New Order" {
            return (name: "Processing".uppercased(), color: kStatusYellow)
        }
        else if stat == "Picked" {
             return (name: "Processing".uppercased(), color: kStatusYellow)
        }
        else if stat == "Packed" {
            return (name: "Processing".uppercased(), color: kStatusGreen)
        }
        else if stat == "Processed" {
            return (name: "Shipped".uppercased(), color: kStatusGreen)
        }
        else if stat == "Delivered"{
            return (name: "Delivered".uppercased(), color: kStatusGreen)
        }
        else if stat == "Return initiated"{
            return (name: "Returned".uppercased(), color: kStatusYellow)
        }
        else if stat == "Return Processed" || stat == "Returned" {
            return (name: "Returned".uppercased(), color: kStatusBlack)
        }
        else if stat == "Ready for Collection"{
             return (name: "Ready for Collection".uppercased(), color: kStatusYellow)
        }
        else if stat == "Picking"{
            return (name: "Processing".uppercased(), color: kStatusRed)
        }
        else if stat == "With Customer Service" {
            return (name: "Processing".uppercased(), color: kStatusBlack)
        }
        else if stat == "Out for Delivery" {
            return (name: "On The way".uppercased(), color: kStatusBlack)
        }
        else if stat == "Open" {
            return (name: "Processing".uppercased(), color: kStatusBlack)
        }
        else if stat == "Created" {
            return (name: "Processing".uppercased(), color: kStatusBlack)
        }
        else{
            return (name: "Processing".uppercased(), color: kStatusGreen)
        }
    }
    func isValidPhoneNo(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
    }
    func brandonMedium(asize: Float) -> UIFont {
        return UIFont(name:"BrandonGrotesque-Medium", size: CGFloat(asize))!
    }
    func brandonLight(asize: Int) -> UIFont {
       return  UIFont(name:"BrandonGrotesque-Light", size: CGFloat(asize))!
    }
    func rotateImage(aimg : UIImageView){
       aimg.transform = CGAffineTransform(rotationAngle: .pi)
    }
    func backtoOriginalImage(aimg : UIImageView){
        aimg.transform = CGAffineTransform.identity
    }
    func rotateButton(aBtn : UIButton){
       aBtn.transform = CGAffineTransform(rotationAngle: .pi)
    }
    func backtoOriginalButton(aBtn : UIButton){
        aBtn.transform = CGAffineTransform.identity
    }
    
    func countryCodeList() -> [contryWithCode] {
        var dataArray = [contryWithCode]()
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
           do {
               let jsonData = try Data(contentsOf: url)
               let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

               if let data = json["countries"] {
                    for items in data as! [[String : Any]] {
                        let countryCode : String = items["code"] as! String
                        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                            let countryName : String = items["name_en"] as! String
                            dataArray.append((countryName: countryName, countryCode: countryCode))
                        }
                        else{
                            let countryName : String = items["name_ar"] as! String
                            dataArray.append((countryName: countryName, countryCode: countryCode))
                        }
                        
                    }
               }
           }
           catch {
               print(error)
           }
        return dataArray
    }
}
