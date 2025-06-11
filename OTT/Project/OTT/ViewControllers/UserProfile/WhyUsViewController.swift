//
//  AboutVC.swift
//  YuppFlix
//
//  Created by Ankoos on 29/08/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
class WhyUsViewController: UIViewController {
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var whyUsHeaderLbl1: UILabel!
/*
,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var aboutUSTable: UITableView!
    var aboutUsDict:NSDictionary!
    /*
    var aboutUsObj : AboutUs.About?
    var packageContentObj : AboutUs.PackageContent?
    var packageProcessObj : AboutUs.PackageProcess?
    
     */
    var cellYPosition:Int = 0
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.aboutUSTable.tableHeaderView = self.headerView
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        /*
        self.startAnimating(allowInteraction: false)
        YuppTVSDK.staticContentManager.aboutUs(onSuccess: { (response) in
            self.aboutUsObj = response.about
            self.packageContentObj = response.packageContent
            self.packageProcessObj = response.packageProcess
            self.stopAnimating()
            self.reloadHeaderView()
            self.aboutUSTable .reloadData()
            
        }) { (error) in
            Log(message: error.message)
        }
 */
    }
    func reloadHeaderView() -> Void {
        let titleLabel0 = self.headerView.viewWithTag(1) as! UILabel
        let descriptionLabel01 = self.headerView.viewWithTag(2) as! UILabel
        
        let baseHolderView = self.headerView.viewWithTag(3)
        baseHolderView?.tvShowCornerDesign()
        
        
        //        descriptionLabel01.frame = CGRect(x: 10, y: titleLabel0.frame.maxY + 10, width: self.headerView.frame.size.width-10, height: 100)
        
        
        //description  image title
        if aboutUsObj?.title != nil {
            
            
            let titleStr = self.aboutUsObj?.title.text
            
            titleLabel0.text = titleStr?.uppercased()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.5
            
            let attrString = NSMutableAttributedString(string: (self.aboutUsObj?.description.text)!)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            
            descriptionLabel01.attributedText = attrString
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func packageContentfeaturesArrayCount() -> Int {
        
        if  self.packageContentObj != nil {
            
            if (self.packageContentObj?.features.count)! > 0
            {
                let featuresArray = self.packageContentObj?.features as NSArray?
                return (featuresArray?.count)!
            }
            
        }
        return 0
    }
    func featuresArrayCount() -> Int {
        
        if  self.packageProcessObj != nil {
            
            if self.packageProcessObj?.features != nil
            {
                let featuresArray = self.packageProcessObj?.features as NSArray?
                return (featuresArray?.count)!
            }
        }
        return 0
    }
    func featuresArrayDataDict(_ index:Int) -> AboutUs.DetailedInfo {
        var dict : AboutUs.DetailedInfo!
        if  self.packageProcessObj != nil {
            
            if self.packageProcessObj?.features != nil
            {
                let featuresArray = self.packageProcessObj?.features as NSArray?
                dict = featuresArray?[index] as! AboutUs.DetailedInfo
                return dict
            }
        }
        return dict
    }
    
    func packageContentDataDict(_ index:Int) -> AboutUs.DetailedInfo {
        var dict : AboutUs.DetailedInfo!
        if  self.packageContentObj != nil {
            
            if self.packageContentObj?.features != nil
            {
                let featuresArray = self.packageContentObj?.features
                dict = featuresArray?[index]
                return dict
            }
        }
        return dict
    }
    @IBAction func backAction(_ sender: AnyObject) {
        // AppDelegate.getDelegate().stopAnimating()
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - tableview
}
extension WhyUsViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 91 {
            return self.featuresArrayCount() as Int
        }else{
            return self.packageContentfeaturesArrayCount() as Int
        }
    }
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier:String
        let nib:String
        if collectionView.tag == 90
        {
            
            if UIScreen.main.screenType == .iPhone6
            {
                cellIdentifier  = "aboutCell90"
                nib  = "aboutCell90"
            }
            else if UIScreen.main.screenType == .iPhone5
            {
                cellIdentifier  = "about_iphone5Cell"
                nib  = "about_iphone5Cell"
            }else{
                cellIdentifier  = "aboutCell90"
                nib  = "aboutCell90"
            }
            
            
            let dict = self.packageContentDataDict(indexPath.row) as AboutUs.DetailedInfo
            
            collectionView.register(UINib.init(nibName: nib, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let imageVW = cell.contentView.viewWithTag(1) as! UIImageView
            imageVW.loadImageFromUrl(dict.image)
            
            let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text  = dict.text
            return cell
            
            
            
        }else
        {
            if UIScreen.main.screenType == .iPhone5
            {
                cellIdentifier  = "aboutCell91"
                nib  = "aboutCell91"
            }
            else if UIScreen.main.screenType == .iPhone6
            {
                cellIdentifier  = "aboutCell91_6"
                nib  = "aboutCell91_6"
            }else if UIScreen.main.screenType == .iPhone6Plus
            {
                cellIdentifier  = "aboutCell91_6Plus"
                nib  = "aboutCell91_6Plus"
            }
            else{
                cellIdentifier  = "aboutCell91_6Plus"
                nib  = "aboutCell91_6Plus"
            }
            
            
            let dict = self.featuresArrayDataDict(indexPath.row) as AboutUs.DetailedInfo
            
            
            collectionView.register(UINib.init(nibName: nib, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text  = dict.text
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
            
            //            let cellHeight = Int(heightForView(text: titleLabel.text!, font: titleLabel.font, width: titleLabel.frame.size.width))
            //
            //            cell.frame = CGRect(x: 0, y: (indexPath.row * cellHeight), width: Int(collectionView.frame.size.width), height: cellHeight)
            
            let noLabel = cell.contentView.viewWithTag(1) as! UILabel
            noLabel.text  = "\(indexPath.row + 1)" as String
            
            //             noLabel.layer.cornerRadius = noLabel.frame.width/2
            noLabel.LabelCornerAndBorder(label: noLabel)
            
            
            return cell
        }
        
        
    }
    
}
extension WhyUsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "cell1"
        
        let cell:AboutVCMainCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AboutVCMainCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let titleLabel1 = cell.contentView.viewWithTag(3) as! UILabel
        
        let baseView = cell.contentView.viewWithTag(4)
        baseView?.tvShowCornerDesign()
        
        if (indexPath as NSIndexPath).row == 0 {
            
            
            if  self.packageContentObj != nil {
                
                if self.packageContentObj?.title != nil {
                    let titleStr = self.packageContentObj?.title.text
                    titleLabel1.text = titleStr?.uppercased()
                }
            }
            if UIScreen.main.screenType == .iPhone6
            {
                cell.collectionLayout.itemSize = CGSize(width: 140, height: 130)
            }
            else if UIScreen.main.screenType == .iPhone5
            {
                cell.collectionLayout.itemSize = CGSize(width: 110, height: 120)
            }else{
                cell.collectionLayout.itemSize = CGSize(width: 140, height: 130)
            }
            
            cell.Collection.setCollectionViewLayout(cell.collectionLayout, animated: false)
            cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 450)
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate:self,del: self,index: 90)
            
        }
        else if (indexPath as NSIndexPath).row == 1
        {
            if  self.packageProcessObj != nil {
                
                if self.packageProcessObj?.title != nil {
                    let titleStr = self.packageProcessObj?.title.text
                    titleLabel1.text = titleStr?.uppercased()
                }
            }
            
            if UIScreen.main.screenType == .iPhone5
            {
                cell.collectionLayout.itemSize = CGSize(width: 300, height: 80)
                cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 290)
            }
            else if UIScreen.main.screenType == .iPhone6
            {
                cell.collectionLayout.itemSize = CGSize(width: 355, height: 70)
                cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 230)
            }else if UIScreen.main.screenType == .iPhone6Plus_OLD
            {
                cell.collectionLayout.itemSize = CGSize(width: 400, height: 60)
                cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 200)
            }else if UIScreen.main.screenType == .iPhone6Plus
            {
                cell.collectionLayout.itemSize = CGSize(width: 400, height: 60)
                cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 200)
            }
            else{
                cell.collectionLayout.itemSize = CGSize(width: 400, height: 60)
                cell.Collection.frame = CGRect(x: cell.Collection.frame.origin.x, y: cell.Collection.frame.origin.y, width: cell.Collection.frame.width, height: 200)
            }
            cell.collectionLayout.sectionInset = UIEdgeInsetsMake(5.0, 5.0,5.0,5.0);
            cell.collectionLayout.minimumLineSpacing = 1
            cell.Collection.setCollectionViewLayout(cell.collectionLayout, animated: false)
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate:self,del: self,index: 91)
            
        }
        
        
        return cell
        
        
        
        
    }
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0 {
            return 540
        }else
        {
            if UIScreen.main.screenType == .iPhone5
            {
                return 370
            }
            else if UIScreen.main.screenType == .iPhone6
            {
                return 330
            }else if UIScreen.main.screenType == .iPhone6Plus_OLD
            {
                return 310
            }else if UIScreen.main.screenType == .iPhone6Plus
            {
                return 310
            }
            else{
                return 310
            }
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}
 */
}

