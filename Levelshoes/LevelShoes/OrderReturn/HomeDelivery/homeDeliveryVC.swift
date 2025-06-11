//
//  homeDeliveryVC.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 09/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class homeDeliveryVC: UIViewController {
    @IBOutlet var selectAddress: [UIButton]!
    @IBOutlet weak var header: headerView!
    @IBOutlet weak var toggle: Toggle!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var lblHome: UILabel!
     @IBOutlet weak var lblAddAddress: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblDefault: UILabel!

    let dataArray = ["Company Name*" , "Title*" , "First Name*" , "Last Name*" , "Phone Number*" ,
    "Select Country*" , "City*" , "Address line 1*" , "Address line 2*" , "Shipping notes"]
    @IBOutlet weak var btnSaveAddress: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                btnSaveAddress.addTextSpacingButton(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblSaveAddress: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblSaveAddress.addTextSpacing(spacing: 1.5)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        toggle.delegate = self
//        lblAddressTitle.text =  "Address name"//""
//        lblAddAddress.text =  "Address information"//""
        loadHeaderAction()
    }
    private func loadHeaderAction(){
        header.backButton.addTarget(self, action: #selector(backSelector), for: .touchUpInside)
        header.buttonClose.isHidden = true
    }
    @objc func backSelector(sender : UIButton) {
        //Write button action here
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectAddress(_ sender: UIButton) {

        for item in selectAddress {

            if sender.tag == item.tag {

                UIView.animate(withDuration: 0.3) {
                    sender.backgroundColor = .black
                    sender.setTitleColor(.white, for: .normal)

                }

            }
            else{
                UIView.animate(withDuration: 0.3) {
                    item.backgroundColor = .white
                    item.setTitleColor(.black, for: .normal)

                }

            }
        }
    }
    @IBAction func saveAddressSelector(_ sender: UIButton) {
        print("Save Address")
        let storyboard = UIStoryboard(name: "detailStatus", bundle: Bundle.main)
        let faqServiceVC: detailStatusVC! = storyboard.instantiateViewController(withIdentifier: "detailStatusVC") as? detailStatusVC
        self.navigationController?.pushViewController(faqServiceVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateNotificationLabelColor() {
        UIView.transition(with: lblDefault, duration: 0.30, options: .transitionCrossDissolve,
                                  animations: {() -> Void in
                                    self.lblDefault.textColor = self.toggle.isOn == true ? .black : UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
                                    },
                                  completion: {(finished: Bool) -> Void in
                        })
    }

}
extension homeDeliveryVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "miscCell", for: indexPath) as! miscCell
        if indexPath.row == 0 { //Company Name
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 1 { //Title
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = false
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 2 { //First Name
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
       else if indexPath.row == 3 { //Last Name
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            //cell.txtField.text = dataArray[indexPath.row].localized
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
       else if indexPath.row == 4 { //Phone Name
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 5 { //select Country
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
           
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = 25
            cell.imgDropDown.isHidden = false
            cell.viewLine.backgroundColor = colorNames.c7C7
            cell.txtField.textColor = colorNames.c7C7
            cell.txtField?.floatPlaceholderColor = colorNames.c7C7
            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 6 { //City
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            //cell.txtField.text = dataArray[indexPath.row].localized
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = false
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor
            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 7 { //Address line 1
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            //cell.txtField.text = dataArray[indexPath.row].localized
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 8 { //Address line 2
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            //cell.txtField.text = dataArray[indexPath.row].localized
            cell.lblError.isHidden = true
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else if indexPath.row == 9 { //Shippine Notes
            cell.txtField.placeHolder(text: dataArray[indexPath.row].localized, textfieldname: cell.txtField)
            //cell.txtField.text = dataArray[indexPath.row].localized
            cell.lblError.isHidden = false
            cell.lblError.textAlignment = .right
            cell.lblError.text = "0 / 1000"
            cell.flagWidthConstant.constant = -10
            cell.imgDropDown.isHidden = true
            cell.viewLine.backgroundColor = colorNames.placeHolderColor
            cell.txtField.textColor = colorNames.placeHolderColor
            cell.txtField?.floatPlaceholderColor = colorNames.placeHolderColor

            self.view.layoutIfNeeded()
        }
        else{
            print("Jay Radhey")
        }
        
         return cell
     
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
extension homeDeliveryVC: ToggleDelegate {
    func toggleChanged(_ toggle: Toggle) {
        updateNotificationLabelColor()
    }
}
