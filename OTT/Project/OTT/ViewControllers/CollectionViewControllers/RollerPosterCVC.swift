//
//  LiveCVC.swift
//  myColView
//
//  Created by Mohan on 5/21/17.
//  Copyright © 2017 com.cv. All rights reserved.
//

import UIKit
import OTTSdk
import Bluuur

protocol RollerPosterCVCProtocal {
    func didSelectedRollerPosterItem(item: Card) -> Void
    func rollerPoster_moreClicked(sectionData:SectionData,sect_data:SectionInfo,sectionControls:SectionControls)
}

class RollerPosterCVC: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var cCV: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noContentFoundLbl: UILabel!
    var delegate : RollerPosterCVCProtocal?
    var sectionsData = [Card]()
    var sectionData: SectionData?
    var section_Info : SectionInfo?
    var section_Controls : SectionControls?
    
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    let numColums: CGFloat = 1
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 13
    let scrollDir: UICollectionViewScrollDirection = .horizontal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    @IBAction func moreClicked(_ sender: UIButton) {
        self.delegate?.rollerPoster_moreClicked(sectionData: self.sectionData!, sect_data: self.section_Info!,sectionControls: self.section_Controls!)
    }
    func setUpData(sectionData:SectionData ,sectionInfo:SectionInfo, sectionControls:SectionControls) {
        sectionsData = sectionData.data
        self.sectionData = sectionData
        section_Info = sectionInfo
        self.section_Controls = sectionControls
        print(section_Info as Any)
        if sectionData.data.count == 0 {
            self.noContentFoundLbl.isHidden = false
        }
        else {
            self.noContentFoundLbl.isHidden = true
        }
        self.moreBtn.isHidden = (self.section_Controls?.showViewAll)!
        cCV.reloadData()
    }
    func setupViews() {
//        var tmpCellsize = cellSizes
//        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
//        cellSizes = tmpCellsize
        
        cCV.dataSource = self
        cCV.delegate = self
        
        self.moreBtn.tag = ButtonTags.buttonLive.rawValue
        
        
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
//        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        cCV.collectionViewLayout = cCFL
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let sectionCard = sectionsData[indexPath.item]
        if sectionCard.cardType == .roller_poster {
            let cardDisplay = sectionCard.display
            
            collectionView.register(UINib(nibName: "RollerPosterGV", bundle: nil), forCellWithReuseIdentifier: "RollerPosterGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RollerPosterGV", for: indexPath) as! RollerPosterGV
            cell.name.text = cardDisplay.title
            cell.desc.text = cardDisplay.subtitle1
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            
            return cell
        }
        else if sectionCard.cardType == .band_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
            cell.name.text = cardDisplay.title
            cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            cell.visulEV.blurRadius = 5
            return cell
        }
        else if sectionCard.cardType == .sheet_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "SheetPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGV", for: indexPath) as! SheetPosterCellGV
            cell.name.text = cardDisplay.title
            cell.desc.text = cardDisplay.subtitle2
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            
            return cell
        }
        else if sectionCard.cardType == .box_poster {
            collectionView.register(UINib(nibName: "BoxPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BoxPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellGV.identifier, for: indexPath) as! BoxPosterCellGV
            let cardInfo = sectionCard.display
            cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            if !cardInfo.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
                cell.iconViewWidthConstraint.constant = 0
            }
            cell.name.text = cardInfo.title
            if !cardInfo.subtitle2 .isEmpty && !cardInfo.subtitle1 .isEmpty {
                cell.desc.text = "\(cardInfo.subtitle2) | \(cardInfo.subtitle1)"
            }
            else if !cardInfo.subtitle2 .isEmpty {
                cell.desc.text = cardInfo.subtitle2
            }
            else if !cardInfo.subtitle1 .isEmpty {
                cell.desc.text = cardInfo.subtitle1
            }
            return cell
        }
        else if sectionCard.cardType == .pinup_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "PinupPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellGV", for: indexPath) as! PinupPosterCellGV
            cell.name.text = cardDisplay.title
            cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            cell.visulEV.blurRadius = 5
            return cell
        }
        else if sectionCard.cardType == .band_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
            cell.name.text = cardDisplay.title
            cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            cell.visulEV.blurRadius = 5
            return cell
        }
        else if sectionCard.cardType == .icon_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
            cell.name.text = cardDisplay.title
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            return cell
        }
        else if sectionCard.cardType == .info_poster {
            let cardDisplay = sectionCard.display
            collectionView.register(UINib(nibName: "InfoPosterLandscapeCellGV", bundle: nil), forCellWithReuseIdentifier: "InfoPosterLandscapeCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPosterLandscapeCellGV", for: indexPath) as! InfoPosterLandscapeCellGV
            cell.name.text = cardDisplay.title
            cell.desc.text = cardDisplay.subtitle1
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            else {
                cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            }
            return cell
        }
        else {
            collectionView.register(UINib(nibName: "RollerPosterGV", bundle: nil), forCellWithReuseIdentifier: "RollerPosterGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RollerPosterGV", for: indexPath) as! RollerPosterGV
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionCard = sectionsData[indexPath.item]
        
        if sectionCard.cardType == .roller_poster {
            return CGSize(width: 116, height: 206)
        }
//        else if sectionCard.cardType == .band_poster || sectionCard.cardType == .sheet_poster || sectionCard.cardType == .box_poster {
//            return CGSize(width: 179, height: 132)
//        }
//        else if sectionCard.cardType == .pinup_poster{
//            return CGSize(width: 182, height: 132)
//        }
        else {
            return CGSize(width: 179, height: 132)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Live CVC", indexPath)
        
       let channelItem = sectionsData[indexPath.item] 
        self.delegate?.didSelectedRollerPosterItem(item: channelItem)
    }
}

class RollerPosterGV: UICollectionViewCell {
    static let nibname:String = "RollerPosterGV"
    static let identifier:String = "RollerPosterGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var fdfsMarkerTagView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class RollerPosterLV: UICollectionViewCell {
    static let nibname:String = "RollerPosterLV"
    static let identifier:String = "RollerPosterLV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
class ContentPosterCellEpgGV: UICollectionViewCell {
    static let nibname:String = "ContentPosterCellEpgGV"
    static let identifier:String = "ContentPosterCellEpgGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class ContentPosterCellEpgLV: UICollectionViewCell {
    
    static let nibname:String = "ContentPosterCellEpgLV"
    static let identifier:String = "ContentPosterCellEpgLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class BoxPosterCellGV: UICollectionViewCell {
    static let nibname:String = "BoxPosterCellGV"
    static let identifier:String = "BoxPosterCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var bazaarmarketTagView: UIView!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class BoxPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "BoxPosterCellLV"
    static let identifier:String = "BoxPosterCellLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class IconPosterCellGV: UICollectionViewCell {
    
    static let nibname:String = "IconPosterCellGV"
    static let identifier:String = "IconPosterCellGV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class InfoPosterLandscapeCellGV: UICollectionViewCell {
    
    static let nibname:String = "InfoPosterLandscapeCellGV"
    static let identifier:String = "InfoPosterLandscapeCellGV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var genre: UIView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var newMarkerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

