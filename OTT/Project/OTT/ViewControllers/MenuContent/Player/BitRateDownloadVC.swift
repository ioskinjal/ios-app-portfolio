//
//  BitRateDownloadVC.swift
//  OTT
//
//  Created by Pramodkumar on 03/06/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//

import UIKit

class BitRateDownloadVC: UIViewController {
    @IBOutlet private weak var bitRateTableView : UITableView!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var cancelButton : UIButton!
    @IBOutlet private weak var centerVerticallyConstraint : NSLayoutConstraint!
    @IBOutlet private weak var centerHeightConstraint : NSLayoutConstraint!
    @IBOutlet private weak var headerLabel : UILabel!
    var popUpBitRates = [[String : Any]]()
    var selectedBitRate : ((Int, String) -> Void)!
    fileprivate var defaultSelectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        centerVerticallyConstraint.constant = UIScreen.main.bounds.size.height
        centerHeightConstraint.constant = CGFloat((popUpBitRates.count * 48) + 120) > UIScreen.main.bounds.size.height - 80.0 ? UIScreen.main.bounds.size.height - 80.0 : CGFloat((popUpBitRates.count * 48) + 120)
        bitRateTableView.register(DownloadBitRateCell.nib(), forCellReuseIdentifier: "DownloadBitRateCell")
        okButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        okButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 16.0)
        cancelButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 16.0)
        headerLabel.text = "Download"
        headerLabel.font = UIFont.ottRegularFont(withSize: 20.0)
        headerLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerVerticallyConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction private func okCancelButtonAction(_ sender : UIButton) {
        if sender.tag == 10 {
            if let bit_rate = popUpBitRates[defaultSelectedIndex]["bit_rate"] as? Int, let streamUrl = popUpBitRates[defaultSelectedIndex]["download_url"] as? String {
                selectedBitRate(bit_rate, streamUrl)
            }
        }
        centerVerticallyConstraint.constant = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
extension BitRateDownloadVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpBitRates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadBitRateCell") as? DownloadBitRateCell else {return UITableViewCell()}
        if let bit_rate = popUpBitRates[indexPath.row]["bit_rate"] as? Int, indexPath.row != 0 {
            cell.frameAndBitRateLabel.text = "\(bit_rate/1024)P"
        }else {
            cell.frameAndBitRateLabel.text = "Auto"
        }
        if indexPath.row == defaultSelectedIndex {
            cell.circleImageView.image = #imageLiteral(resourceName: "bitrate_select").withRenderingMode(.alwaysTemplate)
            cell.circleImageView.tintColor = AppTheme.instance.currentTheme.themeColor
            cell.frameAndBitRateLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        }else {
            cell.circleImageView.image = #imageLiteral(resourceName: "bitrate_unselect").withRenderingMode(.alwaysTemplate)
            cell.circleImageView.tintColor = AppTheme.instance.currentTheme.cardSubtitleColor
            cell.frameAndBitRateLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == defaultSelectedIndex {return}
        defaultSelectedIndex = indexPath.row
        tableView.reloadData()
    }
    private func convertBitrateToHumanReadable(bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: bytes)
    }
}
