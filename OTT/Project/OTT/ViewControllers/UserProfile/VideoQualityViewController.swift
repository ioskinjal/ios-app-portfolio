//
//  HelpOptionsVC.swift
//  sampleColView
//
//  Created by Ankoos on 12/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk

struct videoQualityItem {
    var code = ""
    var maxBitRate = 0
    var minBitRate = 0
    var displayMessage = ""
    var displaySubTitle = ""
    var displayTitle = ""
}
class VideoQualityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var helpHeaderLbl1: UILabel!
    @IBOutlet weak var videoQualityOptionsTable: UITableView!
    var titlesArray = [String]()
    
    var videoQualityObjectsArray = [videoQualityItem]()
    
    func nearestElement(powerD : Float, array : [Float]) -> Float {
         
        var closest: Float = array[0]

        for item in array {
            if abs(powerD - item) < abs(powerD - closest) {
                closest = item
            }
        }

        print(closest)
        return closest
        
    }
    
   var closestElement : Float = 0
    func setBitrateCurrent() {
        var bitrateARRyInt = [Float]()
        for item in self.videoQualityObjectsArray {
            let fl = Float(item.maxBitRate)
            bitrateARRyInt.append(fl)
        }
        let bitRateValue = AppDelegate.getDelegate().selectedVideoQualityMaxBitrate

        closestElement = self.nearestElement(powerD: Float(bitRateValue), array: bitrateARRyInt )
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        videoQualityOptionsTable.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor

        if AppDelegate.getDelegate().configs?.videoQualitySettings.isEmpty == false {
            let dataString = AppDelegate.getDelegate().configs?.videoQualitySettings
            let data = dataString!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                   print(jsonArray) // use the json here
                    for item in jsonArray {
                        var _code = ""
                        if let _tempcode = item["code"] as? String {
                            _code = _tempcode
                        }
                        
                        var _maxBitRate = 0
                        if let _tempMaxBitRate = item["maxBitRate"] as? Int {
                            _maxBitRate = _tempMaxBitRate
                        }
                        
                        var _minBitRate = 0
                        if let _tempMinBitRate = item["minBitRate"] as? Int {
                            _minBitRate = _tempMinBitRate
                        }
                        
                        var _displayMessage = ""
                        if let _tempDisplayMessage = item["displayMessage"] as? String {
                            _displayMessage = _tempDisplayMessage
                        }
                        
                        var _displayTitle = ""
                        if let _tempDisplayTitle = item["displayTitle"] as? String {
                            _displayTitle = _tempDisplayTitle
                        }
                        
                        var _displaySubTitle = ""
                        if let _tempDisplaySubTitle = item["displaySubTitle"] as? String {
                            _displaySubTitle = _tempDisplaySubTitle
                        }
                        let tempMaxBitRate = (AppDelegate.getDelegate().configs?.maxBitRate) ?? -1
                        if (tempMaxBitRate == -1 || _maxBitRate == 0) {
                            let obj = videoQualityItem.init(code: _code, maxBitRate: _maxBitRate, minBitRate: _minBitRate, displayMessage: _displayMessage , displaySubTitle: _displaySubTitle , displayTitle: _displayTitle )
                            videoQualityObjectsArray.append(obj)
                        }
                        else {
                            if _maxBitRate < tempMaxBitRate {
                                let obj = videoQualityItem.init(code: _code, maxBitRate: _maxBitRate, minBitRate: _minBitRate, displayMessage: _displayMessage , displaySubTitle: _displaySubTitle , displayTitle: _displayTitle )
                                videoQualityObjectsArray.append(obj)
                            }
                        }
                       
                    }
                        let objsArray = videoQualityObjectsArray.filter{ ($0.maxBitRate == AppDelegate.getDelegate().selectedVideoQualityMaxBitrate) }
                        if objsArray.count > 0 {
                            AppDelegate.getDelegate().selectedVideoQualityMaxBitrate = objsArray.first!.maxBitRate
                        }
                    
                    self.setBitrateCurrent()
                    self.videoQualityOptionsTable.reloadData()
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
      
        self.helpHeaderLbl1.text = "Video Quality".localized
        
        // ["Ways To Watch","Why Us","FAQ's","Privacy & Terms","Contact Us"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoQualityOptionsTable.reloadData()
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    @IBAction func BackAction(_ sender: Any) {
        self.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - GotoBrowserUrl
    
    func GotoBrowserUrl(urlstring : String,PageString:String) -> Void {
        
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
extension VideoQualityViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoQualityObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "videoprefferencesCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        let titleLabel:UILabel = cell?.contentView.viewWithTag(2) as! UILabel
        let subTitleLabel:UILabel = cell?.contentView.viewWithTag(3) as! UILabel
        let radioBtn:UIButton = cell?.contentView.viewWithTag(1) as! UIButton
        
        let item = self.videoQualityObjectsArray[indexPath.item]
        titleLabel.text = item.displayTitle
        subTitleLabel.text = item.displaySubTitle
        
        titleLabel.font = UIFont.ottSemiBoldFont(withSize: 14)
        subTitleLabel.font = UIFont.ottRegularFont(withSize: 15)
        titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        subTitleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        cell?.accessoryType = .none
        let obj = Float(item.maxBitRate)
        if obj == closestElement {
            radioBtn.setImage(UIImage.init(named: "bitrate_select")?.withRenderingMode(.alwaysTemplate), for: .normal)
            radioBtn.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        }else{
            radioBtn.setImage(UIImage.init(named: "bitrate_unselect"), for: .normal)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        return cell!
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.getDelegate().selectedVideoQualityMaxBitrate = self.videoQualityObjectsArray[indexPath.item].maxBitRate
        self.setBitrateCurrent()
        self.videoQualityOptionsTable.reloadData()
        
    }
}
