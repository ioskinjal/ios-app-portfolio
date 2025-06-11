//
//  DevicesViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 24/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
protocol DelinkingDeviceProtocol {
    func deviceDelinked()
}

class DevicesViewController: UIViewController,UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl1: UILabel!
    @IBOutlet weak var headerLbl2: UILabel!
    @IBOutlet weak var linkedDevicesTable: UITableView!
    @IBOutlet private weak var delinkButton : UIButton!
    var linkedDeviceArr = [Device]()
    var selectedLinkedDeviceArr = [Device]()
    var delegate:DelinkingDeviceProtocol! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        delinkButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        self.linkedDevicesTable.register(UINib.init(nibName: "DeviceTableCell", bundle: nil), forCellReuseIdentifier: "DeviceTableCell")
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.linkedDeviceList(onSuccess: { (response) in
            self.stopAnimating()
            self.linkedDeviceArr = response
            self.linkedDevicesTable.reloadData()
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message)
            Log(message: error.message)
        }
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    @IBAction func delinkDeviceClicked(_ sender: Any) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        if self.selectedLinkedDeviceArr.count > 0 {
            let device = self.selectedLinkedDeviceArr.first
            OTTSdk.userManager.delinkDevice(boxId: (device?.boxId)!, deviceType: (device?.deviceId)!, onSuccess: { (response) in
                self.stopAnimating()
                self.delegate.deviceDelinked()
                self.dismiss(animated: true, completion: nil)
            }, onFailure: { (error) in
                self.stopAnimating()
                self.showAlertWithText(message: error.message)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func backActionClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Tableview Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.linkedDeviceArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deviceDetails = self.linkedDeviceArr[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableCell") as! DeviceTableCell
        cell.deviceNameLabel.text = "\(deviceDetails.boxId)"
        cell.desclabel.text = Date().getFullDate("\(deviceDetails.loggedinTime)")
        cell.deactivatebutton.setImage(#imageLiteral(resourceName: "check_selected"), for: UIControl.State.selected)
        
        if self.selectedLinkedDeviceArr.count > 0 {
            let boxIdArray = self.selectedLinkedDeviceArr.map({ (device: Device) -> String in
                device.boxId
            })
            if boxIdArray.contains(deviceDetails.boxId) {
                cell.deactivatebutton.isSelected = true
            }
            else {
                cell.deactivatebutton.isSelected = false
            }
        }
        else {
            cell.deactivatebutton.isSelected = false
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLinkedDeviceArr.removeAll()
        let deviceDetails = self.linkedDeviceArr[indexPath.item]
        self.selectedLinkedDeviceArr.append(deviceDetails)
        self.linkedDevicesTable.reloadData()
    }
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
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
