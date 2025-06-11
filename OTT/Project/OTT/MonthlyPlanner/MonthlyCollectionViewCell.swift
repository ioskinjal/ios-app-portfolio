//
//  MonthlyCollectionViewCell.swift
//  OTT
//
//  Created by YuppTV Ent on 19/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class MonthlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayItems: [Card]?
    var arraySeason: [SeasonInfo]?
    var cellType: String = ""
    
    static let nibname:String = "MonthlyCollectionViewCell"
    static let identifier:String = "MonthlyCollectionViewCell"
    var delegate:collectionCell_delegate?
    var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = AppTheme.instance.currentTheme.lineColor.cgColor
        self.tableView.register(MonthlyTableViewCell.self, forCellReuseIdentifier: MonthlyTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        MonthlyTableViewCell.registerToCollectionView(tableView: tableView)
        
        let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
            leftSwipeGest.direction = .left
            self.addGestureRecognizer(leftSwipeGest)
    }
    @objc func funcForGesture(sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
                        //scroll to next item
              
        }
    }
    static func registerToCollectionView(collectionView : UICollectionView){
        collectionView.register(MonthlyCollectionViewCell.self, forCellWithReuseIdentifier: MonthlyCollectionViewCell.identifier)
        collectionView.register(UINib.init(nibName: MonthlyCollectionViewCell.nibname, bundle: nil), forCellWithReuseIdentifier: MonthlyCollectionViewCell.identifier)
    }
    
    func setUpData(data: Any, type: String) {
        
        cellType = type
        if type == "Season" {
            arraySeason = data as? [SeasonInfo]
        }else {
            arrayItems = data as? [Card]
        }
        tableView.reloadData()
    }
}

extension MonthlyCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.tableView.dequeueReusableCell(withIdentifier: MonthlyTableViewCell.identifier)! as! MonthlyTableViewCell?)!
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
            cell.gradietView.backgroundColor = .clear
        }else {
            
            cell.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
            cell.gradietView.backgroundColor = .black.withAlphaComponent(0.16)
            
        }
        
        var str = ""
        cell.btnArrow.isHidden = true
        cell.comingUpLabel.isHidden = true
        
        if cellType == "Season" {
            if indexPath.row < arraySeason?.count ?? 0 {
                str = (arraySeason?[indexPath.row].value ?? "") as String
            }
        }else {
            if indexPath.row < arrayItems?.count ?? 0 {
                if arrayItems?[indexPath.row] != nil {
                    let card = arrayItems![indexPath.row]
                    str = card.display.title
                    cell.viewTrailingConstraint.constant = 50
                    var isComingSoonFound = false
                    for marker in card.display.markers {
                        if marker.markerType == .comingSoon {
                            cell.comingUpLabel.text = marker.value
                            cell.comingUpLabel.numberOfLines = 0
                            isComingSoonFound = true
                            break
                        }
                    }
                    if isComingSoonFound == true {
                        cell.btnArrow.isHidden = true
                        cell.comingUpLabel.isHidden = false
                    }
                    else {
                        cell.btnArrow.setTitle("", for: .normal)
                        cell.btnArrow.isHidden = false
                        cell.comingUpLabel.isHidden = true
                    }
                }
            }
        }
        
        cell.lblTitle.text = str
        cell.lblSubTitle.text = str
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UITableView - getIndexPath")
            return
        }
        
        guard let collIndexPath = superView.indexPath(for: self) else { return }
        
        if let del = delegate{
            
            del.didPressed(collectionViewIndexPath: collIndexPath, tableViewIndexPath: indexPath)
        }
        
    }
}

