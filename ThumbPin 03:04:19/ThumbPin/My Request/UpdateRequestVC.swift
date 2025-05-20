//
//  UpdateRequestVC.swift
//  ThumbPin
//
//  Created by NCT109 on 21/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class UpdateRequestVC: BaseViewController {

    @IBOutlet weak var tblvwProvider: UITableView!{
        didSet{
            tblvwProvider.delegate = self
            tblvwProvider.dataSource = self
            tblvwProvider.register(ProviderCell.nib, forCellReuseIdentifier: ProviderCell.identifier)
            tblvwProvider.rowHeight  = UITableViewAutomaticDimension
            tblvwProvider.estimatedRowHeight = 44
            tblvwProvider.separatorStyle = .none
        }
    }
    @IBOutlet weak var contblvwProviderHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelProjectName: UILabel!
    @IBOutlet weak var labelOR: UILabel!{
        didSet {
           // labelOR.layoutIfNeeded()
            //labelOR.createCorenerRadius()
            labelOR.layer.borderWidth = 2
            labelOR.layer.borderColor = Color.Custom.mainColor.cgColor
        }
    }
    @IBOutlet weak var tblvwQUESTION: UITableView!{
        didSet{
            tblvwQUESTION.delegate = self
            tblvwQUESTION.dataSource = self
            tblvwQUESTION.register(QuestionListCell.nib, forCellReuseIdentifier: QuestionListCell.identifier)
            tblvwQUESTION.rowHeight  = UITableViewAutomaticDimension
            tblvwQUESTION.estimatedRowHeight = 44
            tblvwQUESTION.separatorStyle = .none
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var conTblvwHeight: NSLayoutConstraint!
    
    
    static var storyboardInstance:UpdateRequestVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: UpdateRequestVC.identifier) as? UpdateRequestVC
    }
    var serviceId = ""
    var serviceName = ""
    var questionList = UpdateQuestionList()
    var arrSelected = [String]()
    var arrSelectedProvider = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        callApiGetQuestionList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        setUpLang()
        NotificationCenter.default.removeObserver(self)
    }
    func callApiGetQuestionList() {
        let dictParam = [
            "action": Action.getLists,
            "lId": UserData.shared.getLanguage,
            "service_id": serviceId,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.getUpdateService(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.questionList = UpdateQuestionList(dic: dict["data"] as? [String : Any] ?? [String : Any]())
            for _ in self.questionList.arrQuestions {
                self.arrSelected.append("0")
            }
            self.tblvwQUESTION.reloadData()
//            self.conTblvwHeight.constant = self.tblvwQUESTION.contentSize.height
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.conTblvwHeight.constant = self.tblvwQUESTION.contentSize.height
//            }
            for _ in self.questionList.arrProvider {
                self.arrSelectedProvider.append("0")
            }
            self.tblvwProvider.reloadData()
            self.contblvwProviderHeight.constant = self.tblvwProvider.contentSize.height
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.contblvwProviderHeight.constant = self.tblvwProvider.contentSize.height
            }
        }
    }
    func callApiUpdateService(_ question: String,_ type: String) {
        let dictParam = [
            "action": Action.updateService,
            "lId": UserData.shared.getLanguage,
            "service_id": serviceId,
            "user_id": UserData.shared.getUser()!.user_id,
            "question": question,
            "type": type,
        ] as [String : Any]
        ApiCaller.shared.getUpdateService(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setUpLang() {
        labelTitle.text = localizedString(key: "Update Project Request")
        labelOR.text = localizedString(key: "OR")
        labelOR.layoutIfNeeded()
        labelOR.createCorenerRadius()
        btnSubmit.setTitle(localizedString(key: "Submit"), for: .normal)
        let strTemp = localizedString(key: "Have you hired a professional on Thumbpin for your %@ project?")
        labelProjectName.text = NSString(format: "\(strTemp)" as NSString, serviceName) as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitActoin(_ sender: Any) {
        var isSelected = "n"
        var isProviderSelect = ""
        for i in 0..<arrSelectedProvider.count {
            if arrSelectedProvider[i] == "1" {
                isSelected = "y"
                isProviderSelect = "y"
            }
        }
        for i in 0..<arrSelected.count {
            if arrSelected[i] == "1" {
                isSelected = "y"
                isProviderSelect = "n"
                break
            }
        }
        if isSelected == "n" {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.questionSelect)
            return
        }
        if isProviderSelect == "y" {
            for i in 0..<arrSelectedProvider.count {
                if arrSelectedProvider[i] == "1" {
                    callApiUpdateService(questionList.arrProvider[i].quoteId, "user")
                }
            }
        }else {
            for i in 0..<arrSelected.count {
                if arrSelected[i] == "1" {
                    callApiUpdateService(questionList.arrQuestions[i].id, "other")
                }
            }
        }
        
    }
}
extension UpdateRequestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblvwQUESTION {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionListCell.identifier) as? QuestionListCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelQuestion.text = questionList.arrQuestions[indexPath.row].question
            cell.imgvwCheckmark.image = #imageLiteral(resourceName: "radioblank-orange")
            if arrSelected[indexPath.row] == "1" {
                cell.imgvwCheckmark.image = #imageLiteral(resourceName: "radio-orange")
            }
            cell.selectionStyle = .none
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProviderCell.identifier) as? ProviderCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.labelname.text = questionList.arrProvider[indexPath.row].userName
            cell.imgvwCheckMark.image = #imageLiteral(resourceName: "radioblank-orange")
            if arrSelectedProvider[indexPath.row] == "1" {
                cell.imgvwCheckMark.image = #imageLiteral(resourceName: "radio-orange")
            }
            if let strUrl = questionList.arrProvider[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                cell.imgvwProfile.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
                cell.imgvwProfile.sd_setShowActivityIndicatorView(true)
                cell.imgvwProfile.sd_setIndicatorStyle(.gray)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblvwQUESTION {
            return questionList.arrQuestions.count
        }else {
            return questionList.arrProvider.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblvwQUESTION {
            for i in 0..<arrSelected.count {
                if i == indexPath.row {
                    if arrSelected[i] == "1" {
                        arrSelected[i] = "0"
                    }else {
                        arrSelected[i] = "1"
                    }
                }else {
                    arrSelected[i] = "0"
                }
            }
            for i in 0..<arrSelectedProvider.count {
                arrSelectedProvider[i] = "0"
            }
            tblvwQUESTION.reloadData()
            tblvwProvider.reloadData()
        }else {
            for i in 0..<arrSelectedProvider.count {
                if i == indexPath.row {
                    if arrSelectedProvider[i] == "1" {
                        arrSelectedProvider[i] = "0"
                    }else {
                        arrSelectedProvider[i] = "1"
                    }
                }else {
                    arrSelectedProvider[i] = "0"
                }
            }
            for i in 0..<arrSelected.count {
                arrSelected[i] = "0"
            }
            tblvwProvider.reloadData()
            tblvwQUESTION.reloadData()
        }
    }
}
