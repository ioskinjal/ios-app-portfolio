//
//  DesignVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 20/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import CoreData


class DesignVC: UIViewController {

    @IBOutlet weak var viewNoitemFoun: UIView!
    static var storyboardInstance:DesignVC? {
                   return StoryBoard.plp.instantiateViewController(withIdentifier: DesignVC.identifier) as? DesignVC
                   
               }
       
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
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
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
            tableView.sectionIndexColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                
                txtSearch.font = UIFont(name: "Cairo-Light", size:16)
            }
            txtSearch.delegate = self
            txtSearch.placeholder = "searchTxtPlaceholder".localized
            
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
    @IBOutlet weak var lblDesigner: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDesigner.font = UIFont(name: "Cairo-SemiBold", size: lblDesigner.font.pointSize)

            }
            lblDesigner.text = "Designer".localized.uppercased()
            lblDesigner.addTextSpacing(spacing: 1.5)
        }
    }
   
//
//    var index = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
     let preferredLanguage = UserDefaults.standard.value(forKey:string.language)as? String ?? "en"
    /* Local Variable */
       var attrDictionary = [String: [String]]()
       var attrSectionTitles = [String]()
       var objattrList = [String]()
  
    var objList = [String]()
    var selectedList = [String]()
    
    var designData: [NSManagedObject] = []
    var designDetail = [OptionsList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchAttributeeData()
       if(UserDefaults.standard.value(forKey: "designNm") == nil){
                  for i in 0..<designDetail.count{
                             designDetail[i].isSelected = false
                  }
                      tableView.reloadData()
                  btnApplyFilter.isUserInteractionEnabled = false
                btnApplyFilter.alpha = 0.5
        }
    }

//
//    func fetchDesignData(){
//
//        if CoreDataManager.sharedManager.fetchManufacturerData() != nil{
//
//            designArray = CoreDataManager.sharedManager.fetchManufacturerData() ?? []
//            print("designArray", designArray.count)
//        }
//
//        for i in 0..<(plpData?.aggregations?.designerFilter?.buckets.count)!{
//            objList.append(getAttributeName(id: plpData?.aggregations?.designerFilter?.buckets[i].key ?? 0))
//        }
//            self.displayData()
//
//    }
    
    
    
//    func getAttributeName(id:Int) -> String{
//        var strAttribute = ""
//
//        for j in 0..<(designArray.count) {
//            if String(id) == designArray[j]["value"]as? String {
//                strAttribute = designArray[j]["value"] as? String ?? ""
//            }
//        }
//        return strAttribute
//    }
    
   
    
    
    @IBAction func onClickApplyFilter(_ sender: Any) {
        filterGotChanged = true
        var arrId = [String]()
        var arrDesign = [String]()
        for i in 0..<designDetail.count{
            if designDetail[i].isSelected == true{
                arrId.append(designDetail[i].value)
                arrDesign.append(designDetail[i].label)
            }
        }
        btnApplyFilter.isUserInteractionEnabled = false
        btnApplyFilter.alpha = 0.5
        dictParam = ["configurable_children.manufacturer":arrId]
           
               let dict = ["terms" : dictParam]
                   var tempArr = arrMust
                   for i in 0..<arrMust.count{
                       let dict:[String:Any] = arrMust[i]["terms"] as? [String : Any] ?? [String:Any]()
                       if dict.first?.key == "configurable_children.manufacturer"{
                           tempArr.remove(at: i)
                       }
                       
                   }
                   arrMust = tempArr
                   arrMust.append(dict)
        UserDefaults.standard.setValue(arrDesign, forKey: "designNm")
        strSelectedFilter = "designer"
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickClear(_ sender: Any) {
        filterGotChanged = false
        UserDefaults.standard.set(nil, forKey: "designNm")
        for i in 0..<designDetail.count{
            designDetail[i].isSelected = false
        }
        tableView.reloadData()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension DesignVC: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return attrSectionTitles.count
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
                      fatalError("Cell can't be dequeue")
                  }
    
    let attrKey = attrSectionTitles[indexPath.section]
    if let attrValues = attrDictionary[attrKey] {
        cell.lblSort.text = attrValues[indexPath.row]
    
        for i in 0..<designDetail.count{
        if designDetail[i].label == attrValues[indexPath.row]{
            if designDetail[i].isSelected {
            cell.btnRadio.setImage(#imageLiteral(resourceName: "ckcheck"), for: .normal)
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    cell.lblSort.font = UIFont(name: "Cairo-SemiBold", size: 18)

                }else{
                      cell.lblSort.font = Common.sharedInstance.brandonMedium(asize: 18)
                }
               
            
        }
       else{
            cell.btnRadio.setImage(nil, for: .normal)
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    cell.lblSort.font = UIFont(name: "Cairo-Regular", size: 18)

                }else{
                     cell.lblSort.font = BrandenFont.thin(with: 18.0)
                }
           
            
        }
        }
        }
        
        
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
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70))
        
        let xPosition = preferredLanguage == "en" ? 10 : -10
        let label = UILabel(frame: CGRect(x: xPosition, y: 21, width: Int(headerView.frame.width-10), height: 28))
        
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: backBtn)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: backBtn)
        }

        label.text = attrSectionTitles[section]
        label.font = BrandenFont.medium(with: 20.0)
        label.textColor = .black
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return attrSectionTitles
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let attrKey = attrSectionTitles[indexPath.section]
           if let attrValues = attrDictionary[attrKey] {

        for i in 0..<designDetail.count{
            if designDetail[i].label == attrValues[indexPath.row]{
                    designDetail[i].isSelected = !designDetail[i].isSelected
                btnApplyFilter.isUserInteractionEnabled = true
                btnApplyFilter.alpha = 1.0
                }

        }
            var count = 0
                                  for i in 0..<designDetail.count{
                                      if(designDetail[i].isSelected == true){
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
        }
        tableView.reloadData()
    }
    
    func fetchAttributeeData(){

        if CoreDataManager.sharedManager.fetchAttributeData() != nil{

            designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
            print("colorArray", designData.count)
        }

        if let designFilterCount = plpGlobalData?.aggregations?.designerFilter?.buckets.count {
            for i in 0..<designFilterCount{
                for j in 0..<designData.count{
                    let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                    for k in 0..<array.count{
                        
                        let strkey:Int = plpGlobalData?.aggregations?.designerFilter?.buckets[i].key ?? 0
                        let str:String = array[k].value
                        if Int(str) == strkey {
                            
                            designDetail.append(array[k])
                        }
                    }
                }
                
            }

        }
        
        let sorteddesignDetail =  designDetail.sorted(by: { $0.label < $1.label })
              designDetail = sorteddesignDetail
        
        let arrColorNm:[String] = UserDefaults.standard.value(forKey: "designNm") as? [String] ?? [String]()
        for i in 0..<designDetail.count{
            for j in arrColorNm{
                if designDetail[i].label == j{
                    designDetail[i].isSelected = true
                    
                }
            }
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
extension DesignVC {
    
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
        viewNoitemFoun.isHidden = attrSectionTitles.count == 0 ? false : true
        tableView.isHidden = attrSectionTitles.count == 0 ? true : false
              
        tableView.reloadData()
    }
    
}

// MARK: - TextField Delegate

extension DesignVC: UITextFieldDelegate {
    
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
