//
//  TextFieldCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtContent: CustomTextField!{
        didSet{
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.txtContent.delegate = self
            }
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
     var parentVC = ServiceTitleVC()
    var formId:String = ""
    var elementList = [FormsData]()
    var indexpath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension TextFieldCell:UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if txtContent.text == ""{
            elementList[indexpath.row].isChecked = false
            if ansQuestionList.arrAns.count != 0{
                ansQuestionList.arrAns.removeAll()
                ansQuestionList.arrKeyAnsData.removeAll()
                ansQuestionList.arrKeyData.removeAll()
            }
        }else{
            if ansQuestionList.arrAns.count != 0{
                ansQuestionList.arrAns.removeAll()
                ansQuestionList.arrKeyAnsData.removeAll()
                ansQuestionList.arrKeyData.removeAll()
            }
            elementList[indexpath.row].isChecked = true
            let strKey = "template[\(formId)][\(elementList[indexpath.row].form_element_id)]"
            ansQuestionList.arrKeyData.append(strKey)
            ansQuestionList.arrKeyAnsData.append(txtContent.text!)
            ansQuestionList.arrAns.append(AnsListarr(form_element_type: elementList[indexpath.row].form_element_type, form_element_id: elementList[indexpath.row].form_element_id, element_value: txtContent.text!, strKeyData: strKey, strKeyAnsData: txtContent.text!, isTemplateValue: "y"))
        }
        return true
    }
}
