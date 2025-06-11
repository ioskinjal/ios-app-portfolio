//
//  ColorsVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData

class ColorsVC: UIViewController {
    
    static var storyboardInstance:ColorsVC? {
        return StoryBoard.plp.instantiateViewController(withIdentifier: ColorsVC.identifier) as? ColorsVC
        
    }
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
    
    @IBOutlet weak var btnApplyFilter: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                btnApplyFilter.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnApplyFilter.setTitle("aply_filt".localized, for: .normal)
            btnApplyFilter.addTextSpacing(spacing: 1.5, color: "ffffff")
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnClear: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                btnClear.titleLabel?.font = UIFont(name: "Cairo-Light", size: 16)
            }
            btnClear.setTitle("clear".localized, for: .normal)
            btnClear.underline()
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size:  lblTitle.font.pointSize)
            }
            lblTitle.text = "Color".localized.uppercased()
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    var colorArray: [NSManagedObject] = []
   
   
    var refreshCount = 0
    var prevRefreshCount = 0
    var colorData = [[String:Any]]()
    var selectedColorData = [[String:Any]]()
    var colorDetail = [OptionsList]()
    var isClearBtnSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "colorNm") == nil{
            btnApplyFilter.isUserInteractionEnabled = false
            btnApplyFilter.alpha = 0.5
            
        }
       fetchAttributeData()
        if(UserDefaults.standard.value(forKey: "colorNm") == nil){
              for i in 0..<colorDetail.count{
                  colorDetail[i].isSelected = false
              }
              tableView.reloadData()
               }
        
    }
    
    func fetchAttributeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            colorArray = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("colorArray", colorArray.count)
        }
        
         for i in 0..<(plpGlobalData?.aggregations?.colorFilter?.buckets.count)!{
         for j in 0..<colorArray.count{
             let array:[OptionsList] = colorArray[j].value(forKey: "options") as! [OptionsList]
             for k in 0..<array.count{
             
             let strkey:Int = plpGlobalData?.aggregations?.colorFilter?.buckets[i].key ?? 0
                 let str:String = array[k].value
                 if Int(str) == strkey {
       
                     colorDetail.append(array[k])
             }
             }
         }
            
        }
        
        let sortedColorDetail =  colorDetail.sorted(by: { $0.label < $1.label })
        colorDetail = sortedColorDetail
        print(sortedColorDetail)
        
        let arrColorNm:[String] = UserDefaults.standard.value(forKey: "colorNm") as? [String] ?? [String]()
        for i in 0..<colorDetail.count{
            for j in arrColorNm{
                if colorDetail[i].label == j{
                    colorDetail[i].isSelected = true
                    btnApplyFilter.isUserInteractionEnabled = true
                    btnApplyFilter.alpha = 1.0
                }
            }
        }
         tableView.reloadData()
        
        
    }
    
       
