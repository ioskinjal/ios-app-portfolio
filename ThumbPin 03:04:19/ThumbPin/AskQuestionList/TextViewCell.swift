//
//  TextViewCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var txtView: UITextView!{
        didSet{
             DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.txtView.delegate = self
            }
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
     var formId:String = ""
    var elementList = [FormsData]()
     var parentVC = ServiceTitleVC()
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
extension TextViewCell:UITextViewDelegate{

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if txtView.text == ""{
            elementList[indexpath.row].isChecked = false
            ansQuestionList.arrAns.remove(at:txtView.tag)
        }else{
            elementList[indexpath.row].isChecked = true
           
            let strKey = "template[\(formId)][\(elementList[indexpath.row].form_element_id)]"
            ansQuestionList.arrAns.append(AnsListarr(form_element_type: askQuestionList.arrFormData[indexpath.row].form_element_type, form_element_id: askQuestionList.arrFormData[indexpath.row].form_element_id, element_value: txtView.text!, strKeyData: strKey, strKeyAnsData: txtView.text!, isTemplateValue: "y"))
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.resetPlaceHolder()
        return true
    }
    
}
