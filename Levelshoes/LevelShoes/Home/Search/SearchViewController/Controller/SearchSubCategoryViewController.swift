//
//  SearchSubCategoryViewController.swift
//  LevelShoes
//
//  Created by Maa on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SearchSubCategoryViewController: UIViewController {

    @IBOutlet weak var topViewHeader: UIView!
    @IBOutlet weak var tableViews: UITableView!
    @IBOutlet weak var btnViewAll: UIButton!{
        didSet{
            btnViewAll.underline()
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
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
     var arrSubCategory: [NSManagedObject] = []
    var TopTitleName = ""
    static var searchSubCategoryBoardInstance:SearchSubCategoryViewController? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchSubCategoryViewController.identifier) as? SearchSubCategoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells =
            [SearchSubCategoryTableViewCell.className]
        tableViews.register(cells)
        self.lblTitle.text = TopTitleName.uppercased()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let  productName : ProductList = arrSubCategory[arrSubCategory.count - 1] as! ProductList
        let btnTitle = productName.catName!
        let footer  = viewallV(frame: CGRect(x: 0, y: 0, width: tableViews.frame.size.width, height: 120))
        footer.lblViewAll.text = btnTitle.uppercased()
        footer.lblViewAll.underlineLabel()
        footer.btnAll.addTarget(self, action: #selector(viewallSelector), for: .touchUpInside)
        tableViews.tableFooterView = footer

    }

    @objc func viewallSelector(sender : UIButton) {
        print("View all Pressed")
        showCategory(aRow: arrSubCategory.count - 1)
    }
    @IBAction func TapToCloseBotton(_ sender: UIButton) {
        close()

    }
    func showCategory(aRow : Int ){
        //view all designer move to Atoz screen
           var productName : ProductList = arrSubCategory[aRow] as! ProductList
        // //add for view all design confirm Narayan sir
        if ( productName.genderID == CommonUsed.globalUsed.genderWomen && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersWomenId) || ( productName.genderID == CommonUsed.globalUsed.genderMen && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersMenId ) || ( productName.genderID == CommonUsed.globalUsed.genderKids && productName.categoryId == CommonUsed.globalUsed.viewAllDesignersKidId ){
             OpenAZScreen()
        }else{
        
        let nextVC = NewInVC.storyboardInstance!
        if productName.genderID == CommonUsed.globalUsed.genderMen{
            nextVC.strGen = CommonUsed.globalUsed.genderMenId
        }else if productName.genderID == CommonUsed.globalUsed.genderWomen{
            nextVC.strGen = CommonUsed.globalUsed.genderWomenId
        }else if productName.genderID == CommonUsed.globalUsed.genderKids{
            nextVC.strGen = CommonUsed.globalUsed.genderKidsId
        }
           //nextVC.strGen = productName.genderID!
            nextVC.parentCategoryName =  productName.parentCatName ?? ""
           nextVC.headlingLbl = productName.catName!
            nextVC.categoryName = productName.catName!
        if productName.linkType == "link" && !(productName.linkCatIds!.contains("{")) {
            var templinkid = productName.linkCatIds
            var validetorlinkId = templinkid?.components(separatedBy: "|")
            var linkId  = validetorlinkId![0] as? String
            nextVC.cat_id = Int(linkId!)!
            
        }else{
              nextVC.cat_id = Int(productName.categoryId!)!
        }
           self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func OpenAZScreen(){
        self.dismiss(animated: true, completion: {
                   NotificationCenter.default.post(name: Notification.Name(notificationName.changeTabBar), object: 1)
               })
    }
    
    func close() {
      let transition = CATransition()
      transition.duration = 0.5
      transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      transition.type = kCATransitionFade
      transition.subtype = kCATransitionFromLeft
      navigationController?.view.layer.add(transition, forKey:kCATransition)
      let _ = navigationController?.popViewController(animated: true)
    }
}

extension SearchSubCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubCategory.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSubCategoryTableViewCell", for: indexPath) as? SearchSubCategoryTableViewCell else{return UITableViewCell()}
        
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
            cell._lblCategoryName.font = UIFont(name: "Cairo-Light", size: cell._lblCategoryName.font.pointSize)
        }
       
               var productName : ProductList = arrSubCategory[indexPath.row] as! ProductList
               cell._lblCategoryName.text = productName.catName as? String

//        cell._lblCategoryName.text = (arr as AnyObject).value(forKeyPath: "name") as? String
//        cell._lblCategoryName.text = "text"
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 70
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//    let  productName : ProductList = arrSubCategory[arrSubCategory.count - 1] as! ProductList
//        let btnTitle = productName.catName!
//        print("Button TItle \(btnTitle)")
//        let footer  = viewallV(frame: CGRect(x: 0, y: 0, width: tableViews.frame.size.width, height: 70))
//        footer.btnAll.setTitle("TERINFG", for: .normal)
//        footer.btnAll.addTarget(self, action: #selector(viewallSelector), for: .touchUpInside)
//        tableViews.tableFooterView = footer
//        return footer
//    }




    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // let indexPath = tableView.indexPathForSelectedRow
           let currentCell = tableView.cellForRow(at: indexPath)! as! SearchSubCategoryTableViewCell
        showCategory(aRow: indexPath.row)
       }
    
}
