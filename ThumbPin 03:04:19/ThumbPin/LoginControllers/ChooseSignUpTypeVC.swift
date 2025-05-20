//
//  ChooseSignUpType.swift
//  ThumbPin
//
//  Created by NCT109 on 17/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ChooseSignUpTypeVC: BaseViewController {
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var labelIntroducedProjects: UILabel!
    @IBOutlet weak var labelHireProfessional: UILabel!
    @IBOutlet weak var labelRespondCustomer: UILabel!
    @IBOutlet weak var labelGrowMyBusiness: UILabel!
    @IBOutlet weak var labelChooseUserType: UILabel!
    @IBOutlet weak var btnGrowMyBussiness: UIButton!
    @IBOutlet weak var btnHireProfessionals: UIButton!
    @IBOutlet weak var imgvwBusiness: UIImageView!
    @IBOutlet weak var imgvwProfessional: UIImageView!
    
    static var storyboardInstance:ChooseSignUpTypeVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: ChooseSignUpTypeVC.identifier) as? ChooseSignUpTypeVC
    }
    var selectedUserType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSetUpStatusBar = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
    }
    
    func setUpLang() {
        labelChooseUserType.text = localizedString(key: "Choose User Type")
        labelGrowMyBusiness.text = localizedString(key: "Grow my business")
        labelRespondCustomer.text = localizedString(key: "Respond to customer request and get hired")
        labelHireProfessional.text = localizedString(key: "Hire Professional")
        labelIntroducedProjects.text = localizedString(key: "Get introduced to the right pros for your projects")
        btnContinue.setTitle("  \(localizedString(key: "Continue"))  ", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnGrowMyBussinessAction(_ sender: UIButton) {
       // btnGrowMyBussiness.isSelected = true
       // btnHireProfessionals.isSelected = false
        imgvwBusiness.image = #imageLiteral(resourceName: "Checked")
        imgvwProfessional.image = #imageLiteral(resourceName: "Unchecked")
        selectedUserType = "provide"
    }
    @IBAction func btnHireProfessionalsAction(_ sender: UIButton) {
       // btnGrowMyBussiness.isSelected = false
       // btnHireProfessionals.isSelected = true
        imgvwProfessional.image = #imageLiteral(resourceName: "Checked")
        imgvwBusiness.image = #imageLiteral(resourceName: "Unchecked")
        selectedUserType = "customer"
    }
    @IBAction func btnContinoueAction(_ sender: UIButton) {
        if selectedUserType.isEmpty {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.userType)
            return
        }
        if isSocialLogin!{
            callUpdateUserType()
        }else{
        let vc = SignUpVC.storyboardInstance!
        vc.userType = selectedUserType
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func callUpdateUserType(){
        var dictParam:[String:Any] = ["action":"set_user_type",
        "user_id":UserData.shared.getUser()!.user_id,
        "lId":UserData.shared.getLanguage]
        if selectedUserType == "provide"{
            dictParam["user_type"] = "2"
        }else{
            dictParam["user_type"] = "1"
        }
        
        ApiCaller.shared.signUp(vc: self, param: dictParam) { (dic) in
            print(dic)
        }
    }
    
}
