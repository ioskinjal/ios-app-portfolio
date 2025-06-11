//
//  ChangeLanguageVC.swift
//  Luxongo
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ChangeLanguageVC: BaseViewController {

    var listOfLanguages:[Language] = []
    var selectedLanguage:String?
    
    //MARK: Properties
    static var storyboardInstance:ChangeLanguageVC {
        return (StoryBoard.accountSetting.instantiateViewController(withIdentifier: ChangeLanguageVC.identifier) as! ChangeLanguageVC)
    }
    
    //MARK: Outlets
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblLanguage: LabelSemiBold!
    @IBOutlet weak var tfSelectLang: TextField!{
        didSet{
            tfSelectLang.isPreventCaret = true
            tfSelectLang.delegate = self
            tfSelectLang.addDropDownArrow()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callLanguage()
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
}

//MARK: API Methods
extension ChangeLanguageVC{
    func callLanguage() {
        API.shared.call(with: .getLanguages, viewController: self, param: [:], failer: { (errStr) in
            print(errStr)
        }) { (response) in
            self.listOfLanguages = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({Language(dictionary: $0 as! [String : Any])})
                if let index = self.listOfLanguages.firstIndex(where: { $0.lang_code == UserData.shared.languageID}){
                    self.selectedLanguage = self.listOfLanguages[index].language_name
                    self.tfSelectLang.text = self.selectedLanguage
                }
        }
    }
}


//MARK: custom functions
extension ChangeLanguageVC{
    func openPickerView() {
        let nextVC = PickerVC.storyboardInstance
        nextVC.setUp(delegate: self, textField: tfSelectLang)
        PickerVC.UIDisplayData.title = "Select language".localized
        //Selected Language
        nextVC.selectedLanguage = PickerData(id: "", title: selectedLanguage ?? "", value: "")
        nextVC.listOfDataSource = self.listOfLanguages.map({ PickerData(id: String($0.id), title: $0.language_name, value: $0.lang_code) })
        present(asPopUpView: nextVC)
    }
}

//MARK: PickerView delegate
extension ChangeLanguageVC: pickerViewData{
    func fatchData(element: PickerData, textField: UITextField) {
        textField.text = element.title
        UserData.shared.setLanguageID(languageID: element.value)
    }
}


extension ChangeLanguageVC:UITextFieldDelegate{
    
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
