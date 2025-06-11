//
//  SizeVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData

class SizeVC: UIViewController {
    
    static var storyboardInstance:SizeVC? {
        return StoryBoard.plp.instantiateViewController(withIdentifier: SizeVC.identifier) as? SizeVC
        
    }
    
    @IBOutlet weak var btnApplyFilter: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnApplyFilter.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnApplyFilter.setTitle("aply_filt".localized, for: .normal)
            btnApplyFilter.addTextSpacing(spacing: 1.5, color: "ffffff")
        }
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
    
    @IBOutlet weak var btnClear: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnClear.titleLabel?.font = UIFont(name: "Cairo-Light", size: 16)
            }
            btnClear.setTitle("clear".localized, for: .normal)
            btnClear.underline()
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            lblTitle.addTextSpacing(spacing: 1.5)
        }
    }
    
    var attribute_code = ""
    var attributeData: [NSManagedObject] = []
    var sizeDetail = [OptionsList]()
    var strgen = ""
    var isCommingFromA2Z : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.value(forKey: "sizeNm") == nil || UserDefaults.standard.value(forKey: "genderNm") == nil || UserDefaults.standard.value(forKey: "categoryNm") == nil{
            btnApplyFilter.isUserInteractionEnabled = false
            btnApplyFilter.alpha = 0.5
        }
        fetchAttributeeData()
        
                if attribute_code == "size" && UserDefaults.standard.value(forKey: "sizeNm") == nil {

                    for i in 0..<sizeDetail.count{
                      sizeDetail[i].isSelected = false
                    }
                            
                }else if attribute_code == "gender" && UserDefaults.standard.value(forKey: "genderNm") == nil {

                    for i in 0..<sizeDetail.count{
                      sizeDetail[i].isSelected = false
                    }

                }else if attribute_code == "lvl_category" && UserDefaults.standard.value(forKey: "categoryNm") == nil{

                    for i in 0..<sizeDetail.count{
                      sizeDetail[i].isSelected = false
                    }

                }
                    
               tableView.reloadData()
    }
    
    func fetchAttributeeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            attributeData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("attributeData", attributeData.count)
        }
        if attribute_code == "size"{
            lblTitle.text = "Size".localized.uppercased()
        for i in 0..<(plpGlobalData?.aggregations?.sizeFilter?.buckets.count)!{
            for j in 0..<attributeData.count{
                let array:[OptionsList] = attributeData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
                let strkey:Int = plpGlobalData?.aggregations?.sizeFilter?.buckets[i].key ?? 0
                    let str:String = array[k].value
                    if Int(str) == strkey {
                        array[k].isSelected = false
                        sizeDetail.append(array[k])
                }
                }
            }
            let sortedsizeDetail =  sizeDetail.sorted(by: { $0.label < $1.label })
                         sizeDetail = sortedsizeDetail
            let arrSize:[String] = UserDefaults.standard.value(forKey: "sizeNm") as? [String] ?? [String]()
             for i in 0..<sizeDetail.count{
            for j in 0..<arrSize.count{
                if sizeDetail[i].label == arrSize[j]{
                    sizeDetail[i].isSelected = true
                }
            }
            }
        }
        }else if attribute_code == "gender"{
            lblTitle.text = "Gender".localized.uppercased()
            for i in 0..<(plpGlobalData?.aggregations?.genderFilter?.buckets.count)!{
            for j in 0..<attributeData.count{
                let array:[OptionsList] = attributeData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
                let strkey:Int = plpGlobalData?.aggregations?.genderFilter?.buckets[i].key ?? 0
                    let str:String = array[k].value
                    if Int(str) == strkey {
                        array[k].isSelected = false
                        sizeDetail.append(array[k])
                }
                }
            }
            }
            let sortedsizeDetail =  sizeDetail.sorted(by: { $0.label < $1.label })
            sizeDetail = sortedsizeDetail
            if(UserDefaults.standard.value(forKey: "genderNm") == nil && !isCommingFromA2Z){
                if(strgen == "61"){UserDefaults.standard.set(["Women"],forKey: "genderNm")}
                else if(strgen == "39"){UserDefaults.standard.set(["Men"],forKey: "genderNm")}
                else{UserDefaults.standard.set(["Kids"],forKey: "genderNm")}
                 
            }
           
            if UserDefaults.standard.value(forKey: "genderNm") != nil{
            let arrGender:[String] = UserDefaults.standard.value(forKey: "genderNm") as? [String] ?? [String]()
             for i in 0..<sizeDetail.count{
            for j in 0..<arrGender.count{
                if sizeDetail[i].label == arrGender[j] || sizeDetail[i].value == arrGender[j] {
                    sizeDetail[i].isSelected = true
                }
            }
            }
            }
            

        }else if attribute_code == "lvl_category"{
            lblTitle.text = "Category".localized.uppercased()
            if let categoryCount = plpGlobalData?.aggregations?.categoryFilter?.buckets.count {
                for i in 0..<categoryCount{
                    for j in 0..<attributeData.count{
                        let array:[OptionsList] = attributeData[j].value(forKey: "options") as! [OptionsList]
                        for k in 0..<array.count{
                            
                            let strkey:Int = plpGlobalData?.aggregations?.categoryFilter?.buckets[i].key ?? 0
                            let str:String = array[k].value
                            if Int(str) == strkey {
                                array[k].isSelected = false
                                sizeDetail.append(array[k])
                            }
                        }
                    }

                }
            }
            
            let sortedsizeDetail =  sizeDetail.sorted(by: { $0.label < $1.label })
            sizeDetail = sortedsizeDetail
            let arrDesigner:[String] = UserDefaults.standard.value(forKey: "categoryNm") as? [String] ?? [String]()
             for i in 0..<sizeDetail.count{
            for j in 0..<arrDesigner.count{
                if sizeDetail[i].label == arrDesigner[j]{
                    sizeDetail[i].isSelected = true
                }
            }
            }
            

        }

    }
    
    
    @IBAction func onClickFilter(_ sender: Any) {
        var arrId = [String]()
        var arrName = [String]()
        filterGotChanged = true
        for i in 0..<sizeDetail.count{
            if sizeDetail[i].isSelected == true{
                arrId.append(sizeDetail[i].value)
                arrName.append(sizeDetail[i].label)
            }
        }
        if attribute_code == "size"{
            strSelectedFilter = "size"
             var tempArr = arrMust
            if arrId.count == 0{
                       let dict = ["terms" : dictParam]
                                  for i in 0..<arrMust.count{
                                   let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                                      if dict.first?.key == "configurable_children.size"{
                                          tempArr.remove(at: i)
                                      }
                                      
                                  }
                arrMust = tempArr
                
                   }else{
                   dictParam = ["configurable_children.size":arrId]
               
                   let dict = ["terms" : dictParam]
                       for i in 0..<arrMust.count{
                           let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                           if dict.first?.key == "configurable_children.size"{
                               tempArr.remove(at: i)
                           }
                           
                       }
                    arrMust = tempArr
                   arrMust.append(dict)
                   }
            
            
    
             UserDefaults.standard.set(arrName, forKey: "sizeNm")
        }else if attribute_code == "gender"{
            strSelectedFilter = "gender"
                var tempArr = arrMust
                if arrId.count == 0{
                           let dict = ["terms" : dictParam]
                                      for i in 0..<arrMust.count{
                                       let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                                          if dict.first?.key == "configurable_children.gender"{
                                              tempArr.remove(at: i)
                                          }
                                          
                                      }
                    arrMust = tempArr
                   
                       }else{
                       dictParam = ["configurable_children.gender":arrId]
                   
                       let dict = ["terms" : dictParam]
                           for i in 0..<arrMust.count{
                               let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                               if dict.first?.key == "configurable_children.gender"{
                                   tempArr.remove(at: i)
                               }
                               
                           }
                       arrMust = tempArr
                       arrMust.append(dict)
                       }
                
                
        
                 UserDefaults.standard.set(arrName, forKey: "genderNm")
            }else if attribute_code == "lvl_category"{
            strSelectedFilter = "category"
                 var tempArr = arrMust
                if arrId.count == 0{
                           let dict = ["terms" : dictParam]
                            
                                      for i in 0..<arrMust.count{
                                       let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                                          if dict.first?.key == "configurable_children.lvl_category"{
                                              tempArr.remove(at: i)
                                          }
                                          
                                      }
                    arrMust = tempArr
                   
                       }else{
                       dictParam = ["configurable_children.lvl_category":arrId]
                   
                       let dict = ["terms" : dictParam]
                      
                           for i in 0..<arrMust.count{
                               let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                               if dict.first?.key == "configurable_children.lvl_category"{
                                   tempArr.remove(at: i)
                               }
                               
                           }
                       arrMust = tempArr
                       arrMust.append(dict)
                       }
                
                
        
                 UserDefaults.standard.set(arrName, forKey: "categoryNm")
            }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickClear(_ sender: Any) {
        filterGotChanged = false
        btnApplyFilter.isUserInteractionEnabled = false
        btnApplyFilter.alpha = 0.5
        if attribute_code == "size"{
            UserDefaults.standard.set(nil, forKey: "sizeNm")
            for i in 0..<sizeDetail.count{
                sizeDetail[i].isSelected = false
            }
            
            var tempArr = arrMust
            for i in 0..<arrMust.count{
            let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
            if dict.first?.key == "configurable_children.size"{
            tempArr.remove(at: i)
            }
            }
            arrMust = tempArr
                                                
        }else if attribute_code == "gender"{
            UserDefaults.standard.set(nil, forKey: "genderNm")
            for i in 0..<sizeDetail.count{
                sizeDetail[i].isSelected = false
            }
            var tempArr = arrMust
                       for i in 0..<arrMust.count{
                       let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                       if dict.first?.key == "configurable_children.gender"{
                       tempArr.remove(at: i)
                       }
            }
                       arrMust = tempArr
           
        }else if attribute_code == "lvl_category"{
            UserDefaults.standard.set(nil, forKey: "categoryNm")
            for i in 0..<sizeDetail.count{
                sizeDetail[i].isSelected = false
            }
            
        }
        var tempArr = arrMust
                              for i in 0..<arrMust.count{
                              let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                              if dict.first?.key == "configurable_children.lvl_category"{
                              tempArr.remove(at: i)
                              }
                   }
                              arrMust = tempArr
        tableView.reloadData()
        
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

extension SizeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizeDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier) as? SortByCell else {
                   fatalError("Cell can't be dequeue")
               }
        cell.btnRadio.setImage(nil, for: .normal)
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            cell.lblSort.font = UIFont(name: "Cairo-Light", size: 18)
        }else{
            cell.lblSort.font = BrandenFont.thin(with: 18.0)
        }
        var count = 0
          for i in 0..<sizeDetail.count{
              if(sizeDetail[i].isSelected == true){
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
         if sizeDetail[indexPath.row].isSelected == true {
            UIView.transition(with: cell.btnRadio, duration: 1.0, options: .transitionCrossDissolve, animations: {
            cell.btnRadio.setImage(#imageLiteral(resourceName: "ckcheck"), for: .normal)
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    cell.lblSort.font = UIFont(name: "Cairo-SemiBold", size: 18)
                }else{
                    cell.lblSort.font = Common.sharedInstance.brandonMedium(asize: 18)
                }
                
            })
        }else{
            
            cell.btnRadio.setImage(nil, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                cell.lblSort.font = UIFont(name: "Cairo-Light", size: 18)
            }else{
                cell.lblSort.font = BrandenFont.thin(with: 18.0)
            }
            
        }
        
        cell.lblSort?.text = sizeDetail[indexPath.row].label
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sizeDetail[indexPath.row].isSelected == true{
               sizeDetail[indexPath.row].isSelected = false
           }else{
               sizeDetail[indexPath.row].isSelected = true
            btnApplyFilter.isUserInteractionEnabled = true
            btnApplyFilter.alpha = 1.0
           }
           tableView.reloadData()
           
           }
    
}
