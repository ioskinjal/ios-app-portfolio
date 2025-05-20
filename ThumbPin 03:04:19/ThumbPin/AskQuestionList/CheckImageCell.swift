//
//  CheckImageCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class CheckImageCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionViewImage: UICollectionView!{
        didSet{
            collectionViewImage.delegate = self
            collectionViewImage.dataSource = self
            collectionViewImage.register(ImageCheckBoxCell.nib, forCellWithReuseIdentifier: ImageCheckBoxCell.identifier)
            
        }
    }
    var section:Int?
     var parentVC = ServiceTitleVC()
    @IBOutlet weak var lblTitle: UILabel!
    var formID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var arrElementList = [FormsData]()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CheckImageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrElementList[self.section ?? 0].arrElementList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCheckBoxCell.identifier, for: indexPath) as? ImageCheckBoxCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelName.text = arrElementList[self.section ?? 0].arrElementList[indexPath.row].element_label
        if let strUrl = arrElementList[self.section ?? 0].arrElementList[indexPath.row].element_img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            cell.imgvwName.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            cell.imgvwName.sd_setShowActivityIndicatorView(true)
            cell.imgvwName.sd_setIndicatorStyle(.gray)
        }
        if arrElementList[self.section ?? 0].arrElementList[indexPath.row].isChecked == true{
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checked-new"), for: .normal)
        }else{
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
        } 
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //arrElementList[indexPath.row].isChecked.toggle()
        
        if arrElementList[self.section ?? 0].arrElementList[indexPath.row].isChecked == true{
            arrElementList[self.section ?? 0].arrElementList[indexPath.row].isChecked = false
            ansQuestionList.arrAns.remove(at: indexPath.section)
//            ansQuestionList.arrAns.append(AnsListarr(form_element_type: arrElementList[indexPath.section].form_element_type, form_element_id: arrElementList[indexPath.section].form_element_id, element_value: arrElementList[indexPath.section].arrElementList[indexPath.row].element_value, strKeyData: "template[\(formID)][\(arrElementList[indexPath.section].form_element_id)][\(indexPath.row)]", strKeyAnsData: arrElementList[indexPath.section].arrElementList[indexPath.row].element_value, isTemplateValue: "n"))
        }else{
            arrElementList[self.section ?? 0].arrElementList[indexPath.row].isChecked = true
            ansQuestionList.arrAns.append(AnsListarr(form_element_type: arrElementList[self.section ?? 0].form_element_type, form_element_id: arrElementList[self.section ?? 0].form_element_id, element_value: arrElementList[self.section ?? 0].arrElementList[indexPath.row].element_value, strKeyData: "template[\(formID)][\(arrElementList[self.section ?? 0].form_element_id)]", strKeyAnsData: arrElementList[self.section ?? 0].arrElementList[indexPath.row].element_value, isTemplateValue: "y"))
        }
        collectionView.reloadData()
        
        if arrElementList[self.section ?? 0].has_child == "y" {
            parentVC.callApiGetDependentQuestion(arrElementList[self.section ?? 0].arrElementList[indexPath.row].element_value, index: self.section ?? 0)
            
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}
