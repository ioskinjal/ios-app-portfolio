//
//  A-ZVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData

class A_ZVC: UIViewController {

    static var storyboardInstance:DesignVC? {
                      return StoryBoard.plp.instantiateViewController(withIdentifier: DesignVC.identifier) as? DesignVC
                      
                  }
          
    @IBOutlet weak var view404: UIView!
    @IBOutlet weak var lblnoresultFound: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblnoresultFound.font = UIFont(name: "Cairo-SemiBold", size: lblnoresultFound.font.pointSize)
            }
            lblnoresultFound.text = "no_Result".localized
        }
    }
    @IBOutlet weak var lbl404Desc: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lbl404Desc.font = UIFont(name: "Cairo-Light", size: lbl404Desc.font.pointSize)
            }
            lbl404Desc.text = "404Desc".localized
            lbl404Desc.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var btnApplyFilter: UIButton!{
           didSet{
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                   btnApplyFilter.addTextSpacing(spacing: 1.5, color: "ffffff")
               }else{
                btnApplyFilter.titleLabel?.font = UIFont(name: "Cairo-SemiBold", size: lbl404Desc.font.pointSize)
            }
           }
       }
       
       @IBOutlet weak var tableView: UITableView!{
           didSet{
               tableView.delegate = self
               tableView.dataSource = self
               tableView.sectionIndexColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           }
       }
       @IBOutlet weak var txtSearch: UITextField!{
           didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                txtSearch.font = UIFont(name: "Cairo-Light", size: 16)
            }
            txtSearch.delegate = self
            txtSearch.placeholder = "searchTxtPlaceholder".localized
           }
       }
      
       @IBOutlet weak var lblDesigner: UILabel!{
           didSet{
            lblDesigner.text = "desig_lbl".localized
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
               lblDesigner.addTextSpacing(spacing: 1.5)
               }else{
                lblDesigner.font = UIFont(name: "Cairo-SemiBold", size: lblDesigner.font.pointSize)
            }
           }
       }
     var attrDictionary = [String: [String]]()
          var attrSectionTitles = [String]()
          var objattrList = [String]()
     
       var objList = [String]()
       var selectedList = [String]()
       
       var designData: [NSManagedObject] = []
       var designDetail = [OptionsList]()
       let preferredLanguage = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
          
       }
    
    override func viewWillAppear(_ animated: Bool) {
        designData = []
        designDetail = [OptionsList]()
        objList = [String]()
         fetchAttributeeData()
        UserDefaults.standard.set(0,forKey: "filtercount")
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

extension A_ZVC: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return attrSectionTitles.count
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  attrSectionTitles
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return attrSectionTitles.index(of: title) ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let attrKey = attrSectionTitles[section]
        if let attrValues = attrDictionary[attrKey] {
            return attrValues.count
        }
        return 0
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByCell.identifier) as? SortByCell else {
                      //fatalError("Cell can't be dequeue")
                      return UITableViewCell()
                  }
    
    let attrKey = attrSectionTitles[indexPath.section]
    if let attrValues = attrDictionary[attrKey] {
        let sortedItems = attrValues.sorted(by: { $0.lowercased() < $1.lowercased() })
        let infoData = designDetail.filter{$0.label == sortedItems[indexPath.row]}
        cell.accessibilityIdentifier = infoData[0].value
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            cell.lblSort.font = UIFont(name: "Cairo-Light", size: cell.lblSort.font.pointSize)
        }
        cell.lblSort.text = sortedItems[indexPath.row]
    }
    let backgroundView = UIView()
    backgroundView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    cell.selectedBackgroundView = backgroundView

    
    return cell
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return carSectionTitles[section]
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let xPosition = preferredLanguage == "en" ? 20 : -20

        let label = UILabel(frame: CGRect(x: xPosition, y: 15, width: Int(tableView.bounds.size.width), height: 30))
        //label.frame = CGRect.init(x: 30, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        label.text = attrSectionTitles[section]
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            label.font = UIFont(name: "Cairo-SemiBold", size: label.font.pointSize)
        }else{
            label.font = BrandenFont.medium(with: 20.0)
        }
        
        label.textColor = .black

        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SortByCell
        let nextVC = NewInVC.storyboardInstance!
        nextVC.designId = cell.accessibilityIdentifier!
        nextVC.headlingLbl = cell.lblSort.text!.uppercased()
        nextVC.isCommingFromA2Z = true
        nextVC.strGen = UserDefaults.standard.value(forKey: "gender")as? String ?? ""
         self.navigationController?.pushViewController(nextVC, animated: true)
      
