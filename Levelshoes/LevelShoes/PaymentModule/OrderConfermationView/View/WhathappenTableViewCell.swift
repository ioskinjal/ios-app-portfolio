//
//  WhathappenTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class WhathappenTableViewCell: UITableViewCell {

    @IBOutlet weak var lblWhtHappensNext: UILabel!{
        didSet{
            lblWhtHappensNext.text = "whatNext".localized
        }
    }
    @IBOutlet weak var lblYouWillSoon: UILabel!{
        didSet{
            lblYouWillSoon.text = "willRcvConfirmationEmail".localized
        }
    }
    @IBOutlet weak var lblWeWillReceive: UILabel!{
        didSet{
            lblWeWillReceive.text = "willRcvTextmsg".localized
        }
    }

    @IBOutlet weak var lblYouHaveSelected: UILabel!{
        didSet{
            lblYouHaveSelected.text = "fourthDelivery".localized
        }
    }
    @IBOutlet weak var dotFour: UILabel!
    @IBOutlet weak var lblPayCash: UILabel!{
        didSet{
            lblPayCash.text = "codSelected".localized
        }
    }
    @IBOutlet weak var dotThree: UILabel!
    @IBOutlet weak var dotTwo: UILabel!
    @IBOutlet weak var dotOne: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dotOne.layer.cornerRadius = dotOne.frame.height / 2
        dotTwo.layer.cornerRadius = dotTwo.frame.height / 2
        dotThree.layer.cornerRadius = dotThree.frame.height / 2
        dotFour.layer.cornerRadius = dotFour.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
