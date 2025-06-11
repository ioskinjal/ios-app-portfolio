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
    func bitRateSelected(selected:String)
}
class BitRatesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var bitRateArry = NSMutableArray()
    var prefferedBitRate = String()
    @IBOutlet weak var bitrateTable: UITableView!
     var delegate:BitRateProtocol! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bitRateArry.count > 0 {
            if !self.bitRateArry.contains("0.0") {
                self.bitRateArry.insert("0.0", at: 0)
            }
            self.bitrateTable.reloadData()
        }
        self.bitrateTable.register(UINib.init(nibName: "BitRateCell", bundle: nil), forCellReuseIdentifier: "BitRateCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - tableview

extension BitRatesVC{
    
    @objc(tableView:heightForHeaderInSection:) func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    @objc(tableView: viewForHeaderInSection:)  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50)
        let headerView = UIView.init(frame: rect)
        let selectVdoQlty =  UILabel.init(frame: rect)
        selectVdoQlty.textColor = UIColor.white.withAlphaComponent(0.8)
        selectVdoQlty.textAlignment = NSTextAlignment.left
        selectVdoQlty.backgroundColor = UIColor.clear
        selectVdoQlty.font = UIFont(name: "Lato-Bold", size: 17)
        selectVdoQlty.text = "      Select video quality"
        headerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        headerView.layer.borderWidth = 1.0
        headerView.addSubview(selectVdoQlty)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bitRateArry.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BitRateCell")
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.textLabel?.text = bitRateArry.object(at: indexPath.row) as? String
        let cellImageView = cell?.contentView.subviews[1] as! UIImageView
        let bitRateStrings = cell?.textLabel?.text?.components(separatedBy: ".")
        cell?.textLabel?.text = formBitRateLabeltext(bitRate: (bitRateStrings?[0])!)
        if (bitRateStrings?[0] == "0") {
            cell?.textLabel?.text = "Auto"
        }
        if (bitRateStrings?[0] != prefferedBitRate.components(separatedBy: ".")[0]) {
            cellImageView.isHidden = true
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        cell?.backgroundColor = UIColor.black
        cell?.contentView.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return cell!
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.delegate.bitRateSelected(selected: (bitRateArry.object(at: indexPath.row) as? String)!)
    }
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func formBitRateLabeltext(bitRate:String) -> String {
        return String.init(format: "%@%@", bitRate," kbps")
    }
}
