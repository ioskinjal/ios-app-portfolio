//
//  DropDownCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
     let pickerView = UIPickerView()
    @IBOutlet weak var txtDropDown: UITextField!{
        didSet{
            pickerView.delegate = self
            txtDropDown.inputView = pickerView
        }
    }
    @IBOutlet weak var lblTilte: UILabel!
    
    var section:Int?
     var parentVC = ServiceTitleVC()
    var formId = ""
    var elementList = [FormsData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DropDownCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return elementList[section ?? 0].arrElementList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
        name = elementList[section ?? 0].arrElementList[row].element_label
        let str = name
        label.text = str
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        for i in 0..<elementList[section ?? 0].arrElementList.count{
            elementList[section ?? 0].arrElementList[i].isChecked = false
        }
        for i in 0..<ansQuestionList.arrAns.count{
            if ansQuestionList.arrAns[i].form_element_id == elementList[section ?? 0].form_element_id{
                ansQuestionList.arrAns.remove(at: i)
            }
        }
        txtDropDown.text = elementList[section ?? 0].arrElementList[row].element_label
       elementList[section ?? 0].arrElementList[row].isChecked = true
        ansQuestionList.arrAns.append(AnsListarr(form_element_type: elementList[section ?? 0].form_element_type, form_element_id: elementList[section ?? 0].form_element_id, element_value: elementList[section ?? 0].arrElementList[row].element_value, strKeyData: "template[\(formId)][\(elementList[section ?? 0].form_element_id)][\(row)]", strKeyAnsData: elementList[section ?? 0].arrElementList[row].element_value, isTemplateValue: "y"))
        
        if elementList[section ?? 0].has_child == "y" {
            parentVC.callApiGetDependentQuestion(elementList[section ?? 0].arrElementList[row].element_value, index: self.section ?? 0)
            
        }
    }
    
}
