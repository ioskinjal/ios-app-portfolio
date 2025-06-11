//
//  CastTableViewCell.swift
//  sampleColView
//
//  Created by Ankoos on 09/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit

protocol CastTableViewCellProtocal {
    func selectedCast(castModel: CastCrewModel) -> Void
}

class CastTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var castCollection: UICollectionView!
    
    @IBOutlet weak var castHeaderLbl: UILabel!
    var cCFL: CustomFlowLayout!
    var delegate : CastTableViewCellProtocal?
    let secInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var cellSizes: CGSize = CGSize(width: 130, height: 68)
    let numColums: CGFloat = 1
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 0
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    var castArry = [CastCrewModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }

    func setupViews()
    {
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        self.castHeaderLbl.text = "Cast & Crew".localized
        self.castHeaderLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.castHeaderLbl.font = UIFont.ottRegularFont(withSize: 13.0)
        castCollection.dataSource = self
        castCollection.delegate = self
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
       
        self.castCollection.register(UINib.init(nibName: CastCell.nibname, bundle: nil), forCellWithReuseIdentifier: CastCell.identifier)
         castCollection.collectionViewLayout = cCFL
    }
    func setUpData(cast: [CastCrewModel]) {
       self.castArry = cast
        if self.castArry.count > 0{
            self.castCollection.reloadData()
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.castArry.count > 0 ? self.castArry.count : 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath) as! CastCell
        let item = self.castArry[indexPath.item] as CastCrewModel
        cell.name.text = item.name
        cell.subTitle.text = item.type
        cell.name.font = UIFont.ottRegularFont(withSize: 12.0)
        cell.subTitle.font = UIFont.ottRegularFont(withSize: 11.0)
        cell.name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        cell.subTitle.textColor = AppTheme.instance.currentTheme.cardTitleColor
        cell.name.alpha = 0.65
        cell.subTitle.alpha = 0.45
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.castArry[indexPath.item] as CastCrewModel
        let label = UILabel.init()
        if item.name.count > item.type.count {
            label.text = item.name
        }
        else{
            label.text = item.type
        }
        label.font = UIFont.ottRegularFont(withSize: 12)
        label.frame = CGRect.init(x: 0, y: 0, width: 100, height: 27)
        label.sizeToFit()
        return CGSize.init(width: label.frame.size.width+25, height:50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.castArry[indexPath.item] as CastCrewModel
        self.delegate?.selectedCast(castModel: item)
    }
}
class CastCell: UICollectionViewCell {
    static let nibname:String = "CastCell"
    static let identifier:String = "CastCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        subTitle.textColor = AppTheme.instance.currentTheme.cardTitleColor
        name.alpha = 0.65
        subTitle.alpha = 0.45
    }
    
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        subTitle.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
