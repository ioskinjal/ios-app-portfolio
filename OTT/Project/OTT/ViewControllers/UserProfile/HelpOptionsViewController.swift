//
//  HelpOptionsVC.swift
//  sampleColView
//
//  Created by Ankoos on 12/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk

class HelpOptionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var helpHeaderLbl1: UILabel!
    @IBOutlet weak var helpOptionsTable: UITableView!
    var titlesArray = [[String : Any]]()
    
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.cornerDesign()
        self.navigationView.backgroundColor =  AppTheme.instance.currentTheme.navigationBarColor
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.helpHeaderLbl1.text = "Help".localized
        self.helpHeaderLbl1.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        self.loadHelpJsonAndReload()
        if appContants.appName == .aastha || appContants.appName == .gac {
            self.navigationView.backgroundColor =  AppTheme.instance.currentTheme.navigationViewBarColor
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    func loadHelpJsonAndReload(){
        self.titlesArray = []
        if let array = AppDelegate.getDelegate().configs?.helpJsonString.convertToJson() as? [[String : Any]]{
            self.titlesArray = array
        }
        helpOptionsTable.reloadData()
    }
    
    @IBAction func BackAction(_ sender: Any) {
        self.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - GotoBrowserUrl
    
    func gotoBrowser(urlstring : String,PageString:String) -> Void {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
        view1.urlString = urlstring
        view1.pageString = PageString as String
        view1.viewControllerName = "HelpOptionsViewController"
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
        
    }
}

// MARK: - HelpOptionsVC Table Methods
extension HelpOptionsViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "accountprefferencesCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        let nameLabel:UILabel = cell?.contentView.viewWithTag(2) as! UILabel
        nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        let rightArrowView:UIImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        if let name = titlesArray[indexPath.row]["name"] as? String{
            nameLabel.text = name
        }
        rightArrowView.isHidden = false
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell!
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var name = ""
        var webUrl = ""
        if let _name = titlesArray[indexPath.row]["name"] as? String{
            name = _name
        }
        if let _webUrl = titlesArray[indexPath.row]["webUrl"] as? String{
            webUrl = _webUrl
        }
        self.gotoBrowser(urlstring: webUrl ,PageString: name)
    }
}