//            let attrKey = attrSectionTitles[indexPath.section]
//           if let attrValues = attrDictionary[attrKey] {
//            let sortedItems = attrValues.sorted(by: <)
//        for i in 0..<designDetail.count{
//            if designDetail[i].label == sortedItems[indexPath.row]{
//                //print("Item Id \(designDetail[i].value)")
//                nextVC.designId = designDetail[i].value
//                }
//
//
//        }
//            //print("Heading Label \(sortedItems[indexPath.row].uppercased())")
//            nextVC.designId = designDetail[i].value
//            nextVC.headlingLbl = sortedItems[indexPath.row].uppercased()
//        }

    }
    
    func fetchAttributeeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("colorArray", designData.count)
        }
  

            for j in 0..<designData.count {
                if(designData[j].value(forKey:"attribute_code") as? String ?? "" == "manufacturer"){
                     let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                    
                     for k in 0..<array.count{
                                        designDetail.append(array[k])
                                  }
                }
        }

        let code : String = getWebsiteCurrency()
        
        switch code {
        case "AED":
           
            for i in designDetail{
                      for j in CommonUsed.globalUsed.designArrayUAE{
                          if Int(i.value) == j{
                              designDetail.remove(object: i)
                          }
                      }
                  }
            
            case "SAR":
            
             for i in designDetail{
                       for j in CommonUsed.globalUsed.designArrayKSA{
                           if Int(i.value) == j{
                               designDetail.remove(object: i)
                           }
                       }
                   }
            case "KWD":
            
             for i in designDetail{
                       for j in CommonUsed.globalUsed.designArrayKWT{
                           if Int(i.value) == j{
                               designDetail.remove(object: i)
                           }
                       }
                   }
            
            case "OMR":
            
             for i in designDetail{
                       for j in CommonUsed.globalUsed.designArrayOMR{
                           if Int(i.value) == j{
                               designDetail.remove(object: i)
                           }
                       }
                   }
            
            case "BHD":
            
             for i in designDetail{
                       for j in CommonUsed.globalUsed.designArrayBHD{
                           if Int(i.value) == j{
                               designDetail.remove(object: i)
                           }
                       }
                   }
            
        default:
            return
        }
        
      
        
        for i in 0..<designDetail.count{
            objList.append(designDetail[i].label)
        }
        objattrList = objList
        self.displayData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let sectionHeaderHeight:CGFloat = 55.0;
                 if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                     scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);
                 } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                     scrollView.contentInset = UIEdgeInsets(top: -CGFloat(sectionHeaderHeight), left: 0, bottom: 0, right: 0);
                 }
     }
}
extension A_ZVC {
    
    func displayData() {
        
        attrDictionary.removeAll()
        for attr in objList {
            let attrKey = String(attr.prefix(1))
           if var attrValues = attrDictionary[attrKey] {
                attrValues.append(attr)
                attrDictionary[attrKey] = attrValues
            } else {
                attrDictionary[attrKey] = [attr]
            }
        }
        
        attrSectionTitles = [String](attrDictionary.keys)
        attrSectionTitles = attrSectionTitles.sorted(by: { $0 < $1 })
        //print("SECTION VAL - \(attrSectionTitles)")
        if attrSectionTitles.count > 0 {
            view404.isHidden = true
            tableView.reloadData()
        }else{
            view404.isHidden = false
        }
        
    }
    
}
// MARK: - TextField Delegate

extension A_ZVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        /* Check input max lenth */
        let maxLength = (textField.text?.length)! + string.length - range.length;
        return (maxLength > Int(textField.minimumFontSize)) ? false : true;
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        
        if txtSearch.text == nil || txtSearch.text?.length == 0 {
            objList = objattrList
            
        } else {
            
            objList = objattrList.filter {
                return $0.uppercased().contains(txtSearch.text!.uppercased())
            }
        }
        
        //lblNoData.isHidden = objList.count > 0
        
        self.displayData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
