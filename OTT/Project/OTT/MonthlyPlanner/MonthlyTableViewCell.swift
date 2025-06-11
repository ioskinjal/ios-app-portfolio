//
//  MonthlyTableViewCell.swift
//  OTT
//
//  Created by YuppTV Ent on 19/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit

class MonthlyTableViewCell: UITableViewCell {
    
    static let nibname:String = "MonthlyTableViewCell"
    static let identifier:String = "MonthlyTableViewCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var comingUpLabel: UILabel!
    @IBOutlet weak var gradietView: UIView!
    
    @IBOutlet weak var btnArrow: UIButton!
    
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = UIFont.ottRegularFont(withSize: 12)
        lblTitle.textColor = AppTheme.instance.currentTheme.cardTitleColor
        lblSubTitle.font = UIFont.ottRegularFont(withSize: 10)
        lblSubTitle.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        
        comingUpLabel.font = UIFont.ottRegularFont(withSize: 10)
        comingUpLabel.textColor = AppTheme.instance.currentTheme.navigationViewBarColor
        comingUpLabel.numberOfLines = 0
        comingUpLabel.isHidden = true
        
        let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
            leftSwipeGest.direction = .left
            self.addGestureRecognizer(leftSwipeGest)
    }
    @objc func funcForGesture(sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
                        //scroll to next item
              
        }
    }
    static func registerToCollectionView(tableView : UITableView){
        
        tableView.register(MonthlyTableViewCell.self, forCellReuseIdentifier: MonthlyTableViewCell.identifier)
        tableView.register(UINib.init(nibName: MonthlyTableViewCell.nibname, bundle: nil), forCellReuseIdentifier: MonthlyTableViewCell.identifier)
    }
}
