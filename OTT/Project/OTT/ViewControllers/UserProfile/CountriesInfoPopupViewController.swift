//
//  CountriesInfoPopupVC.swift
//  YUPPTV
//
//  Created by Ankoos on 26/10/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
protocol CountySelectionProtocol {
    func countrySelected(countryObj:Country)
}
class CountriesInfoPopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate {
    
    
    var delegate:CountySelectionProtocol! = nil
    @IBOutlet weak var countriesTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var countryheaderLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleLabelTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var cancelButtonTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    var countriesArray = [Country]()
    var alphaSections = [String]()
    var sectionsArray = [String : [Country]]()
    var searchActive : Bool = false
    func allSections() -> [String] {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.returnKeyType = .default
        searchBar.placeholder = "Search for country name or code.".localized

        if #available(iOS 11.0, *) {
            titleLabelTopConstraint.constant = 10
            cancelButtonTopConstraint.constant = 10
            viewHeightConstraint.constant = 50
        } else {
            titleLabelTopConstraint.constant = 35
            cancelButtonTopConstraint.constant = 35
            viewHeightConstraint.constant = 80
        }
        countriesTable.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
         alphaSections  = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        self.countryheaderLbl.text = "Select your country code".localized
        self.countryheaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.countryheaderLbl.font = UIFont.ottRegularFont(withSize: 16.0)
        self.headerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.cancelBtn.setTitle("cancel".localized, for: UIControl.State.normal)
        self.cancelBtn.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        view.isOpaque = false
        self.view.alpha = 1.0
        if countriesArray.count > 0 {
            
            for item in alphaSections {
                
                var tempArray = [Country]()
                for countryItem in countriesArray {
                    
                    if countryItem.name.hasPrefix(item.uppercased()) {
                        tempArray.append(countryItem)
                    }
                }
                
                sectionsArray[item] = tempArray
                
            }
            self.countriesTable.reloadData()
        }
        self.countriesTable.register(UINib.init(nibName: "CountriesInfoPopupCell", bundle: nil), forCellReuseIdentifier: "CountriesInfoPopupCell")
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CountriesInfoPopupVC.dissmissPopup))
//        tap.delegate = self
//        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissCountryPopUp() {
        self.dissmissPopup()
    }
    
    func dissmissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkContainsCharacters(inputStr:String) -> Bool {
        
        let charStatusArr = NSMutableArray()
        
        
        for chr in inputStr {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                charStatusArr.add(NSNumber.init(value: false))
            }
            else {
                charStatusArr.add(NSNumber.init(value: true))
            }
        }
        if charStatusArr.contains(NSNumber.init(value: true)) {
            return true
        }
        else {
            return false
        }
    }
    
    //MARK: - Search bar delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchingStr = searchText
        if !checkContainsCharacters(inputStr: searchingStr) && searchingStr.count > 0 {
            printYLog(searchingStr)
            var newString = "+\((searchingStr.replacingOccurrences(of: "+", with: "")))" as NSString
            newString = (newString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String as NSString)
            searchBar.text = newString as String
            newString = String.init(format: "%@", (newString.replacingOccurrences(of: "+", with: ""))) as NSString
            searchingStr = newString as String
        }
        
        if searchingStr == "" {
            self.alphaSections = self.allSections()
            
            for item in self.alphaSections {
                var tempArray2 = [Country]()
                for countryItem in countriesArray {
                    if countryItem.name.hasPrefix(item.uppercased()) {
                        tempArray2.append(countryItem)
                    }
                }
                sectionsArray[item] = tempArray2
            }
            self.countriesTable.reloadData()
            return
        }
        
        if countriesArray.count > 0 {
            var tempArray = [Country]()
            
            let filteredarr = countriesArray.filter { $0.name.lowercased().contains(searchingStr.lowercased()) || (String($0.isdCode)).hasPrefix(searchingStr)}
            
            if filteredarr.count > 0 {
                tempArray = filteredarr as [Country]
            }
            
            for item in alphaSections {
                var tempArray2 = [Country]()
                for countryItem in tempArray {
                    if countryItem.name.hasPrefix(item.uppercased()) {
                        tempArray2.append(countryItem)
                    }
                }
                sectionsArray[item] = tempArray2
            }
        }
        if (sectionsArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.countriesTable.reloadData()
    }

}
extension CountriesInfoPopupViewController
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.alphaSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.alphaSections[section]
        if self.sectionsArray.count > 0 {
            let dict = self.sectionsArray[item]!
            return (dict.count > 0 ?  dict.count : 0)
        }
        else {
            return 0
        }
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "CountriesInfoPopupCell"
        
        let item = self.alphaSections[indexPath.section]
        let dict = self.sectionsArray[item]!
        
        
        let countryObj = dict[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        
        //configure your cell
        let iconImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        let nameLabel:UILabel = cell?.contentView.viewWithTag(2) as! UILabel
        let countryCodeLabel:UILabel = cell?.contentView.viewWithTag(3) as! UILabel
        cell?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        nameLabel.text = countryObj.name
        countryCodeLabel.text = "\(countryObj.isdCode)"
        nameLabel.font = UIFont.ottRegularFont(withSize: 13.0)
        countryCodeLabel.font = UIFont.ottRegularFont(withSize: 13.0)
        nameLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        countryCodeLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        iconImageView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.alphaSections[indexPath.section]
        let countries = self.sectionsArray[item]!
        let dict = countries[indexPath.row]
        self.delegate.countrySelected(countryObj: dict)
        self.dismiss(animated: true, completion: nil)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.alphaSections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let item = self.alphaSections[section]
        if let countries = self.sectionsArray[item]{
            if countries.count > 0 {
                return 50
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        let countries = self.sectionsArray[title]!
       
        if countries.count > 0 {
         
            tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top , animated: false)
        }
        return self.alphaSections.firstIndex(of: title)!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        let vw = UILabel.init(frame: CGRect(x: 30, y: 0, width: tableView.frame.size.width - 30, height: 50))
        vw.text = self.alphaSections[section].uppercased()
        vw.textAlignment = .left
        vw.font = UIFont.ottRegularFont(withSize: 18.0)
        vw.textColor = AppTheme.instance.currentTheme.cardTitleColor
        view.addSubview(vw)
        return view
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
}
