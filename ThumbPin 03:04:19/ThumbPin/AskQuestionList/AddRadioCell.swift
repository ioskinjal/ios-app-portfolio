//
//  AddRadioCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class AddRadioCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var tblHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblRadio: UITableView!{
        didSet{
            tblRadio.delegate = self
            tblRadio.dataSource = self
            tblRadio.register(QuestionListCell.nib, forCellReuseIdentifier: QuestionListCell.identifier)
            tblRadio.separatorStyle = .none
        }
    }
    var formID = ""
    var elementList = [FormsData]()
    var parentVC = ServiceTitleVC()
    var section:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AddRadioCell:UITableViewDelegate,UITableViewDataSource{
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
            cell.imgvwCheckmark.image = #imageLiteral(resourceName: "radio-black")
        }else{
            cell.imgvwCheckmark.image = #imageLiteral(resourceName: "radioblank-black")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<elementList[self.section ?? 0].arrElementList.count{
            elementList[self.section ?? 0].arrElementList[i].isChecked = false
        }
        for i in 0..<ansQuestionList.arrAns.count{
            if ansQuestionList.arrAns[i].form_element_id == elementList[indexPath.section].form_element_id{
                ansQuestionList.arrAns.remove(at: i)
            }
        }
        tblRadio.reloadData()
        elementList[self.section ?? 0].arrElementList[indexPath.row].isChecked = true
        ansQuestionList.arrAns.append(AnsListarr(form_element_type: elementList[self.section ?? 0].form_element_type, form_element_id: elementList[self.section ?? 0].form_element_id, element_value: elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, strKeyData: "template[\(formID)][\(elementList[self.section ?? 0].form_element_id)]", strKeyAnsData: elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, isTemplateValue: "y"))
        //tblRadio.reloadData()
       
        if elementList[self.section ?? 0].has_child == "y" {
            
            parentVC.callApiGetDependentQuestion(elementList[self.section ?? 0].arrElementList[indexPath.row].element_value, index:self.section ?? 0 )
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tblHeightConst.constant = tblRadio.contentSize.height
        
    }
    
}
