//
//  BitRatesVC.swift
//  YuppFlix
//
//  Created by Ankoos on 07/11/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
protocol BitRateProtocol {
    // protocol definition goes here
    func bitRateSelected(selected:String,displayType:String)
}
class BitRatesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var bitRateArry = NSMutableArray()
    var prefferedBitRate = String()
    var displayType = String()
    @IBOutlet weak var bitrateTable: UITableView!
     var delegate:BitRateProtocol! = nil
    var closestElement : Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if bitRateArry.count > 0 {
            if !self.bitRateArry.contains("0.0") && displayType != "playBackSpeed"{
                self.bitRateArry.insert("0.0", at: 0)
            }
            if displayType == "quality" {
                if AppDelegate.getDelegate().selectedVideoQualityMaxBitrate == 0 ||   AppDelegate.getDelegate().configs?.videoQualitySettings.isEmpty == true {
                    // nothing to do
                }
                else {
                    self.getBitrateCurrent()
                    prefferedBitRate = String(describing: closestElement)
                }
            }
                
            self.bitrateTable.reloadData()
        }
        self.bitrateTable.register(UINib.init(nibName: "BitRateCell", bundle: nil), forCellReuseIdentifier: "BitRateCell")
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        if playerVC != nil {
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - tableview

extension BitRatesViewController{
    
    @objc(tableView:heightForHeaderInSection:) func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    @objc(tableView: viewForHeaderInSection:)  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 15, y: 0, width: tableView.bounds.size.width, height: 50)
        let headerView = UIView.init(frame: rect)
        let selectVdoQlty =  UILabel.init(frame: rect)
        selectVdoQlty.textColor = UIColor.white.withAlphaComponent(0.8)
        selectVdoQlty.textAlignment = NSTextAlignment.left
        selectVdoQlty.backgroundColor = UIColor.clear
        selectVdoQlty.font = UIFont.ottBoldFont(withSize: 17)
        selectVdoQlty.text = (self.displayType == "playBackSpeed" ? "Select playback speed" :"Select video quality".localized)
        headerView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        headerView.viewBorderWithOne(cornersRequired: false)
        headerView.addSubview(selectVdoQlty)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitRateArry.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BitRateCell")
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//        let bitRateValue1 = Double(AppDelegate.getDelegate().selectedVideoQualityMaxBitrate)
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.textLabel?.text = bitRateArry.object(at: indexPath.row) as? String
        let cellImageView = cell?.contentView.subviews[1] as! UIImageView
        if (displayType == "playBackSpeed"){
            if (cell?.textLabel?.text != prefferedBitRate) {
                cellImageView.isHidden = true
            } else {
                cellImageView.isHidden = false
            }
        }
        else{
            let bitRateStrings = cell?.textLabel?.text?.components(separatedBy: ".")
            cell?.textLabel?.text = formBitRateLabeltext(bitRate: (bitRateStrings?[0])!)
            if (bitRateStrings?[0] == "0") {
                cell?.textLabel?.text = "Auto".localized
            }
            if (bitRateStrings?[0] != prefferedBitRate.components(separatedBy: ".")[0]) {
                cellImageView.isHidden = true
            } else {
                cellImageView.isHidden = false
            }
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
//        cell?.backgroundColor = UIColor.black
//        cell?.contentView.superview?.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        return cell!
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.delegate.bitRateSelected(selected: (bitRateArry.object(at: indexPath.row) as? String)!, displayType: displayType)
    }
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func formBitRateLabeltext(bitRate:String) -> String {
        print("bitRate:\(bitRate)")
        var displayBitRateString = String.init(format: "%@%@", bitRate," kbps")
        
        if AppDelegate.getDelegate().configs?.videoQualitySettings.isEmpty == false {
            let dataString = AppDelegate.getDelegate().configs?.videoQualitySettings
            let data = dataString!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                   print(jsonArray) // use the json here
                    for item in jsonArray {
                        var _maxBitRate = 0
                        if let _tempMaxBitRate = item["maxBitRate"] as? Int {
                            _maxBitRate = _tempMaxBitRate
                        }
                        
                        var _minBitRate = 0
                        if let _tempMinBitRate = item["minBitRate"] as? Int {
                            _minBitRate = _tempMinBitRate
                        }
                        
                        var _displayTitle = ""
                        if let _tempDisplayTitle = item["displayTitle"] as? String {
                            _displayTitle = _tempDisplayTitle
                        }
                        
                        let tempMaxBitRate = (AppDelegate.getDelegate().configs?.maxBitRate) ?? -1
                        if (tempMaxBitRate != -1 && _maxBitRate != 0) {
                            let bitRateIntValue = Int(bitRate) ?? 0
                            if ((bitRateIntValue > _minBitRate) && (bitRateIntValue <  _maxBitRate)) {
                                displayBitRateString = _displayTitle
                                break;
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }
                
        return displayBitRateString
    }
    
    func getBitrateCurrent() {
         var bitrateARRyInt = [Float]()
         for item in self.bitRateArry {
             let _item = String(describing:item)
             if (_item != "0.0") {
                 let fl = Float(_item)!
                 bitrateARRyInt.append(fl)
             }
         }
         let bitRateValue = Float(prefferedBitRate)!

         closestElement = self.nearestElement(powerD: bitRateValue, array: bitrateARRyInt )
     }
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
}
