//
//  PriceVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 22/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import RangeSeekSlider
import CoreData
var selectedMinValue = 0.0
var selectedMaxValue = 1.0
var totalMaxPrice = 0.0
class PriceVC: UIViewController {

    @IBOutlet weak var lblMinimumPrice: UILabel!
    @IBOutlet weak var lblMaximumPrice: UILabel!
    static var storyboardInstance:PriceVC? {
        return StoryBoard.plp.instantiateViewController(withIdentifier: PriceVC.identifier) as? PriceVC
        
    }
    @IBOutlet weak var lblHeighRange: UILabel!
    @IBOutlet weak var lblLowRange: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: backBtn)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: backBtn)
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            lblTitle.text = "Price".localized.uppercased()
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var btnApply: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnApply.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnApply.setTitle("aply_filt".localized, for: .normal)
            btnApply.addTextSpacing(spacing: 1.5, color: "ffffff")
        }
    }
    @IBOutlet weak var slider: RangeSeekSlider!{
        didSet{
            slider.delegate = self
            slider.selectedHandleDiameterMultiplier = 1.0
            slider.hideLabels = true
   
        }
    }
    @IBOutlet weak var btnClear: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnClear.titleLabel?.font = UIFont(name: "Cairo-Light", size: 15)
            }
            btnClear.setTitle("clear".localized, for: .normal)
            btnClear.underline()
        }
    }
   
    var plpData : NewInData?
    var arrayPrice: [NSManagedObject] = []
    var priceDetail = [OptionsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let currency = UserDefaults.standard.value(forKey: string.currency) ?? "AED".localized
        let myFloat = NSNumber.init(value: plpGlobalData?.aggregations?.max_price?.value ?? Double(selectedMaxValue)).floatValue
        let myFloatMin = NSNumber.init(value: plpGlobalData?.aggregations?.min_price?.value ?? Double(selectedMaxValue)).floatValue
        if(selectedMinValue == 0.0 && selectedMaxValue == 1.0){
            slider.maxValue = CGFloat(Double(CGFloat(myFloat)))
            slider.selectedMaxValue = CGFloat(Double(CGFloat(myFloat)))
            slider.selectedMinValue = CGFloat(Double(CGFloat(myFloatMin)))
            slider.minValue = 0
            selectedMinValue = Double(slider.selectedMinValue)
            selectedMaxValue = Double(slider.selectedMaxValue)
            totalMaxPrice = Double(slider.selectedMaxValue)
        }
        else{
            slider.maxValue = CGFloat(totalMaxPrice)
            slider.selectedMaxValue = CGFloat(Double(CGFloat(myFloat)))
            slider.selectedMinValue = CGFloat(Double(CGFloat(myFloatMin)))
            slider.minValue = 0
            
        }
       
      
         /*
         slider.maxValue = CGFloat(Double(CGFloat(myFloat)))
         slider.selectedMaxValue = CGFloat(Double(CGFloat(myFloat)))
        
         myFloat = NSNumber.init(value: plpGlobalData?.aggregations?.min_price?.value ?? Float(minvalue)).floatValue
         slider.minValue = 0
         slider.selectedMinValue = CGFloat(Double(CGFloat(myFloat)))
        */
         lblMaximumPrice.text = "\(String(format: "%i",Int(slider.selectedMaxValue))) " + String(currency as? String ?? "")
         lblMinimumPrice.text = "\(String(format: "%i",Int(slider.selectedMinValue))) " + String(currency as? String ?? "")
        
     
      
        
    }

    
     
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onClickClear(_ sender: Any) {
        filterGotChanged = false
        var currency = UserDefaults.standard.value(forKey: string.currency) ?? "AED".localized
        slider.maxValue = CGFloat(totalMaxPrice)
        slider.selectedMaxValue = CGFloat(totalMaxPrice)
        slider.selectedMinValue = 0
        slider.minValue = 0
        selectedMinValue = 0.0
        selectedMaxValue = totalMaxPrice
        lblMaximumPrice.text = "\(String(format: "%i",Int(slider.selectedMaxValue))) " + String(currency as? String ?? "")
        lblMinimumPrice.text = "\(String(format: "%i",Int(slider.selectedMinValue))) " + String(currency as? String ?? "")
        UserDefaults.standard.set(nil, forKey: "priceNm")
        
    }
    @IBAction func onClickApply(_ sender: Any) {
        filterGotChanged = true
        let dictField = ["gte":selectedMinValue,
                        "lte":selectedMaxValue]
        var dictTerms = [String:Any]()
         dictTerms["price"] = dictField
         
      //  dictParam = ["configurable_children.color":arrid]
        let dict = ["range" : dictTerms]
        var tempArr = arrMust
        for i in 0..<arrMust.count{
            let dict:[String:Any] = arrMust[i]["range"] as? [String : Any] ?? [String:Any]()
            if dict.first?.key == "price"{
                tempArr.remove(at: i)
            }
            
        }
        arrMust = tempArr
        arrMust.append(dict)
        UserDefaults.standard.set("\(Int(selectedMinValue))-\(Int(selectedMaxValue))", forKey: "priceNm")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
extension PriceVC: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        selectedMinValue = Double(minValue)
        selectedMaxValue = Double(maxValue)
        
        
        var currency = UserDefaults.standard.value(forKey: string.currency) ?? "AED".localized
    
        lblMaximumPrice.text = "\(String(format: "%i",Int(maxValue))) " + String(currency as? String ?? "")
        lblMinimumPrice.text = "\(String(format: "%i",Int(minValue))) " + String(currency as? String ?? "")
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
