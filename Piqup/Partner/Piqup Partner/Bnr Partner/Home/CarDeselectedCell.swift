//
//  CarDeselectedCell.swift
//  BnR Partner
//
//  Created by KASP on 06/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class CarDeselectedCell: UITableViewCell {

    @IBOutlet weak var deCarImgView: UIImageView!
    
    @IBOutlet weak internal var lblDeCarName: UILabel!
    
    @IBOutlet weak internal var lblDeCarNo: UILabel!
    @IBOutlet weak var lblDeCarType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayDeSelectedData(car:Car){
        
        
        if car.subTypeImage.isEmpty{
            
        }
        else{
            if let url = URL(string: URLConstants.Domains.CarUrl + "\(car.carTypeId)/" + car.typeImage){
                self.deCarImgView.af_setImage(withURL: url)
            }
//            self.deCarImgView.af_setImage(withURL: URL(string:car.typeImage)!)
            
        }
        
        self.lblDeCarName.text = "\(car.brandName) \(car.carName)"
        self.lblDeCarNo.text = car.carNumber
        self.lblDeCarType.text = "\(car.typeName) - \(car.subTypeName)"

    }
    
}
