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
    
    var cCFL: CustomFlowLayout!
    var delegate : CastTableViewCellProtocal?
    let secInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    var cellSizes: CGSize = CGSize(width: 160, height: 68)
    let numColums: CGFloat = 1
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 13
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
        cell.imageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: #imageLiteral(resourceName: "account_profilepic"))
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width/2
        cell.imageView.layer.borderColor = UIColor.init(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0).cgColor
        cell.imageView.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
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