//
//       func fetchColorData(){
//
//           if CoreDataManager.sharedManager.fetchColorData() != nil{
//
//               colorArray = CoreDataManager.sharedManager.fetchColorData() ?? []
//               print("colorArray", colorArray.count)
//           }
//
//
//        for i in 0..<(plpData?.aggregations?.colorFilter?.buckets.count)!{
//
//              for k in 0..<self.colorArray.count{
//                let id:String = "\(plpData?.aggregations?.colorFilter?.buckets[i].key ?? 0)"
//                if self.colorArray[k].value(forKey: "value")as? String == id  {
//                           let dict = ["label":self.colorArray[k].value(forKey: "label"),
//                                       "value":self.colorArray[k].value(forKey: "value"),
//                                       "sort_order":self.colorArray[k].value(forKey: "sort_order"),
//                                       "image":self.colorArray[k].value(forKey: "url"),
//                                       "isSelected":false]
//
//                        self.colorData.append(dict as [String : Any])
//
//                   }
//               }
//        }
//               self.tableView.reloadData()
//           }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func onClickBack(_ sender: Any) {
      //  strSelectedFilter = "color"
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickApply(_ sender: Any) {
        filterGotChanged = true
        print("on click apply")
        strSelectedFilter = "color"
        var arrid = [String]()
        var arrColor = [String]()
        for i in 0..<colorDetail.count{
            if colorDetail[i].isSelected {
           arrid.append(colorDetail[i].value)
           arrColor.append(colorDetail[i].label)
            }else{
                arrid.remove(object: colorDetail[i].value)
                arrColor.remove(object:colorDetail[i].label)
            }
           
        }
        
        UserDefaults.standard.set(nil, forKey: "colorNm")
        UserDefaults.standard.set(arrColor, forKey: "colorNm")
        if arrid.count == 0{
           // let dict = ["terms" : dictParam]
             var tempArr = arrMust
               for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                   if dict.first?.key == "configurable_children.color"{
                       tempArr.remove(at: i)
                   }
                   
               }
            arrMust = tempArr
            //arrMust.append(dict)
        }else{
        dictParam = ["configurable_children.color":arrid]
    
        let dict = ["terms" : dictParam]
            var tempArr = arrMust
            for i in 0..<arrMust.count{
                let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                if dict.first?.key == "configurable_children.color"{
                    tempArr.remove(at: i)
                }
                
            }
            arrMust = tempArr
            arrMust.append(dict)
        }
    
        
        if !self.isClearBtnSelected {
            self.isClearBtnSelected = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func onClickClear(_ sender: Any) {
        self.isClearBtnSelected = true
        filterGotChanged = false
        UserDefaults.standard.set(nil, forKey: "colorNm")
        for i in 0..<colorDetail.count{
            colorDetail[i].isSelected = false
        }
        
       onClickApply(UIButton())
        
        btnApplyFilter.isUserInteractionEnabled = false
        btnApplyFilter.alpha = 0.5
        tableView.reloadData()
        
        UserDefaults.standard.set(nil, forKey: "colorNm")
        
    }
    
}

extension ColorsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorCell.identifier) as? ColorCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .none
        cell.textLabel?.font = BrandenFont.thin(with: 18.0)
        cell.lblColor?.text = colorDetail[indexPath.row].label

        let imagePath = CommonUsed.globalUsed.filterColorAttributeImage + colorDetail[indexPath.row].value.lowercased() + ".jpg"
            let finalStr = imagePath.replacingOccurrences(of: " ", with: "-")
          cell.imgColor.downloadSdImage(url: finalStr)
        if(cell.imgColor == nil){
            colorDetail[indexPath.row].value.lowercased() + ".jpg"
            let finalStr = imagePath.replacingOccurrences(of: " ", with: "-")
            cell.imgColor.downloadSdImage(url: finalStr)
        }
        var count = 0
               for i in 0..<colorDetail.count{
                   if(colorDetail[i].isSelected == true){
                       count += 1
                   }
               }
               if(count != 0){
                   btnApplyFilter.isUserInteractionEnabled = true
                   btnApplyFilter.alpha = 1.0
               }else{
                   btnApplyFilter.isUserInteractionEnabled = false
                   btnApplyFilter.alpha = 0.5
               }
        if colorDetail[indexPath.row].isSelected {
           UIView.transition(with: cell.imgRight, duration: 1.0, options: .transitionCrossDissolve, animations: {
            cell.imgRight.image = #imageLiteral(resourceName: "ckcheck")
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                 cell.lblColor.font = UIFont(name: "Cairo-SemiBold", size: 18)
            }else{
                cell.lblColor.font = Common.sharedInstance.brandonMedium(asize: 18)
            }
            
           })
       }
            else{

           cell.imgRight.image = nil //checkmark
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                 cell.lblColor.font = UIFont(name: "Cairo-Light", size: 18)
            }else{
                 cell.lblColor.font = BrandenFont.thin(with: 18.0)
            }
          
       }
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if colorDetail[indexPath.row].isSelected == true{
            colorDetail[indexPath.row].isSelected  = false
        }else{
            colorDetail[indexPath.row].isSelected  = true
        }
        tableView.reloadData()
        for i in 0..<(colorDetail.count){
            if colorDetail[i].isSelected == true{
                selectedColorData.append(contentsOf: colorData )
            }
        }
        }

    
}
    

extension ColorsVC:NoInternetDelgate{
    func didCancel() {
       // self.getColor()
    }
}
