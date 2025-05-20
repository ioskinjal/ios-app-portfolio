//
//  InfoVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class InfoVC: BaseViewController {
    
    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var tblvwInfo: UITableView!{
        didSet{
            tblvwInfo.delegate = self
            tblvwInfo.dataSource = self
            tblvwInfo.register(InfoCell.nib, forCellReuseIdentifier: InfoCell.identifier)
            tblvwInfo.rowHeight  = UITableViewAutomaticDimension
            tblvwInfo.estimatedRowHeight = 60
            tblvwInfo.tableFooterView = UIView()
        }
    }
    
    static var storyboardInstance:InfoVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: InfoVC.identifier) as? InfoVC
    }
    var arrCMS = [CmsPages]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApiCMS()
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    func callApiCMS() {
        let dictParam = [
            "action": Action.cms,
        ] as [String : Any]
        ApiCaller.shared.getServiceList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.arrCMS = ResponseKey.fatchData(res: dict, valueOf: .pages).ary.map({CmsPages(dic: $0 as! [String:Any])})
            self.tblvwInfo.reloadData()
        }
    }
    func setUpLang() {
        labelTitleNav.text = localizedString(key: "Info")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier) as? InfoCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrCMS[indexPath.row].pageTitle
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCMS.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InfoWebViewVC.storyboardInstance!
        vc.cmsPages = arrCMS[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
