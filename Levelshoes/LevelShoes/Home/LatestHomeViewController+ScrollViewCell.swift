//
//  LatestHomeViewController+ScrollCell.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 09.07.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var objattrList = [String]()
    var designDetail = [OptionsList]()
    var objList = [String]()
   var designData: [NSManagedObject] = []

extension LatestHomeViewController {
    
    
    func fetchAttributeeData(){

          designDetail = [OptionsList]()
        
           if CoreDataManager.sharedManager.fetchAttributeData() != nil{

               designData = CoreDataManager.sharedManager.fetchAttributeData() ?? []
               print("colorArray", designData.count)
           }
           
           
            for j in 0..<designData.count{
                let array:[OptionsList] = designData[j].value(forKey: "options") as! [OptionsList]
                for k in 0..<array.count{
                
                designDetail.append(array[k])
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
          
       }
       
       func getBrandName(id:String) -> String{
           var strBrand = ""
           for i in 0..<(designDetail.count){
              if id == "\(designDetail[i].value)"{
               strBrand = designDetail[i].label
              }
           }
           return strBrand.uppercased()
       }
       
    func getMostWantedTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        fetchAttributeeData()
        guard let hitsList = scrollViewData[indexPath.section]?.hits?.hitsList, let cell = tableView.dequeueReusableCell(withIdentifier: MostWantedTableViewCell.identifier, for: indexPath) as? MostWantedTableViewCell else {
            fatalError("Cell can't be dequeue")
        }
        var indexPath = indexPath
        indexPath.row -= 1

        cell.countLbl.text = "0\(indexPath.row + 1)"
        cell.viewOverlay.isHidden = true
        
        let str = CommonUsed.globalUsed.kimageUrl
        if hitsList.count > indexPath.row, let source = hitsList[indexPath.row]._source {
            let finalStr = str + source.image
            cell.imgProduct.downloadSdImage(url: finalStr)
            cell.lblBrand.text = getBrandName(id: "\(source.manufacturer)")
            cell.lblProductNm.text =
                source.name.uppercased()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                cell.lblBrand.font =  UIFont(name: "Cairo-SemiBold", size: 14)
                cell.lblProductNm.font =  UIFont(name: "Cairo-Light", size: 16)
                cell.countLbl.font = UIFont(name: "Cairo-Bold", size: 14)
            }

           
            var price = (Double(source.final_price_string)  ?? 0).clean
            let currencyStr = (UserDefaults.standard.value(forKey: string.currency) ?? " \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")")
           cell.lblPrice.text =  "\(price) " + "\((currencyStr))".localized
          //  cell.lblPrice.text = "\(source.final_price_string) \(UserDefaults.standard.value(forKey: string.currency) ?? "AED")"
        }
        return cell
    }
    
    func getScrollViewProducts(category_id:Int, product_id:[String], gender:String, completion:@escaping((_ data: NewInData?)-> Void)) {
        var productImages = Array<String>()
        var counter = 0
        var arrMust = [[String:Any]]()
        var total = 5
        var searchType = "must"
        var ids = [String]()
        if product_id.count > 0 {
            total = product_id.count
            searchType = "must"
            for i in product_id {
                if i.components(separatedBy: "|").count == 2 {
                    let id = i.components(separatedBy: "|")[0]
                    let image = i.components(separatedBy: "|")[1]
                    productImages.append(image)
                    ids.append(id)
                    counter += 1
                }
                else if(i.components(separatedBy: "|").count == 1){
                    ids.append(i.trimmingCharacters(in: .whitespaces))
                    counter += 1
                }
                else {
                    continue
                }
                 
            }
            arrMust.append(["terms": ["sku":ids]])
            //defaults.set(productImages, forKey: imgKey)
        } else {
            total = 5
            searchType = "must"
            arrMust.append(["match": ["category_ids":category_id]])
             //defaults.set([], forKey: imgKey)
        }
        if counter == 0 {
            total = 5
            searchType = "must"
            arrMust.append(["match": ["category_ids":category_id]])
        }
        arrMust.append(["match": ["type_id":"configurable"]])
        if(gender == "1610" && ids.count > 0){
            //Leave as it is for kids or put ids
             arrMust.append(["terms": ["gender":[1610,88,109,1430]]])
        }
        else{
        arrMust.append(["match": ["gender":gender]])
        }
        let dictMust = [searchType:arrMust]
        let dictBool = ["bool":dictMust]

        let sortStr1 = """
                {"_script" : {"type" : "number","script": {"inline" : "params.sortOrder.indexOf(doc['sku'].value)","params": {"sortOrder":
                """
               
           let sortStr2 =
            """
                }},"order" : "asc"}}
"""
        let sortStr = String(sortStr1) + "[\"" + ids.joined(separator: "\",\"")  + "\"]" + String(sortStr2)
        let sort = convertToDictionary(text: sortStr)
        
        let param = ["_source":["name","final_price","regular_price","media_gallery","configurable_options","thumbnail","configurable_children","size_options","description","meta_description","image","manufacturer","sku", "stock", "country_of_manufacture","id"],
                     "from":0,
                     "size": total,
                     "sort": sort,
                     "query": dictBool
            ] as [String : Any]
        
        let strCode = CommonUsed.globalUsed.productIndexName + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")"
        print("strCode = \(strCode)")
        let url = CommonUsed.globalUsed.productEndPoint + "/" + strCode + CommonUsed.globalUsed.productList
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            if let error = error {
                if error.localizedDescription.contains(s: "offline") {
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                }
                self.sharedAppdelegate.stoapLoader()
                completion(nil)
                return
            }
            var data: NewInData?
            if response != nil{
                let dict = ["data": response?.dictionaryObject]
                data = NewInData(dictionary: ResponseKey.fatchData(res: dict, valueOf: .data).dic)
            }else{
                self.alert(title: "server error", message: "Server is currently under going maintainance. Please try again later")
            }
            completion(data)
        }
    }
}
