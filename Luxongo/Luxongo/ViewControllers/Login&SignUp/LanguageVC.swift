//
//  LanguageVC.swift
//  Luxongo
//
//  Created by admin on 7/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LanguageVC: BaseViewController {

    var listOfLanguages:[Language] = []
    
    //MARK: Properties
    static var storyboardInstance:LanguageVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: LanguageVC.identifier) as! LanguageVC
    }
    
    @IBOutlet weak var lblPrefLang: LabelBold!
    
    @IBOutlet weak var lblLanguage: LabelSemiBold!
    @IBOutlet weak var tfSelectLang: TextField!{
        didSet{
            tfSelectLang.isPreventCaret = true
            //tfSelectLang.inputView = langaugePicker
            tfSelectLang.delegate = self
            tfSelectLang.addDropDownArrow()
        }
    }
    
    @IBOutlet weak var btnContinue: BlackBgButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callLanguage()
        btnContinue.setEnable(state: false)
    }
    
    //MARK: IBActions
    @IBAction func onClickContinue(_ sender: UIButton) {
        redirectToLogin()
    }
    
}

//MARK: API Methods
extension LanguageVC{
    func callLanguage() {
        API.shared.call(with: .getLanguages, viewController: self, param: [:], failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.listOfLanguages = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({Language(dictionary: $0 as! [String : Any])})
        }
    }
}

//MARK: custom functions
extension LanguageVC{
    
    func redirectToLogin() {
        if !UserData.shared.languageID.isEmpty{
            popToRootViewController(animated: true)
        }else{
            UIApplication.alert(title: "Error", message: "Please select the language", style: .destructive)
        }
    }
    
    func openPickerView() {
        let nextVC = PickerVC.storyboardInstance
        nextVC.setUp(delegate: self, textField: tfSelectLang)
        PickerVC.UIDisplayData.title = "Select language".localized
        //TODO: Selected Language
        //nextVC.selectedLanguage = PickerData(id: "", title: self.listOfLanguages[0].language_name, value: "")
        nextVC.listOfDataSource = self.listOfLanguages.map({ PickerData(id: String($0.id), title: $0.language_name, value: $0.lang_code) })
        present(asPopUpView: nextVC)
    }
}

//MARK: PickerView delegate
extension LanguageVC: pickerViewData{
    func fatchData(element: PickerData, textField: UITextField) {
        tfSelectLang.text = element.title
        UserData.shared.setLanguageID(languageID: element.value)
        btnContinue.setEnable(state: true)
    }
}

extension LanguageVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfSelectLang{
            openPickerView()
            return false
        }else { return true }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfSelectLang{
            return false
        }
        else {
            return true
        }
    }
}
