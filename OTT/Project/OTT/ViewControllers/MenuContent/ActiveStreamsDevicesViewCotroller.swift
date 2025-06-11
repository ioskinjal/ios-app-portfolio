//
//  ActiveStreamsDevicesViewCotroller.swift
//  OTT
//
//  Created by Muzaffar Ali on 13/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

@objc protocol ActiveStreamsDevicesViewCotrollerDelegate{
    @objc func didClosedTheScreen(streamActiveSession : StreamActiveSession?, withSuccess : Bool)
}

class ActiveStreamsDevicesViewCotroller: UIViewController,OTTNavigationViewDelegate, ActiveStreamTableViewCellDelegate, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var streamActiveSessions :[StreamActiveSession] = []
    weak var delegate : ActiveStreamsDevicesViewCotrollerDelegate?
    @IBOutlet weak var activeDevicesMsgLbl: UILabel!
    @IBOutlet weak var activeDevicesMsgLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activeDevicesMsgLblWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationView: OTTNavigationView!
    @IBOutlet weak var tableView: UITableView!
    var isComingFromPlayerPage:Bool = false
    // MARK: -  Life Cycle Methods
    
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
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = false
        if productType.iPhone {
            let value1 = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value1, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        self.errorLabel.isHidden = true
        self.navigationView.delegate = self
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.errorLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.tableView.tableFooterView = UIView()
        self.tableView.register(ActiveStreamTableViewCell.self, forCellReuseIdentifier: "ActiveStreamTableViewCell")
        self.tableView.register(UINib.init(nibName: "ActiveStreamTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveStreamTableViewCell")
        tableView.separatorColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.activeDevicesMsgLbl.font = UIFont.ottMediumFont(withSize: 13)
        self.activeDevicesMsgLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6)
        if self.isComingFromPlayerPage {
            self.activeDevicesMsgLbl.text = AppDelegate.getDelegate().configs?.activeScreensTitleFromPlayer
        } else {
            self.activeDevicesMsgLbl.text = AppDelegate.getDelegate().configs?.activeScreensTitleFromSettings
        }
        self.activeDevicesMsgLbl.sizeToFit()
        self.activeDevicesMsgLblWidthConstraint.constant = (productType.iPad ? 400 : (DeviceType.IS_IPHONE_5 ? 310: 350))
        self.activeDevicesMsgLblHeightConstraint.constant = self.activeDevicesMsgLbl.frame.size.height + 50
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: AppDelegate.getDelegate().window!.bounds.width, height: 80.0))
        showActiveStreamSessions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    // MARK: - Network methods
    
    func showActiveStreamSessions(){
        self.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.streamActiveSessions(pollKey: playerVC?.streamResponse.sessionInfo.streamPollKey, onSuccess: { (_streamActiveSessions) in
            self.stopAnimating()
            if _streamActiveSessions.count > 0 {
                self.streamActiveSessions = _streamActiveSessions
                self.tableView.isHidden = false
//                self.activeDevicesMsgLblHeightConstraint.constant = self.activeDevicesMsgLbl.frame.size.height + 50
            } else {
                self.tableView.isHidden = true
                self.errorLabel.isHidden = false
                self.activeDevicesMsgLblHeightConstraint.constant = 0
            }
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            print("#Player : streamActiveSessions success streamActiveSessions.count \(self.streamActiveSessions.count)")
        }) { (error) in
            self.stopAnimating()
            self.tableView.isHidden = true
            self.errorLabel.isHidden = false
            self.activeDevicesMsgLblHeightConstraint.constant = 0
            print("#Player : streamActiveSessions error \(error.message)")
        }
    }
    
    func removeStreamSession(streamActiveSession : StreamActiveSession){
        self.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.endStreamSession(pollKey: streamActiveSession.streamPollKey, onSuccess: { (successMessage) in
            self.stopAnimating()
            // Show Alert and close the View
            let message = (successMessage.count > 0) ? successMessage : "Screen has been closed"
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue".localized, style: UIAlertAction.Style.default, handler: { (action) in
                self.delegate?.didClosedTheScreen(streamActiveSession: streamActiveSession, withSuccess: true)
                if self.isComingFromPlayerPage{ self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.showActiveStreamSessions()
                }
            }))
            self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message)
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.streamActiveSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveStreamTableViewCell", for: indexPath) as! ActiveStreamTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.cellWidthConstraint.constant = (productType.iPad ? 400 : (DeviceType.IS_IPHONE_5 ? 310: 350))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let streamSession = self.streamActiveSessions[indexPath.row]
        (cell as! ActiveStreamTableViewCell).setStreamActiveSession(streamActiveSession : streamSession)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - ActiveStreamTableViewCellDelegate
    func closeScreenTap(for cell:ActiveStreamTableViewCell, streamActiveSession : StreamActiveSession){
        self.removeStreamSession(streamActiveSession: streamActiveSession)
    }
    
    func didTapOnBackButton(navigationBarView : OTTNavigationView){
        self.delegate?.didClosedTheScreen(streamActiveSession: nil, withSuccess: false)
        self.navigationController?.popViewController(animated: true)
        printLog(log: #function as AnyObject)
    }
    
}

