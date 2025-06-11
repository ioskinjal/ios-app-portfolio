//
//  HDDeliveryTableView.swift
//  LevelShoes
//
//  Created by Maa on 11/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class HDDeliveryTableView: UITableViewCell {
    @IBOutlet weak var tableViewAddress: UITableView!
    var selectedIndexes = IndexPath(row: 0, section: 0)
    var arrAllAddress = [[String: Any]]()
    var oldRow = 9999
    var selectedCell : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
       initTableView()

    }
     private  func initTableView() {
                let cells = [DeliveryCell.className]
                tableViewAddress.register(cells)
        arrAllAddress = [["Title": "Home", "Address": "Gurugram"],
                         ["Title": "Work", "Address": "New Delhi"],
        ["Title": "Others", "Address": "Greater Noida"]]
        
        
        }
    @objc func btnSelectPressed(_ sender: UIButton){
        print(sender.tag)
        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            sender.isSelected = false
//            sender.setImage(UIImage(named: "radio_on"), for:
//            .normal)
//        }else{
//            sender.isSelected = true
//            sender.setImage(UIImage(named: "radio_off"), for: .normal)
//        }
//        tableViewAddress.reloadData()
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableViewAddress)
           let indexPath = self.tableViewAddress.indexPathForRow(at: buttonPosition)
        print("indexPath",indexPath!.row)
        let selectedIndex = IndexPath(row: sender.tag, section: 0)
        print("selectedIndex",indexPath!.row)
         tableViewAddress.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
//        tableViewAddress.deselectRow(at: selectedIndex, animated: false)

         let selectedCell = tableViewAddress.cellForRow(at: selectedIndex) as! DeliveryCell
        let cell = tableViewAddress.dequeueReusableCell(withIdentifier: "DeliveryCell", for: selectedIndex) as! DeliveryCell

        if selectedIndex.row == sender.tag{
            selectedCell._btnRadioHomeSelection.setImage(UIImage(named: "radio_on"), for:.normal)
//            oldRow = selectedCell._btnEditAddress.tag

        }else{
            selectedCell._btnRadioHomeSelection.setImage(UIImage(named: "radio_off"), for: .normal)

        }

    }
}

extension HDDeliveryTableView: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
       1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrAllAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCell", for: indexPath) as? DeliveryCell else{return UITableViewCell()}
        let arr = arrAllAddress[indexPath.row]
        cell._btnRadioHomeSelection.tag = indexPath.row
        cell._btnEditAddress.tag = indexPath.row
        cell._lblAddressType.text = arr["Title"] as? String
        cell._btnRadioHomeSelection.addTarget(self, action:  #selector(btnSelectPressed(_:)), for: .touchUpInside)

//        cell._lblAddressDetails.text = arr["Address"] as? String
        if indexPath.row == 0 {
            cell._btnRadioHomeSelection.setImage(UIImage(named: "radio_on"), for: .normal)
            oldRow = cell._btnEditAddress.tag
            tableViewAddress.selectRow(at: indexPath, animated: true, scrollPosition: .none)

//            cell._btnRadioHomeSelection.isSelected = true
        }else{
            cell._btnRadioHomeSelection.setImage(UIImage(named: "radio_off"), for: .normal)
//            cell._btnRadioHomeSelection.isSelected = false
        }
        return cell
    }
   

    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedCell = tableViewAddress.cellForRow(at: indexPath as IndexPath) as? DeliveryCell
        selectedCell?._btnRadioHomeSelection.setImage(UIImage(named: "radio_on"), for:
            .normal)
        selectedCell?.backgroundColor = UIColor(hexString: "FFFFFF")
        selectedCell?.contentView.backgroundColor = UIColor(hexString: "FFFFFF")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        let cellToDeSelect = tableViewAddress.cellForRow(at: indexPath as IndexPath) as? DeliveryCell
        cellToDeSelect!._btnRadioHomeSelection.setImage(UIImage(named: "radio_off"), for: .normal)
         cellToDeSelect?.backgroundColor = UIColor(hexString: "FAFAFA")
        cellToDeSelect!.contentView.backgroundColor = UIColor(hexString: "FAFAFA")
    }
*/
}
