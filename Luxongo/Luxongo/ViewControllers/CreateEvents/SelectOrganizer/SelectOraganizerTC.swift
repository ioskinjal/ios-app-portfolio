//
//  SelectOraganizerTC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectOraganizerTC: UITableViewCell {

    var cellData: MyOrgenizersCls.List?{
        didSet{
            loadCellUI()
        }
    }
    var indexPath:IndexPath?
    var orgenizerData:MyOrgenizersCls.List?{
        didSet{
            showOrgenizerData()
        }
    }
    @IBOutlet weak var lblDesc: LabelRegular!
    
    
    @IBOutlet weak var btnCheckBox: UIButton!{
        didSet{
            self.btnCheckBox.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        }
    }
    
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.contentMode = .scaleToFill
            self.imgUser.setRadius(radius: nil)
            
        }
    }
    @IBOutlet weak var lblUserName: LabelSemiBold!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        //sender.isSelected = cellData.isSelected  //toggle()
        if let cellData = self.cellData,
            let indexPath = self.indexPath,
            let parent = self.viewController as? SelectOrganizerVC{
            cellData.isSelected.toggle()
            parent.tableView.reloadRows(at: [indexPath], with: .automatic)
        }else if self.btnCheckBox.currentImage == #imageLiteral(resourceName: "redDustbin"){
            deleteOrgenizer()
        }
    }
    
    func loadCellUI() {
        if let cellData = self.cellData{
            lblUserName.text = cellData.name
            imgUser.downLoadImage(url: cellData.image)
            btnCheckBox.isSelected = cellData.isSelected
            self.lblDesc.text = cellData.organizer_desc
        }
    }
}

extension SelectOraganizerTC{
    func showOrgenizerData(){
        lblUserName.text = orgenizerData?.name
        imgUser.downLoadImage(url: orgenizerData!.image)
    }
    
    func deleteOrgenizer(){
        if let parentVC = self.viewController as? MyOrgenizersVC{
            UIApplication.alert(title: "Remove Organizers", message: "Are You sure you want to remove this orgenizer ?", actions: ["Yes","No"]) { (flag) in
                if flag == 0{ //Yes
                    self.callDelete(parentVC: parentVC)
                }else{ //No
                    //Nothing
                }
            }
        }
    }
}


//MARK: API methods
extension SelectOraganizerTC{
    
    func callDelete(parentVC: MyOrgenizersVC){
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "id":self.orgenizerData!.id] as [String : Any]
        API.shared.call(with: .deleteOrgenizer, viewController: parentVC, param: param) { (response) in
            let str = Response.fatchDataAsString(res: response, valueOf: .message)
            let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            parentVC.present(alert, animated: true, completion: {
                parentVC.orgenizerObj = nil
                parentVC.orgenizerList = [MyOrgenizersCls.List]()
                parentVC.getMyOrgenizer()
            })
        }
    }
    
    
}
