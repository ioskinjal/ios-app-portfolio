//
//  PlayerSuggestionsView.swift
//  OTT
//
//  Created by Muzaffar on 14/05/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

@objc protocol PlayerSuggestionsViewDelegate {
    @objc optional func didSelectedCard(card: Card, suggestionsView : PlayerSuggestionsView) -> Void
}

class PlayerSuggestionsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var cotentHolderView: UIView!
    
    @IBOutlet private weak var suggestionsSwipeButton: UIButton!
    @IBOutlet private weak var suggestionsViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var suggestionsViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var suggestionsCollectionView: UICollectionView!
    
    var isVisible = true
    var sectionData : SectionData?
    weak var delegate : PlayerSuggestionsViewDelegate?

    var suggestionsType = Card.CardType.channel_poster
    
    /*
     swiping/tapping on swipe button closses the suggestions view
     */
    @IBAction func suggestionsSwipeTap() {
        isVisible = true
        self.showOrHideSuggestions()
    }
    
    func showOrHideSuggestions() {
        isVisible = !isVisible
        if isVisible{
            self.suggestionsViewTrailingConstraint.constant = 0
        }
        else{
            self.suggestionsViewTrailingConstraint.constant =  -suggestionsViewWidthConstraint.constant
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.superview?.layoutIfNeeded()
            self.alpha = self.isVisible ? 1 : 0
        }) { (_) in
            self.isHidden = !self.isVisible
        }
    }
    
    func loadSuggestions(path:String, code: String) {
        OTTSdk.mediaCatalogManager.sectionContent(path: path, code: code, offset: -1, count: nil, filter: nil, onSuccess: { (response) in
            if let sectionData = response.first{
                self.updateSuggestions(sectionData: sectionData)
            }
            else {
                
            }
        }) { (error) in
            Log(message: error.message)
        }
    }
    
    func updateSuggestions(sectionData : SectionData){
        if (sectionData.data.count) > 0 {
            if let card = sectionData.data.first{
                self.suggestionsType = card.cardType
            }
            self.sectionData = sectionData

            suggestionsCollectionView.register(UINib(nibName: "ListCVC", bundle: nil), forCellWithReuseIdentifier: "ListCVC")
             suggestionsCollectionView.register(UINib(nibName: "ImageCVC", bundle: nil), forCellWithReuseIdentifier: "ImageCVC")
            suggestionsCollectionView.delegate = self
            suggestionsCollectionView.dataSource = self
            
            if suggestionsType == .channel_poster {
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                suggestionsCollectionView.collectionViewLayout = layout
            }
            
            let size = self.collectionView(suggestionsCollectionView, layout: suggestionsCollectionView.collectionViewLayout , sizeForItemAt: IndexPath.init(row: 0, section: 0))
            suggestionsViewWidthConstraint.constant = size.width + 35
            suggestionsSwipeTap()
        }
    }
    
    
    @objc func recordBtnClicked(sender:UIButton) {
        print(#function)
    }
    
    @objc func stopRecordBtnClicked(sender:UIButton) {
        print(#function)
    }
    
    //MARK: - collectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionCard = sectionData!.data[indexPath.item]
        let cardDisplay = sectionCard.display
        
        if suggestionsType == .channel_poster {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC
            cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
            return cell
        }
        else if suggestionsType == .overlay_poster || suggestionsType == .sheet_poster {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCVC", for: indexPath) as! ListCVC
            cell.title.text = cardDisplay.title
            cell.subTitle.text = cardDisplay.subtitle1
            cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
            cell.cornerDesignForCollectionCell()
            return cell
        }
        else {
            // Default : should never reach here
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC
            cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if suggestionsType == .channel_poster {
            return ImageCVC.size
        }
        else if suggestionsType == .overlay_poster || suggestionsType == .sheet_poster {
            return ListCVC.size
        }
        return ImageCVC.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionCard = sectionData!.data[indexPath.item]
        self.delegate?.didSelectedCard?(card: sectionCard, suggestionsView: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        suggestionsSwipeTap()
    }
}


/*
 Temp code
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
    let sectionCard = sectionData!.data[indexPath.item]
    if sectionCard.cardType == .circle_poster {
        return CGSize(width: 64, height: 94)
    } else if sectionCard.cardType == .square_poster {
        return CGSize(width: 100, height: 130)
    }
    if sectionCard.cardType == .roller_poster {
        return CGSize(width: 116, height: 206)
    }
    else if sectionCard.cardType == .live_poster {
        return CGSize(width: 179, height: 132)
    }
    else if sectionCard.cardType == .content_poster {
        return CGSize(width: 179, height: 142)
    }
    else if sectionCard.cardType == .sheet_poster {
        return CGSize(width: 232, height: 61)
    }
    else {
        if productType.iPad {
            return CGSize(width: 229, height: 182)
        }
        return CGSize(width: 179, height: 132)
    }
}


if sectionCard.cardType == .circle_poster {
    let cardDisplay = sectionCard.display
    
    collectionView.register(UINib(nibName: "CirclePosterCell", bundle: nil), forCellWithReuseIdentifier: "CirclePosterCell")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CirclePosterCell", for: indexPath) as! CirclePosterCell
    cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: UIImage.init(named: "partner_default"))
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0
    cell.imageView.clipsToBounds = true
    cell.nameLbl.text = cardDisplay.title
    cell.backgroundColor = UIColor.clear
    //                cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .square_poster {
    let cardDisplay = sectionCard.display
    
    collectionView.register(UINib(nibName: "SquarePosterCell", bundle: nil), forCellWithReuseIdentifier: "SquarePosterCell")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquarePosterCell", for: indexPath) as! SquarePosterCell
    cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: UIImage.init(named: "partner_default"))
    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
    cell.nameLbl.text = cardDisplay.title
    cell.backgroundColor = UIColor.clear
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .roller_poster {
    let cardDisplay = sectionCard.display
    
    collectionView.register(UINib(nibName: "RollerPosterGV", bundle: nil), forCellWithReuseIdentifier: "RollerPosterGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RollerPosterGV", for: indexPath) as! RollerPosterGV
    cell.name.text = cardDisplay.title
    cell.desc.text = cardDisplay.subtitle1
    cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "portrait-default"))
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in cardDisplay.markers {
        if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .band_poster {
    let cardDisplay = sectionCard.display
    collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
    cell.name.text = cardDisplay.title
    cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    if !cardDisplay.parentIcon .isEmpty {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    else {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in sectionCard.display.markers {
        if marker.markerType == .tag && marker.value == "Premium" {
            cell.premiumView.isHidden = false
        }
        else if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.visulEV.blurRadius = 5
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .sheet_poster || sectionCard.cardType == .common_poster {
    
    if productType.iPad {
        let cardDisplay = sectionCard.display
        collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
        cell.name.text = cardDisplay.title
        cell.desc.text = cardDisplay.subtitle1
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage:  #imageLiteral(resourceName: "Default-TVShows"))
        
        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
        cell.recordBtn.isHidden = true
        cell.stopRecordingBtn.isHidden = true
        
        for marker in cardDisplay.markers {
            if marker.markerType == .record || marker.markerType == .stoprecord{
                if marker.markerType == .record {
                    cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    cell.recordBtn.isHidden = false
                    cell.stopRecordingBtn.isHidden = true
                } else {
                    cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = false
                }
                cell.recordBtn.tag = indexPath.row
                cell.stopRecordingBtn.tag = indexPath.row
                cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            }
        }
        cell.cornerDesignForCollectionCell()
        return cell
    }
    else {
        let cardDisplay = sectionCard.display
        collectionView.register(UINib(nibName: "SheetPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellLV")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellLV", for: indexPath) as! SheetPosterCellLV
        cell.name.text = cardDisplay.title
        cell.desc.text = cardDisplay.subtitle1
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        
        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
        cell.cornerDesignForCollectionCell()
        return cell
    }
}
else if sectionCard.cardType == .box_poster {
    collectionView.register(UINib(nibName: "BoxPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BoxPosterCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellGV.identifier, for: indexPath) as! BoxPosterCellGV
    let cardInfo = sectionCard.display
    cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    if !cardInfo.parentIcon .isEmpty {
        cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    else {
        cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        cell.iconViewWidthConstraint.constant = 0
    }
    cell.name.text = cardInfo.title
    cell.desc.text = cardInfo.subtitle1
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in cardInfo.markers {
        if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .pinup_poster {
    
    if productType.iPad{
        let cardDisplay = sectionCard.display
        collectionView.register(UINib(nibName: "PinupPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellGViPad")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellGViPad", for: indexPath) as! PinupPosterCellGViPad
        cell.name.text = cardDisplay.title
        cell.subTitle.text = cardDisplay.subtitle1
        if cardDisplay.subtitle1 .isEmpty {
            cell.nameLblBottomConstraint.constant = 6.0
        }
        else {
            cell.nameLblBottomConstraint.constant = 12.0
        }
        cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage:  #imageLiteral(resourceName: "Default-TVShows"))
        if !cardDisplay.parentIcon .isEmpty {
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage:  #imageLiteral(resourceName: "Default-TVShows"))
        }
        else {
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage:  #imageLiteral(resourceName: "Default-TVShows"))
        }
        cell.visulEV.blurRadius = 5
        cell.cornerDesignForCollectionCell()
        return cell
    }
    else {
        let cardDisplay = sectionCard.display
        collectionView.register(UINib(nibName: "PinupPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellGV")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellGV", for: indexPath) as! PinupPosterCellGV
        cell.name.text = cardDisplay.title
        cell.iconView.sd_setImage(with: URL(string: cardDisplay.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        if !cardDisplay.parentIcon .isEmpty {
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        }
        else {
            cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        }
        cell.cornerDesignForCollectionCell()
        return cell
    }
}
else if sectionCard.cardType == .content_poster {
    
    if productType.iPad{
        collectionView.register(UINib(nibName: ContentPosterCellEpgGVIpad.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgGVIpad.identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgGVIpad.identifier, for: indexPath) as! ContentPosterCellEpgGVIpad
        let cardInfo = sectionCard.display
        if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
            cell.iconView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            //                cell.iconViewWidthConstraint.constant = 35.0
        }
        else {
            //                cell.iconViewWidthConstraint.constant = 0.0
        }
        cell.markerLbl.isHidden = true
        cell.nowPlayingStrip.isHidden = true
        
        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
        cell.recordBtn.isHidden = true
        cell.stopRecordingBtn.isHidden = true
        for marker in cardInfo.markers {
            if marker.markerType == .badge {
                cell.markerLbl.isHidden = false
                cell.markerLbl.text = marker.value
                cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
                cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
            }
            else if marker.markerType == .special && marker.value == "now_playing" {
                cell.nowPlayingStrip.isHidden = false
            }
            else if marker.markerType == .record || marker.markerType == .stoprecord{
                if marker.markerType == .record {
                    cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    
                    cell.recordBtn.isHidden = false
                    cell.stopRecordingBtn.isHidden = true
                } else {
                    cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = false
                }
                cell.recordBtn.tag = indexPath.row
                cell.stopRecordingBtn.tag = indexPath.row
                cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            }
        }
        cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        cell.name.text = cardInfo.title
        if cardInfo.parentName .isEmpty {
            cell.desc.text = cardInfo.subtitle1
        }
        else {
            if sectionCard.cardType == .live_poster {
                cell.desc.text = cardInfo.parentName
            }
            else {
                cell.desc.text = cardInfo.subtitle1
            }
        }
        cell.layer.cornerRadius = 4.0
        cell.iconView.layer.cornerRadius = 4.0
        cell.cornerDesignForCollectionCell()
        return cell
    }
    else {
        collectionView.register(UINib(nibName: ContentPosterCellEpgGV.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgGV.identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgGV.identifier, for: indexPath) as! ContentPosterCellEpgGV
        let cardInfo = sectionCard.display
        if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
            cell.iconView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            //                cell.iconViewWidthConstraint.constant = 35.0
        }
        else {
            //                cell.iconViewWidthConstraint.constant = 0.0
        }
        cell.markerLbl.isHidden = true
        cell.nowPlayingStrip.isHidden = true
        
        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
        cell.recordBtn.isHidden = true
        cell.stopRecordingBtn.isHidden = true
        for marker in cardInfo.markers {
            if marker.markerType == .badge {
                cell.markerLbl.isHidden = false
                cell.markerLbl.text = marker.value
                cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
                cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
            }
            else if marker.markerType == .special && marker.value == "now_playing" {
                cell.nowPlayingStrip.isHidden = false
            }
            else if marker.markerType == .record || marker.markerType == .stoprecord{
                if marker.markerType == .record {
                    cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    
                    cell.recordBtn.isHidden = false
                    cell.stopRecordingBtn.isHidden = true
                } else {
                    cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                    cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = false
                }
                cell.recordBtn.tag = indexPath.row
                cell.stopRecordingBtn.tag = indexPath.row
                cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            }
        }
        cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        cell.name.text = cardInfo.title
        if cardInfo.parentName .isEmpty {
            cell.desc.text = cardInfo.subtitle1
        }
        else {
            if sectionCard.cardType == .live_poster {
                cell.desc.text = cardInfo.parentName
            }
            else {
                cell.desc.text = cardInfo.subtitle1
            }
        }
        cell.layer.cornerRadius = 4.0
        cell.iconView.layer.cornerRadius = 4.0
        cell.cornerDesignForCollectionCell()
        return cell
    }
}
else if sectionCard.cardType == .live_poster {
    collectionView.register(UINib(nibName: LivePosterGV.nibname, bundle: nil), forCellWithReuseIdentifier: LivePosterGV.identifier)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePosterGV.identifier, for: indexPath) as! LivePosterGV
    let cardInfo = sectionCard.display
    if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
        cell.iconView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        //                cell.iconViewWidthConstraint.constant = 35.0
    }
    else {
        //                cell.iconViewWidthConstraint.constant = 0.0
    }
    cell.markerLbl.isHidden = true
    cell.nowPlayingStrip.isHidden = true
    
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in cardInfo.markers {
        if marker.markerType == .badge {
            cell.markerLbl.isHidden = false
            cell.markerLbl.text = marker.value
            cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
            cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
        }
        else if marker.markerType == .special && marker.value == "now_playing" {
            cell.nowPlayingStrip.isHidden = false
        }
        else if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    cell.name.text = cardInfo.title
    if cardInfo.parentName .isEmpty {
        cell.desc.text = cardInfo.subtitle1
    }
    else {
        cell.desc.text = cardInfo.parentName
    }
    cell.layer.cornerRadius = 4.0
    cell.iconView.layer.cornerRadius = 4.0
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .band_poster {
    let cardDisplay = sectionCard.display
    collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
    cell.name.text = cardDisplay.title
    cell.iconView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    if !cardDisplay.parentIcon .isEmpty {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    else {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    cell.visulEV.blurRadius = 5
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in sectionCard.display.markers {
        if marker.markerType == .tag && marker.value == "Premium" {
            cell.premiumView.isHidden = false
        }
        else if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .icon_poster {
    let cardDisplay = sectionCard.display
    collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
    cell.name.text = cardDisplay.title
    if !cardDisplay.parentIcon .isEmpty {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    else {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
else if sectionCard.cardType == .info_poster {
    let cardDisplay = sectionCard.display
    collectionView.register(UINib(nibName: "InfoPosterLandscapeCellGV", bundle: nil), forCellWithReuseIdentifier: "InfoPosterLandscapeCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPosterLandscapeCellGV", for: indexPath) as! InfoPosterLandscapeCellGV
    cell.name.text = cardDisplay.title
    cell.desc.text = cardDisplay.subtitle1
    if !cardDisplay.parentIcon .isEmpty {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    else {
        cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
else {
    let cardDisplay = sectionCard.display
    collectionView.register(UINib(nibName: "SheetPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGV")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGV", for: indexPath) as! SheetPosterCellGV
    cell.name.text = cardDisplay.title
    cell.desc.text = cardDisplay.subtitle1
    cell.imageView.sd_setImage(with: URL(string: cardDisplay.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    cell.watchedProgressView.isHidden = true
    cell.episodeMarkupTagView.isHidden = true
    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
    cell.recordBtn.isHidden = true
    cell.stopRecordingBtn.isHidden = true
    for marker in cardDisplay.markers {
        if marker.markerType == .record || marker.markerType == .stoprecord{
            if marker.markerType == .record {
                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                
                cell.recordBtn.isHidden = false
                cell.stopRecordingBtn.isHidden = true
            } else {
                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = false
            }
            cell.recordBtn.tag = indexPath.row
            cell.stopRecordingBtn.tag = indexPath.row
            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
    }
    cell.cornerDesignForCollectionCell()
    return cell
}
*/
