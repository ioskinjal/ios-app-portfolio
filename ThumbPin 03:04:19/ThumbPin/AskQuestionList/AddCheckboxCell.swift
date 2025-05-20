//
//  AddCheckboxCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class AddCheckboxCell: UITableViewCell {
    
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tblCheck: UITableView!{
        didSet{
            tblCheck.delegate = self
            tblCheck.dataSource = self
            tblCheck.register(QuestionListCell.nib, forCellReuseIdentifier: QuestionListCell.identifier)
            tblCheck.separatorStyle = .none
        }
    }
    var section:Int?
     var parentVC = ServiceTitleVC()
    var formId = ""
    var elementList = [FormsData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension AddCheckboxCell:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementList[self.section ?? 0].arrElementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionListCell.identifier) as? QuestionListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.labelQuestion.text = elementList[self.section ?? 0].arrElementList[indexPath.row].element_label
        if elementList[self.section ?? 0].arrElementList[indexPath.row].isChecked == true{
            cell.imgvwCheckmark.image = #imageLiteral(resourceName: "Checked-new")
        }else{
            cell.imgvwCheckmark.image = #imageLiteral(resourceName: "Unchecked")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if elementList[self.section ?? 0].arrElementList[indexPath.row].isChecked == true{
            elementList[self.section ?? 0].arrElementList[indexPath.row].isChecked = false
             ansQuestionList.arrAns.remove(at: indexPath.section)
        }else{
            elementList[self.section ?? 0].arrElementList[indexPath.row].isChecked = true
            ansQuestionList.arrAns.append(AnsListarr(form_element_type: elementList[self.section ?? 0].form_element_type, form_element_id: elementList[self.section ?? 0].form_element_id, element_value: elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, strKeyData: "template[\(formId)][\(elementList[self.section ?? 0].form_element_id)]", strKeyAnsData: elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, isTemplateValue: "y"))
        }
    tblCheck.reloadData()
        
        if elementList[self.section ?? 0].has_child == "y" {
            parentVC.callApiGetDependentQuestion(elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, index: self.section ?? 0)
            
        }
}
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    tblHeightConst.constant = tblCheck.contentSize.height
    
}

}
