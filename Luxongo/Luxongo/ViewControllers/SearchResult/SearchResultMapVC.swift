//
//  SearchResultMapVC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchResultMapVC: BaseViewController {
    
    private var indexOfCellBeforeDragging = 0
    
    //MARK: Variables
    var searchEventList:[EventList] = []
    var lastVisibleIndex = IndexPath(item: 0, section: 0)
    
    //MARK: Properties
    static var storyboardInstance:SearchResultMapVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchResultMapVC.identifier) as! SearchResultMapVC
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnListView: GreyButton!
    
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
            
        }
    }
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            //collectionView.isPagingEnabled = true
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(EventCC.nib, forCellWithReuseIdentifier: EventCC.identifier)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }
    }
    
    @IBOutlet weak var googleMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.layoutIfNeeded()
        
        setMarketPin()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.addRightView(icon: #imageLiteral(resourceName: "ic_filter"), selector: #selector(didTapBtnFilter(_:)))
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        //popViewController(animated: true)
        popToHomeViewController(animated: true)
    }
    
    @IBAction func onClickListView(_ sender: UIButton) {
        popViewController(animated: false)
    }
    
}


//MARK: Custom function
extension SearchResultMapVC{
    
    @objc private func didTapBtnFilter(_ sender:UIButton){
        if let _ = sender.superview as? UITextField{
            print("Click Filter")
            present(FilterByVC.storyboardInstance, animated: true)
        }
    }
    
    func setMarketPin() {
        for (i,event) in searchEventList.enumerated(){
            //            addMarker(latitude: Double(event.event_lat) ?? 0, longitude: Double(event.event_long) ?? 0, isAnimate:( i == 0 ? true : false))
            let lat = Double(event.event_lat) ?? 0
            let long = Double(event.event_long) ?? 0
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat,long))
            //let imageview = UIImageView()
            
            DispatchQueue.main.async {
                
                let imageUrl:URL = URL(string: event.logo)!
                let imageData:NSData = NSData(contentsOf:imageUrl)!
                let image = UIImage(data: imageData as Data)
                marker.icon = self.drawImageWithProfilePic(pp: image ?? #imageLiteral(resourceName: "pinCircle"), image: #imageLiteral(resourceName: "pinCircle"))
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.map = self.googleMap
                
            }
            
            
            
        }
    }
    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    func addMarker(latitude : Double, longitude : Double, isAnimate: Bool) {
        let startPosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: startPosition)
        marker.map = self.googleMap
        marker.icon = GMSMarker.markerImage(with: .red)
        //animation on map
        if isAnimate{
            self.googleMap.animate(to: GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 15))
        }
    }
    
    func animateMap(indexPath:IndexPath) {
        let event = searchEventList[indexPath.item]
        let startPosition = CLLocationCoordinate2D(latitude: Double(event.event_lat) ?? 0, longitude: Double(event.event_long) ?? 0)
        self.googleMap.animate(to: GMSCameraPosition(latitude: startPosition.latitude, longitude: startPosition.longitude, zoom: 15))
    }
    
}


extension SearchResultMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchEventList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCC.identifier, for: indexPath) as? EventCC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = searchEventList[indexPath.item]
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let nextVC = EventPreview.storyboardInstance
        nextVC.event_slug = searchEventList[indexPath.row].event_slug
        pushViewController(nextVC, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: CGFloat(screenSize.width) * 0.85,
        //height: CGFloat(screenSize.width) * 0.68)
        //let width = screenSize.width * 270/320, height = screenSize.width * 250/370
        return CGSize(width: DeviceType.IS_IPHONE_5_OR_5SE ? 270.0 : 320.0,height: DeviceType.IS_IPHONE_5_OR_5SE ? 250.0 : 260.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("Ok:\(indexPath)")
    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        var visibleRect = CGRect()
    //
    //        visibleRect.origin = collectionView.contentOffset
    //        visibleRect.size = collectionView.bounds.size
    //
    //        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    //
    //        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else {
    //            collectionView.scrollToItem(at: lastVisibleIndex, at: .centeredHorizontally, animated: false)
    //            return
    //        }
    //
    //        print(indexPath)
    //        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    //        lastVisibleIndex = indexPath
    //        animateMap(indexPath: indexPath)
    //
    //    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else {
            collectionView.scrollToItem(at: lastVisibleIndex, at: .centeredHorizontally, animated: false)
            return
        }
        
        print(indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        lastVisibleIndex = indexPath
        animateMap(indexPath: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < searchEventList.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let itemWidth:CGFloat = DeviceType.IS_IPHONE_5_OR_5SE ? 270.0 : 320.0
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = itemWidth * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}


extension SearchResultMapVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        searchBar.resignFirstResponder()
        //FIMXE: API call
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth:CGFloat = DeviceType.IS_IPHONE_5_OR_5SE ? 270.0 : 320.0
        let proportionalOffset = ( collectionView.contentOffset.x / itemWidth )
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(searchEventList.count - 1, index))
        return safeIndex
    }
    
}
