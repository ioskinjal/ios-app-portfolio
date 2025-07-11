//
//  HSCycleGalleryView.swift
//  HSCycleGalleryView
//
//  Created by Hanson on 2018/1/16.
//  Copyright © 2018年 HansonStudio. All rights reserved.
//

import UIKit

@objc public protocol HSCycleGalleryViewDelegate: class {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell
    
    @objc optional func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, didSelectItemCell cell: UICollectionViewCell, at Index: Int)
    @objc optional func cycleGalleryViewscrollViewDidEndDecelerating(_ index: Int)
    @objc optional func cycleGalleryViewscrollViewDidEndScrollingAnimation(_ index: Int)
    @objc optional func cycleGalleryViewscrollViewDidScroll(_ index: Int)
}

public class HSCycleGalleryView: UIView {
    
    public weak var delegate: HSCycleGalleryViewDelegate?
    
    var collectionView: UICollectionView!
    fileprivate let groupCount = 200
    fileprivate var indexArr = [Int]()
    var dataNum: Int = 0
    
    var autoScrollInterval: Double = 3
    
    var timer: Timer?
    var currentIndexPath: IndexPath!
    
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let flowLayout = HSCycleGalleryViewLayout()
        flowLayout.itemWidth = 250
        flowLayout.itemHeight = frame.height
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
    }
    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let flowLayout = HSCycleGalleryViewLayout()
        flowLayout.itemHeight = frame.width
        flowLayout.itemHeight = frame.height
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            self.removeTimer()
            if self.autoScrollInterval > 0 {
               // self.addTimer()
            }
        } else {
           // self.removeTimer()
        }
    }
}


// MARK: - Public Function

extension HSCycleGalleryView {
    
    public func reloadData() {
        guard let dataNum = delegate?.numberOfItemInCycleGalleryView(self) else { return }
        self.dataNum = dataNum
        indexArr.removeAll()
        for _ in 0 ..< groupCount {
            for j in 0 ..< dataNum {
                indexArr.append(j)
            }
        }
        collectionView.reloadData()
        // Scroll to the middle
        currentIndexPath = IndexPath(item: groupCount / 2 * dataNum, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    public func register(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func register(nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    public func scrollToSpecificIndex(_ index: Int) {
        self.collectionView.scrollToItem(at:IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
    }
}


// MARK: - Private Function

extension HSCycleGalleryView {
    
    func removeTimer() {
        self.timer?.invalidate()
        timer = nil
    }
    
    func addTimer() {
        if timer != nil {
            return
        }
        timer = Timer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        //        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollInterval), target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    @objc func autoScroll() {
        if self.superview == nil || self.window == nil {
            return
        }
        print("timer-autoScroll")
        self.scrollToNextIndex()
    }
    
    private func scrollToNextIndex() {
        var currentIndex = currentIndexPath.row
        if (currentIndex + 1) >= indexArr.count {
            currentIndex = groupCount / 2 * self.dataNum
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        let nextIndex = currentIndex + 1
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentIndexPath = IndexPath(item: nextIndex, section: 0)
    }
}

extension HSCycleGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexArr.count > 0 else { return UICollectionViewCell() }
        let index = indexArr[indexPath.row]
        let dataIndex = index % dataNum
        
        return self.delegate?.cycleGalleryView(self, cellForItemAtIndex: dataIndex) ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexArr[indexPath.row]
        let dataIndex = index % dataNum
        let cell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
        
        delegate?.cycleGalleryView?(self, didSelectItemCell: cell, at: dataIndex)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let indexPathNow = collectionView.indexPathForItem(at: pointInView)
        let index = (indexPathNow?.row ?? 0) % dataNum
        // 重置在中间
        currentIndexPath = IndexPath(item: groupCount / 2 * dataNum + index, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        delegate?.cycleGalleryViewscrollViewDidEndDecelerating?(index)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //delegate?.cycleGalleryViewscrollViewDidEndScrollingAnimation?(scrollView)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let indexPathNow = collectionView.indexPathForItem(at: pointInView)
        let index = (indexPathNow?.row ?? 0) % dataNum
        delegate?.cycleGalleryViewscrollViewDidScroll?(index)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       // addTimer()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //removeTimer()
    }
}

