//
//  GuideHeaderReusableView.swift
//  OTT
//
//  Created by YuppTV Ent on 10/10/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
protocol TinyGuideHeaderReusableViewProtocal {
    func didSelectedChannelItem(item: ChannelObj) -> Void
    func didSelectedDateItem(item: TVGuideTab) -> Void
}

class TinyGuideHeaderReusableView: UICollectionReusableView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var SelectedCurrentDate : TVGuideTab?
    var SelectedcurrentChannel : ChannelObj?
    static let nibname:String = "TinyGuideHeaderReusableView"
    static let identifier:String = "TinyGuideHeaderReusableView"
    
    @IBOutlet weak var datesCollection: UICollectionView!
    
    @IBOutlet weak var channelCollection: UICollectionView!
    
    var datesCollectionData = [TVGuideTab]()
    var channelCollectionData = [ChannelObj]()
    var delegate : TinyGuideHeaderReusableViewProtocal?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 23.0/255.0, green: 25.0/255.0, blue: 28.0/255.0, alpha: 1.0)

    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.backgroundColor = UIColor.init(red: 23.0/255.0, green: 25.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    }
    
    func setUpData(data : TVGuideResponse) {

        datesCollection.delegate = self
        datesCollection.dataSource = self
        
        
        channelCollection.delegate = self
        channelCollection.dataSource = self
        
        channelCollection.register(UINib(nibName: TinyGuideChannelCell.nibname, bundle: nil), forCellWithReuseIdentifier: TinyGuideChannelCell.identifier)
        
        datesCollection.register(UINib(nibName: TinyGuideDayCell.nibname, bundle: nil), forCellWithReuseIdentifier: TinyGuideDayCell.identifier)

        
        let index : Int = data.tabs.firstIndex(of: SelectedCurrentDate!) ?? 0
        
        datesCollectionData = data.tabs
        channelCollectionData = data.data
    
        datesCollection.reloadData()
        channelCollection.reloadData()
        datesCollection.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
    }
}

extension TinyGuideHeaderReusableView{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView == datesCollection {
            return datesCollectionData.count
        }else{
            return channelCollectionData.count
        }
        
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == datesCollection {
            let obj = datesCollectionData[indexPath.item]
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: TinyGuideDayCell.identifier as String, for: indexPath) as! TinyGuideDayCell
            if obj.title == "Today" {
                cell1.dateTitleLbl.text = obj.title
            }else{
                if obj.subtitle.count > 0 {
                    cell1.dateTitleLbl.text = obj.title + ", \(obj.subtitle)"
                }else {
                    cell1.dateTitleLbl.text = obj.title
                }
            }
            cell1.backgroundColor = UIColor.init(red: 76.0/255.0, green: 77.0/255.0, blue: 78.0/255.0, alpha: 1.0)
            if obj == self.SelectedCurrentDate {
                cell1.dateTitleLbl.textColor = UIColor.white
            }else{
                cell1.dateTitleLbl.textColor = UIColor.channelUnselectedTextColor
            }
            return cell1
        }else{
             let obj = channelCollectionData[indexPath.item]
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: TinyGuideChannelCell.identifier as String, for: indexPath) as! TinyGuideChannelCell
            cell1.channelNameLbl.text = obj.display.title
            cell1.channelImageView.sd_setImage(with: URL(string: obj.display.imageUrl), placeholderImage: #imageLiteral(resourceName: "account_profilepic"))
            cell1.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.08)
            
            if obj == self.SelectedcurrentChannel {
                cell1.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.22)
            }else{
                cell1.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.08)
            }
            
            return cell1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if collectionView == datesCollection {
            return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == datesCollection {
            return CGSize(width: 120, height: 43)
        }
        else {
            return CGSize(width: 200, height: 45)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == datesCollection {
            print(datesCollectionData[indexPath.item])
            self.delegate?.didSelectedDateItem(item: datesCollectionData[indexPath.item])
        }
        else {
           print(channelCollectionData[indexPath.item])
            self.delegate?.didSelectedChannelItem(item: channelCollectionData[indexPath.item])
        }
    }
    
}
