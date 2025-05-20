//
//  SelectServiceListVC.swift
//  ThumbPin
//
//  Created by NCT109 on 19/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

protocol ServiceDelegate {
    func dismissServicePopupView(_ name: String,_ serviceid: String, _ servicename: String)
}

import UIKit

class SelectServiceListVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewContainer: UIView!{
        didSet {
            viewContainer.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblvwData: UITableView!{
        didSet {
            tblvwData.dataSource = self
            tblvwData.delegate = self
            tblvwData.separatorStyle = .none
        }
    }
    @IBOutlet weak var conTopViewSearch: NSLayoutConstraint!
    @IBOutlet weak var conTblvwHeight: NSLayoutConstraint!
    
    static var storyboardInstance:SelectServiceListVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SelectServiceListVC.identifier) as? SelectServiceListVC
    }
    var delegate:ServiceDelegate?
    var arrServiceList = [ServiceList]()
    var arrSearch = [ServiceList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(searchServicesText(_ :)), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        self.view.frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
            //self.viewContainerRoom.layoutIfNeeded()
            self.view.frame.origin.y = 0
        }, completion: {(_ finished: Bool) -> Void in
            /*done*/
            self.txtSearch.becomeFirstResponder()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillLayoutSubviews() {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == viewBackGround {
            delegate?.dismissServicePopupView("", "", "")
        }
    }
    @objc func searchServicesText(_ textfield : UITextField) {
        print(textfield.text!)
        self.arrSearch.removeAll()
        if textfield.text?.count != 0 {
            for dicData in arrServiceList {
                let isMachingWorker : NSString = (dicData.service_name) as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    arrSearch.append(dicData)
                }
            }
        } else {
            self.arrSearch.removeAll()
        }
        tblvwData.reloadData()
        conTblvwHeight.constant = tblvwData.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button action
    @IBAction func btnbackAction(_ sender: UIButton) {
        delegate?.dismissServicePopupView("", "", "")
    }
}
extension SelectServiceListVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = arrSearch[indexPath.row].service_name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dismissServicePopupView(arrSearch[indexPath.row].service_name, arrSearch[indexPath.row].service_id, arrSearch[indexPath.row].service_name)
    }
}
