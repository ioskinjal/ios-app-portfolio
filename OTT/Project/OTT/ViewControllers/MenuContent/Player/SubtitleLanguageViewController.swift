//
//  SubtitleLanguageViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 24/11/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol SubtitleLanguageProtocol {
    // protocol definition goes here
    func subtitleLangSelected(selected:String)
}

class SubtitleLanguageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var subTitleLangArry = [CCData]()
    var defaultSubtitleLang = String()
    @IBOutlet weak var subtitleLangTable: UITableView!
    var delegate:SubtitleLanguageProtocol! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.applicationBGColor
        if subTitleLangArry.count > 0 {
            self.subtitleLangTable.reloadData()
        }
        self.subtitleLangTable.register(UINib.init(nibName: "BitRateCell", bundle: nil), forCellReuseIdentifier: "BitRateCell")
        self.subtitleLangTable.tableFooterView = self.addFooterView()
        // Do any additional setup after loading the view.
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
    
    func addFooterView() -> UIView {
        let subtitleFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.subtitleLangTable.frame.width, height: 44.0))
        subtitleFooterView.backgroundColor = self.subtitleLangTable.backgroundColor
        let subtitleOffBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.subtitleLangTable.frame.width - 50.0, height: 44))
        subtitleOffBtn.setTitle("Off".localized, for: .normal)
        subtitleOffBtn.titleLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        subtitleOffBtn.titleLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleOffBtn.addTarget(self, action: #selector(subtitleOffClicked), for: .touchUpInside)
        subtitleOffBtn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -200.0, bottom: 0.0, right: 0.0)
        subtitleFooterView.addSubview(subtitleOffBtn)
        
        let subTitleOffSelectedImgView = UIImageView(frame: CGRect(x: (self.subtitleLangTable.frame.width - 50.0) + 18.0, y: 15.0, width: 13.0, height: 13.0))
        subTitleOffSelectedImgView.image = #imageLiteral(resourceName: "check_selected")
        if self.defaultSubtitleLang != "Off" {
            subTitleOffSelectedImgView.isHidden = true
        }
        subtitleFooterView.addSubview(subTitleOffSelectedImgView)
        
        return subtitleFooterView
    }
    
    @objc func subtitleOffClicked() {
        self.delegate.subtitleLangSelected(selected: "Off")
    }
}



extension SubtitleLanguageViewController{
    
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
        selectVdoQlty.text = "Select video quality".localized
        headerView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        headerView.viewBorderWithOne(cornersRequired: false)
        headerView.addSubview(selectVdoQlty)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTitleLangArry.count
    }
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BitRateCell")
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let ccData = subTitleLangArry[indexPath.row]
        cell?.textLabel?.text = ccData.language
        let cellImageView = cell?.contentView.subviews[1] as! UIImageView
        
        if ccData.language != self.defaultSubtitleLang {
            cellImageView.isHidden = true
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.textLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        cell?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
//        cell?.backgroundColor = UIColor.black
//        cell?.contentView.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return cell!
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ccData = subTitleLangArry[indexPath.row]
        self.delegate.subtitleLangSelected(selected: ccData.language)
    }
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.7)
    }
}

