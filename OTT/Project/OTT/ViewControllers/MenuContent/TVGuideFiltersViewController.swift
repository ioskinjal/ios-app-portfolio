//
//  TVGuideFiltersViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 14/06/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol TVGuideFilterSelectionProtocol {
    func tvGuidefilterSelected(filterDic:[String:Any])
    func tvGuidefilterCancelled()
}

class TVGuideFiltersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var langBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    var tvGuideFilters = [Filter]()
    var mainFilterObj:Filter?
    var filterItems = [FilterItem]()
    var selectedCategoryFilterArr = NSMutableArray()
    var selectedLangFilterArr = NSMutableArray()
    var isLangFilterSelected:Bool = false
    var delegate:TVGuideFilterSelectionProtocol! = nil
    var filterDic = [String : Any]()

    @IBOutlet weak var catgBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var applybtnView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        self.categoryBtn.layer.shadowColor = UIColor.black.cgColor
        self.categoryBtn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.categoryBtn.layer.shadowRadius = 1.0
        self.categoryBtn.layer.shadowOpacity = 1.0
        self.categoryBtn.layer.masksToBounds = false
        self.langBtn.layer.shadowColor = UIColor.black.cgColor
        self.langBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.langBtn.layer.shadowRadius = 1.0
        self.langBtn.layer.shadowOpacity = 1.0
        self.langBtn .layer.masksToBounds = false
        self.applybtnView.layer.shadowColor = UIColor.black.cgColor
        self.applybtnView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.applybtnView.layer.shadowRadius = 1.0
        self.applybtnView.layer.shadowOpacity = 1.0
        self.applybtnView .layer.masksToBounds = false
        
        var isLangAvailable:Bool = true
        for filterObj in self.tvGuideFilters {
            if filterObj.code == "genreCode" {
                self.mainFilterObj = filterObj
                filterItems = filterObj.items
                categoryBtn.setTitle(filterObj.title, for: .normal)
                categoryBtn.setTitleColor(UIColor.init(hexString: "0d2947"), for: .normal)
                categoryBtn.backgroundColor = UIColor.white
                langBtn.setTitleColor(UIColor.init(hexString: "838282"), for: .normal)
                langBtn.backgroundColor = UIColor.init(hexString: "f2f2f2")
                isLangAvailable = false
            }
            else {
                langBtn.setTitle(filterObj.title, for: .normal)
                if filterObj.items.count == 0 {
                    isLangAvailable = false
                }
                else {
                    isLangAvailable = true
                }
            }
        }
        if filterItems.count > 0 {
            self.filtersTableView.reloadData()
        }
        if !isLangAvailable {
            self.langBtn.isHidden = true
            self.catgBtnWidthConstraint.constant = self.view.frame.size.width
        }
        else {
            self.langBtn.isHidden = false
        }
        self.filtersTableView.register(UINib.init(nibName: "BitRateCell", bundle: nil), forCellReuseIdentifier: "BitRateCell")

        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    func initFilterArr(catgArr:NSMutableArray, langArr:NSMutableArray) {
        self.selectedCategoryFilterArr = NSMutableArray.init(array: catgArr)
        self.selectedLangFilterArr = NSMutableArray.init(array: langArr)
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        for filterObj in self.tvGuideFilters {
            if filterObj.code == "genreCode" {
                self.mainFilterObj = filterObj
                filterItems = filterObj.items
                categoryBtn.setTitleColor(UIColor.init(hexString: "0d2947"), for: .normal)
                categoryBtn.backgroundColor = UIColor.white
                langBtn.setTitleColor(UIColor.init(hexString: "838282"), for: .normal)
                langBtn.backgroundColor = UIColor.init(hexString: "f2f2f2")
                
                break;
            }
        }
        self.isLangFilterSelected = false
        if filterItems.count > 0 {
            self.filtersTableView.reloadData()
        }
    }
    
    @IBAction func langBtnClicked(_ sender: Any) {

        for filterObj in self.tvGuideFilters {
            if filterObj.code == "langCode" {
                self.mainFilterObj = filterObj
                filterItems = filterObj.items
                langBtn.setTitleColor(UIColor.init(hexString: "0d2947"), for: .normal)
                langBtn.backgroundColor = UIColor.white
                categoryBtn.setTitleColor(UIColor.init(hexString: "838282"), for: .normal)
                categoryBtn.backgroundColor = UIColor.init(hexString: "f2f2f2")
                break;
            }
        }
        self.isLangFilterSelected = true
        if filterItems.count > 0 {
            self.filtersTableView.reloadData()
        }
        

    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
//        self.selectedCategoryFilterArr.removeAllObjects()
//        self.selectedLangFilterArr.removeAllObjects()
        self.delegate.tvGuidefilterCancelled()
    }
    
    @IBAction func applyBtnClicked(_ sender: Any) {
        
        for filterObj in self.tvGuideFilters {
            if filterObj.code == "genreCode" {
                self.filterDic[filterObj.code] = self.selectedCategoryFilterArr
            }
            else {
                self.filterDic[filterObj.code] = self.selectedLangFilterArr
            }
        }
        
        self.delegate.tvGuidefilterSelected(filterDic: self.filterDic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterItems.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BitRateCell")
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let filterItem = filterItems[indexPath.row]
        cell?.textLabel?.text = filterItem.title
        let cellImageView = cell?.contentView.subviews[1] as! UIImageView
        
        if isLangFilterSelected {
            if self.selectedLangFilterArr.contains(filterItem.code) {
                cellImageView.image = #imageLiteral(resourceName: "check_selected")
            }
            else {
                cellImageView.image = #imageLiteral(resourceName: "circle_icon")
            }
        }
        else {
            if self.selectedCategoryFilterArr.contains(filterItem.code) {
                cellImageView.image = #imageLiteral(resourceName: "check_selected")
            }
            else {
                cellImageView.image = #imageLiteral(resourceName: "circle_icon")
            }
        }
//        if ccData.language != self.defaultSubtitleLang {
//            cellImageView.isHidden = true
//        }
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.textLabel?.font = UIFont.ottRegularFont(withSize: 14.0)
        cell?.textLabel?.textColor = UIColor.init(hexString: "333333")
        cell?.contentView.backgroundColor = UIColor.white
//        cell?.backgroundColor = UIColor.black
//        cell?.contentView.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return cell!
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterItemObj = filterItems[indexPath.row]
        if self.isLangFilterSelected {
            if (self.mainFilterObj?.multiSelectable)! {
                if self.selectedLangFilterArr.contains(filterItemObj.code) {
                    self.selectedLangFilterArr.remove(filterItemObj.code)
                }
                else {
                    self.selectedLangFilterArr.add(filterItemObj.code)
                }
            }
            else {
                if self.selectedLangFilterArr.contains(filterItemObj.code) {
                    self.selectedLangFilterArr.removeAllObjects()
                }
                else {
                    self.selectedLangFilterArr.removeAllObjects()
                    self.selectedLangFilterArr.add(filterItemObj.code)
                }
            }
        }
        else {
            if (self.mainFilterObj?.multiSelectable)! {
                if self.selectedCategoryFilterArr.contains(filterItemObj.code) {
                    self.selectedCategoryFilterArr.remove(filterItemObj.code)
                }
                else {
                    self.selectedCategoryFilterArr.add(filterItemObj.code)
                }
            }
            else {
                if self.selectedCategoryFilterArr.contains(filterItemObj.code) {
                    self.selectedCategoryFilterArr.removeAllObjects()
                }
                else {
                    self.selectedCategoryFilterArr.removeAllObjects()
                    self.selectedCategoryFilterArr.add(filterItemObj.code)
                }
            }
        }
        self.filtersTableView.reloadData()
    }
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.7)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
