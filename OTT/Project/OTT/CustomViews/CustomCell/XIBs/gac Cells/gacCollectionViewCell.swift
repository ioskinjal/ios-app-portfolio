//
//  gacCollectionViewCell.swift
//  gac
//
//  Created by Malviya Ishansh on 26/07/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit



class gacTopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seperator: UIImageView!
    @IBOutlet weak var seperators: UIView!
    
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var favLbl: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var downloadLbl: UILabel!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var shareLbl: UILabel!
    
}

class gacMiddleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var describe: UILabel!
}

class gacBottomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    
}
