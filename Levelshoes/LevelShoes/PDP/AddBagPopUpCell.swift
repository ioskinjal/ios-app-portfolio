//
//  AddBagPopUpCell.swift
//  LevelShoes
//
//  Created by Evan Dean on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class AddBagPopUpCell: UITableViewCell {

    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var stock:UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblStockPrice: UILabel!
    let lightFont = UIFont(name: "BrandonGrotesque-Light", size: 18)
    let boldFont =  UIFont(name: "BrandonGrotesque-Medium", size: 18)
    let outofStockColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
    var outofStock = ""
    override func awakeFromNib() {
        super.awakeFromNib()
      
        //lblSize.addTextSpacing(spacing: 1.5)
    }
    func getSizeValueById(id: Int) -> String{
        let attributeData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
        let attribute_code = "size"
        if attribute_code == "size"{
            for j in 0..<attributeData.count{
                let array:[OptionsList] = attributeData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
               
                    let str:String = array[k].value
                    if Int(str) == id {
                        return array[k].label
                }
                }
            }

        }
       return ""
        
    }
    func sizeLabel(size: Int , stock:Int, price: Double){
        lblSize.text = String(getSizeValueById(id: size))
        let priceValueFormet = Double(price ?? 0).clean
        lblStockPrice.text = "\(priceValueFormet) " //+  UserDefaults.standard.string(forKey: "currency")!.localized
       // lblStockPrice.text = String(price) + " " + UserDefaults.standard.string(forKey: "currency")!.localized
        if stock == 0 {
            self.stock.text = "out_of_stock".localized
            outofStock = "Out of stock"
            self.lblSize.font = lightFont
            self.lblSize.textColor = outofStockColor
            self.stock.font = lightFont
            self.stock.textColor = outofStockColor
            lblStockPrice.textColor = outofStockColor
            lblStockPrice.font = UIFont(name: "BrandonGrotesque-Light", size: 14)
            
        }else if stock == 1{
            self.stock.text = "last_in_stock".localized
            outofStock = "Last in stock"
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                self.lblSize.font = lightFont
                self.stock.font = lightFont
                self.lblStockPrice.font = UIFont(name: "BrandonGrotesque-Light", size: 14)
            }else{
                self.lblSize.font = UIFont(name: "Cairo-Light", size: self.lblSize.font.pointSize)
                self.stock.font = UIFont(name: "Cairo-Light", size: self.stock.font.pointSize)
                self.lblStockPrice.font = UIFont(name: "Cairo-Light", size: 14)
            }
        }else{
            self.stock.text = ""
            outofStock = ""
            self.lblSize.font = lightFont
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //self.accessoryType = selected ? .checkmark  : .none
        
        // Configure the view for the selected state
    }
    func CheckCurrentcell(cell:AddBagPopUpCell,index:Int,flagindex:Int){
          if index == flagindex{
                    cell.btnCheck.isHidden = false
            //cell.accessoryType = .checkmark
                     cell.lblSize.textColor = UIColor.black

            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                cell.lblSize.font  = boldFont
                cell.stock.font = boldFont
                self.lblStockPrice.font = UIFont(name: "BrandonGrotesque-Medium", size: 14)
            }else{
                cell.lblSize.font  = UIFont(name: "Cairo-SemiBold", size: cell.lblSize.font.pointSize)
                cell.stock.font = UIFont(name: "Cairo-SemiBold", size: cell.stock.font.pointSize)
                self.lblStockPrice.font = UIFont(name: "Cairo-SemiBold", size: 14)
            }

          }else{
                cell.btnCheck.isHidden = true
            //cell.accessoryType = .none
                cell.lblSize.font  = lightFont
                self.lblStockPrice.font = UIFont(name: "BrandonGrotesque-Light", size: 14)
            if  outofStock == "Out of stock" {
                cell.lblSize.textColor = outofStockColor
                lblStockPrice.textColor = outofStockColor
            }
            else{
                cell.lblSize.textColor = UIColor.black
                 lblStockPrice.textColor = UIColor.black
            }
        }

      }

}
