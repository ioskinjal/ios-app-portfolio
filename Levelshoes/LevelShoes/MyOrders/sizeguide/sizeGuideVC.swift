//
//  sizeGuideVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 15/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class sizeGuideVC: UIViewController {

    @IBOutlet weak var header: headerView!
    //Whomen data
    let euArrayWomen = ["35", "35.5", "36", "36.5", "37", "37.5", "38", "38.5", "39", "39.5", "40", "40.5", "41", "41.5", "42"]
    let ukArrayWomen = ["2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9"]
    let usArrayWomen = ["5", "5.5", "6" ,"6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12"]
    
    //Mens Data
    let euArrayMen = ["38","39","39.5", "40", "40.5", "41", "41.5", "42", "42.5", "43", "43.5", "44", "44.5", "45", "45.5", "46", "46.5", "47"]
    let ukArrayMen = ["4", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13"]
    let usArrayMen = ["5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14"]
    
    //KIds Data
     let babyAgeArray = ["0-1M", "0-3M", "3-6M", "6-9M", "9-12M", "12-18M"]
    let euArrayBaby = ["15", "16", "17", "18", "19", "20"]
    let ukArrayBaby = ["0", "0.5", "1", "2", "3", "4"]
    let usArrayBaby = ["0", "1", "2", "3", "4", "5"]
    
    //KIds Data
    let euArrayKids = ["19", "20", "20.5", "21", "22", "22.5", "23", "23.5", "24", "25", "25.5", "26", "27", "27.5", "28", "29", "30", "31", "32", "33", "33.5", "34", "34.5", "35", "36", "36.5", "37", "37.5", "38","38.5", "39"]
    let ukArrayKids = ["3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "11.5", "12", "12.5", "13", "14", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6"]
    let usArrayKids = ["4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "12.5", "13","13.5", "1", "1.5", "2", "2.5", "3", "3.5", "4","4.5", "5", "5.5", "6", "6.5", "7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderAction()
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
        header.headerTitle.text = "sizeGuide".localized.uppercased()
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            Common.sharedInstance.backtoOriginalButton(aBtn: header.backButton)

        }
        else{
            Common.sharedInstance.rotateButton(aBtn: header.backButton)
        }
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        print("Cart Back Pressed")
        self.dismiss(animated: true, completion: nil)
    }
}
extension sizeGuideVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return euArrayWomen.count
        case 1: return euArrayMen.count
        case 2: return babyAgeArray.count
        case 3: return euArrayKids.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 162
    }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            if section == 2 {
                return babysizeGuideHeader()
            }else{
                let tblheaderView = sizeGuideHeader()
                switch section {
                case 0: tblheaderView.lblMenWomenSizes.text = "womenSize".localized
                case 1: tblheaderView.lblMenWomenSizes.text = "menSize".localized
                case 3: tblheaderView.lblMenWomenSizes.text = "kidsSize".localized
                default:
                    tblheaderView.lblMenWomenSizes.text = "womenSize".localized
                }
                // Return view.
                return tblheaderView
            }

            
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "babySizeCell", for: indexPath) as! babySizeCell
            if indexPath.row.isMultiple(of: 2) {
                cell.backgroundColor = colorNames.cfafafa
                
            }else{
               cell.backgroundColor = .white
            }
            cell.setdata(age: babyAgeArray[indexPath.row], eu: euArrayBaby[indexPath.row], uk: ukArrayBaby[indexPath.row], us: usArrayBaby[indexPath.row])
            //cell.setdata(eu: euArrayKids[indexPath.row], uk: ukArrayKids[indexPath.row], us: usArrayKids[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeGuideCell", for: indexPath) as! SizeGuideCell
            if indexPath.row.isMultiple(of: 2) {
                cell.backgroundColor = colorNames.cfafafa
                
            }else{
               cell.backgroundColor = .white
            }
            switch indexPath.section {
            case 0: cell.setdata(eu: euArrayWomen[indexPath.row], uk: ukArrayWomen[indexPath.row], us: usArrayWomen[indexPath.row])
            case 1: cell.setdata(eu: euArrayMen[indexPath.row], uk: ukArrayMen[indexPath.row], us: usArrayMen[indexPath.row])
            case 3: cell.setdata(eu: euArrayKids[indexPath.row], uk: ukArrayKids[indexPath.row], us: usArrayKids[indexPath.row])
            default:
                cell.setdata(eu: "", uk: "", us: "")
            }
            return cell
        }
    }

}
