//
//  BannerCVC.swift
//  myColView
//
//  Created by Mohan on 5/21/17.
//  Copyright © 2017 com.cv. All rights reserved.
//

import UIKit
import SDWebImage
import OTTSdk

protocol BannerCVCProtocal {
    func didSelectedBannerItem(bannerItem: Banner) -> Void
}

class BannerCVC: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cCV: UICollectionView!
    var bannerDelegate: BannerCVCProtocal?
    
   // var cCFL: CustomFlowLayout!
    var secInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    var cellSizes: CGSize = CGSize(width: 323, height: 161)
    let numColums: CGFloat = 2
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 7
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    var shouldAllowBannerAnimation = false
    var selectedBannerIndex = 1
    var bannerTimer = Timer()
    var actualBannersArray = [Banner]()
    var isPartnerPage = false
    var partnerName = ""

    var banners = [Banner]()  {
        didSet{
            if banners.count == 1 {
                secInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 0.0)
            }
            cCV.reloadData()
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupViews() {
        if productType.iPad {
//            cellSizes = CGSize(width: 469.4, height: 233.8)
            let tempWidth = AppDelegate.getDelegate().window?.frame.size.width ?? 320
            cellSizes = CGSize(width: tempWidth , height: tempWidth / 2)
        } else {
            let tempWidth = AppDelegate.getDelegate().window?.frame.size.width ?? 320
            cellSizes = CGSize(width: tempWidth, height: tempWidth  / 2)
            //var tmpCellsize = cellSizes
            //tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
            //cellSizes = tmpCellsize
        }
        
        cCV.dataSource = self
        cCV.delegate = self
        cCV.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCellId")
      //  cCV.isPagingEnabled = true
//        cCFL = CustomFlowLayout()
//        cCFL.secInset = secInsets
//        cCFL.cellSize = cellSizes
//        cCFL.interItemSpacing = interItemSpacing
//        cCFL.minLineSpacing = minLineSpacing
//        cCFL.numberOfColumns = numColums
//        cCFL.scrollDir = scrollDir
//        cCFL.setupLayout()
//        cCV.collectionViewLayout = cCFL
//        cCV.decelerationRate = UIScrollView.DecelerationRate.fast
        
        
        cCV.collectionViewLayout = BannerFlowLayout()
        if let layout = cCV.collectionViewLayout as? BannerFlowLayout {
            layout.itemSpace = 12
            layout.itemSize = cellSizes
            layout.minimuAlpha = 0.4
        }
        
        chek()
    }
    
    func chek()  {
        (cCV.collectionViewLayout as? BannerFlowLayout)?.setInfinite(isInfinite: true, completed: { [unowned self] (result) in
            if result {
                return
            }
            // Prevent your content size is enough to cycle
        })
        #warning("Commented autoscrolling")
        (cCV.collectionViewLayout as? BannerFlowLayout)?.autoPlayStatus = .play(duration: 5.0)
        #warning("Commented autoscrolling")
    }
    /*
    func scrollTheBanners(_ scroll:Bool) {
        if scroll {
            let tempBanners = self.banners
            self.actualBannersArray = tempBanners
            if actualBannersArray.count >= 3{
                self.banners.insert(tempBanners[tempBanners.count - 1], at: 0)
                self.banners.append(actualBannersArray[0])
                self.banners.append(actualBannersArray[1])
            }
            
            self.shouldAllowBannerAnimation = (self.banners.count > 3)
            if self.shouldAllowBannerAnimation{
                cCV.selectItem(at: IndexPath(row: selectedBannerIndex, section: 0) , animated: false, scrollPosition:
                    .centeredHorizontally)
                self.pauseScrollingBanner(pause: false)
            }
        }
    }
    
    func pauseScrollingBanner(pause : Bool){
        if !pause{
            self.bannerTimer.invalidate()
            self.bannerTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.updateBanner), userInfo: nil, repeats: true)
        } else {
            bannerTimer.invalidate()
        }
    }

    @objc func updateBanner() {
        if self.shouldAllowBannerAnimation == true{
            
            
            selectedBannerIndex = (selectedBannerIndex + 1) % banners.count
            cCV.selectItem(at: IndexPath(row: selectedBannerIndex, section: 0) , animated: true, scrollPosition:
                .centeredHorizontally)

            if selectedBannerIndex == actualBannersArray.count + 1{
                self.perform(#selector(self.resetScrollPositionToStartingPoint), with: nil, afterDelay: 1)
            }
        }
    }

    @objc func resetScrollPositionToStartingPoint()  {
        selectedBannerIndex = 1
        cCV.selectItem(at: IndexPath(row: selectedBannerIndex, section: 0) , animated: false, scrollPosition:
            .centeredHorizontally)
    }
*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellId", for: indexPath) as! ImageCell
        let banner = banners[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: banner.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-Banner"))
//        print ("banner.imageUrl: \(banner.imageUrl)")
//        print((banners[indexPath.item] as AnyObject).imageUrlMobile)
//        cell.imageView.sd_setImage(with: URL(string: (banners[indexPath.item] as AnyObject).imageUrlMobile), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Banner CVC", indexPath)
        let b_item = self.banners[indexPath.item]
        let bannerDic = ["Banner_ID":"\(b_item.id)","Banner_name":b_item.title,"Partners":"","Language":OTTSdk.preferenceManager.selectedLanguages]
        LocalyticsEvent.tagEventWithAttributes("Banners", bannerDic)
        bannerDelegate?.didSelectedBannerItem(bannerItem: b_item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("Will \(indexPath)")
        if let layout = cCV.collectionViewLayout as? BannerFlowLayout {
//            print(layout.currentIdx)
        }
    }
    
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        (cCV.collectionViewLayout as? BannerFlowLayout)?.autoPlayStatus = .none
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        (cCV.collectionViewLayout as? BannerFlowLayout)?.autoPlayStatus = .play(duration: 5.0)
        if let layout = cCV.collectionViewLayout as? BannerFlowLayout {
//            print(layout.currentIdx)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let layout = cCV.collectionViewLayout as? BannerFlowLayout {
//            print("Scroll ",layout.currentIdx)
        }
    }

    
    /*
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //self.snapToNearestCell(scrollView: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.snapToNearestCell(scrollView: scrollView)
    }
    
    func snapToNearestCell(scrollView: UIScrollView) {
//         let middlePoint = Int(scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
//         if let indexPath = self.cCV.indexPathForItem(at: CGPoint(x: middlePoint, y: 0)) {
//              self.cCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//         }
        
        selectedBannerIndex = (selectedBannerIndex + 1) % banners.count
        cCV.selectItem(at: IndexPath(row: selectedBannerIndex, section: 0) , animated: true, scrollPosition:
            .centeredHorizontally)
        
        if selectedBannerIndex == actualBannersArray.count + 1{
                       self.perform(#selector(self.resetScrollPositionToStartingPoint), with: nil, afterDelay: 1)
                   }
    }
    */
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = self.cCV.contentOffset
        visibleRect.size = self.cCV.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = self.cCV.indexPathForItem(at: visiblePoint)!
        
        self.selectedBannerIndex = visibleIndexPath.row
    }
*/
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

