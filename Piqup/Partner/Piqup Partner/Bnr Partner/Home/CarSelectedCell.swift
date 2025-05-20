//
//  CarSelectedCell.swift
//  BnR Partner
//
//  Created by KASP on 06/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class CarSelectedCell: UITableViewCell {

    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblCarNo: UILabel!
    @IBOutlet weak var lblCarType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displaySelectedData(car:Car){
        
        if car.subTypeImage.isEmpty{
            
        }
        else{
            if let url = URL(string: URLConstants.Domains.CarUrl + "\(car.carTypeId)/" + car.typeImage){
                self.carImgView.af_setImage(withURL: url)
            }
        }
        self.lblCarName.text = "\(car.brandName) \(car.carName)"
        self.lblCarNo.text = car.carNumber
        self.lblCarType.text = "\(car.typeName) - \(car.subTypeName)"
    }
    
}
