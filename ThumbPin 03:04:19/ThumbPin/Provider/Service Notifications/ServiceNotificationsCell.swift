//
//  ServiceNotificationsCell.swift
//  ThumbPin
//
//  Created by NCT109 on 10/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ServiceNotificationsCell: UITableViewCell {
    
    @IBOutlet weak var btnPDF: UIButton!
    @IBOutlet weak var lblMaterialName: UILabel!
    @IBOutlet weak var labelPostedByStatic: UILabel!
    @IBOutlet weak var labelPostedStatic: UILabel!
    @IBOutlet weak var labelServiceStatusStatic: UILabel!
    @IBOutlet weak var labelBudgetStatic: UILabel!
    @IBOutlet weak var viewPosted: UIView!{
        didSet {
            viewPosted.layer.borderWidth = 1
            viewPosted.layer.borderColor = Color.Custom.lightGrayColor.cgColor
        }
    }
    @IBOutlet weak var viewServiceStatus: UIView!{
        didSet {
            viewServiceStatus.layer.borderWidth = 1
            viewServiceStatus.layer.borderColor = Color.Custom.lightGrayColor.cgColor
        }
    }
    @IBOutlet weak var viewEstBudget: UIView!{
        didSet {
            viewEstBudget.layer.borderWidth = 1
            viewEstBudget.layer.borderColor = Color.Custom.lightGrayColor.cgColor
        }
    }
    @IBOutlet weak var btnQuote: UIButton!
    @IBOutlet weak var labelPosted: UILabel!
    @IBOutlet weak var labelServiceStatus: UILabel!
    @IBOutlet weak var labelEstBudget: UILabel!
    @IBOutlet weak var labeLocation: UILabel!
    @IBOutlet weak var labelPostedBy: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelServiceName: UILabel!
    
    var tap = UITapGestureRecognizer()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLang()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpLang() {
        labelBudgetStatic.text = localizedString(key: "Est.Budget")
        labelServiceStatusStatic.text = localizedString(key: "Service Status")
        labelPostedStatic.text = localizedString(key: "Posted")
        labelPostedByStatic.text = localizedString(key: "Posted By :")
    }
    
}
