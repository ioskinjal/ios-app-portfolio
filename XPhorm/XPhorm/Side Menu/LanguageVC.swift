//
//  LanguageVC.swift
//  XPhorm
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LanguageVC: BaseViewController {
    
    static var storyboardInstance:LanguageVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: LanguageVC.identifier) as? LanguageVC
    }
    
     let languagePicker = UIPickerView()
    @IBOutlet weak var txtLanguage: UITextField!{
        didSet{
            languagePicker.delegate = self
            languagePicker.dataSource = self
            txtLanguage.inputView = languagePicker
            txtLanguage.rightView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), image: #imageLiteral(resourceName: "downArrrow"))
            
        }
    }
    
    var languageList = [LanguageList]()
    var selectedLanguage:LanguageList?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Language".localized, action: #selector(onClickBack(_:)))
        getLanguage()
    }
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLanguage(){
        let param = ["action":"getAllLang",
                     "lId":UserData.shared.getLanguage]
        
        Modal.shared.getLanguage(vc: self, param: param) { (dic) in
            self.languageList = ResponseKey.fatchDataAsArray(res: dic, valueOf: .data).map({LanguageList(dic: $0 as! [String:Any])})
            self.languagePicker.reloadAllComponents()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LanguageVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
        name = languageList[row].languageName
        let str = name
        label.text = str
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     selectedLanguage = languageList[row]
        txtLanguage.text = selectedLanguage?.languageName
        UserData.shared.setLanguage(language: selectedLanguage?.id ?? "")
    }
}
