//
//  PickerVC.swift
//  Luxongo
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol pickerViewData {
    func fatchData(element:PickerData, textField: UITextField)
}

class PickerData {
    var id : String
    var title : String
    var value : String
    
    init(id: String, title:String, value:String) {
        self.id = id
        self.title = title
        self.value = value
    }
}

class PickerVC: BaseViewController {
    
    struct UIDisplayData {
        static var cancel = "Cancel"
        static var done = "Done"
        static var title = ""
    }
    
    deinit {
        print("deinit")
    }
    
    //MARK: Properties
    static var storyboardInstance:PickerVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: PickerVC.identifier) as! PickerVC
    }
    
    //MARK: Outlets
    @IBOutlet weak var lblTittle: LabelSemiBold!
    @IBOutlet weak var btnCancel: BlackButton!
    @IBOutlet weak var btnDone: BlackButton!
    @IBOutlet weak var pickerView: UIPickerView!{
        didSet{
            self.pickerView.delegate = self
        }
    }
    
    private var textField: UITextField?
    private var delegate:pickerViewData?
    var selectedLanguage:PickerData?
    var listOfDataSource:[PickerData] = []
    
    func setUp(delegate: pickerViewData, textField: UITextField) {
        self.delegate = delegate; self.textField = textField
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lblTittle.text = UIDisplayData.title
        btnDone.setTitle(UIDisplayData.done, for: .normal)
        btnCancel.setTitle(UIDisplayData.cancel, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedLanguage = self.selectedLanguage, !selectedLanguage.title.isBlank, self.listOfDataSource.count > 0{
            if let index = self.listOfDataSource.firstIndex(where: { $0.title.lowercased() == selectedLanguage.title.lowercased()}){
                pickerView.selectRow(index, inComponent: 0, animated: true)
                self.selectedLanguage = self.listOfDataSource[index]
            }
        }
        self.btnDone.isEnabled = listOfDataSource.count > 0
        self.btnDone.alpha = (listOfDataSource.count > 0 ? 1.0 : 0.5)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        if let delegate = self.delegate, let textField = self.textField{
            if let selectedLanguage = self.selectedLanguage, !selectedLanguage.title.isBlank{
                delegate.fatchData(element: selectedLanguage, textField: textField)
            }else if let first = listOfDataSource.first{
                delegate.fatchData(element: first, textField: textField)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension PickerVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if listOfDataSource.count > 0{
            selectedLanguage = listOfDataSource[row]            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.font = Font.SourceSerifProRegular.size(20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = listOfDataSource[row].title
        
        return label
    }
}
