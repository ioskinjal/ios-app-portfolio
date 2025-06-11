//
//  PreferencesVC.swift
//  YUPPTV
//
//  Created by Ankoos on 12/08/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import TagCellLayout

protocol FilterSelectionProtocol {
    func filterSelected(filterList:NSMutableArray, filter:Filter)
}

struct FilterItemTitle {
    var title : String{
        set{
            barSubTitle = newValue
            
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)
            let boundingBox = barSubTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context: nil)
            answerHeight = boundingBox.width + 10
        }
        get{
            return barSubTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var barSubTitle = ""
}

class FiltersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIGestureRecognizerDelegate{
    var firstObj : String!
    var filtersArray = [FilterItem]()
    var filterObj:Filter?
    var selectedFiltersArray = NSMutableArray()
    var previousFiltersArray = NSMutableArray()
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var filterLayout: FilterCollectionViewLayout!
    var delegate : FilterSelectionProtocol!
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    var filterCellData: [FilterItemTitle] = [FilterItemTitle]()
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
   // var cellSizes: CGSize = CGSize(width: 100.0, height: 16)
   // var numColums: CGFloat = 1
    @IBOutlet weak var filterHeight: NSLayoutConstraint!
    let interItemSpacing: CGFloat = 20.0
    let minLineSpacing: CGFloat = 20.0
    var cVHeight = CGFloat(100)
    var rows = 0.0
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var categoriesColorArr:NSMutableArray!
    @IBOutlet weak var skiporclearButton: UIButton!
    @IBOutlet weak var saveornextBtn: UIButton!
    @IBOutlet weak var LanguageCollectionView: DynmicHeightCollectionView!
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
   /*
    func calculateNumCols() {
        if productType.iPad {
            if currentOrientation().portrait {
                numColums = 5
            } else if currentOrientation().landscape {
                numColums = 6
            }
        } else {
            if currentOrientation().portrait {
                numColums = 2
            } else if currentOrientation().landscape {
                numColums = 3
            }
        }
        cCFL.numberOfColumns = numColums
        Log(message: "numColums: \(self.numColums)")
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skiporclearButton.backgroundColor = .clear
        self.skiporclearButton.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.skiporclearButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.skiporclearButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .highlighted)
        self.skiporclearButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .selected)
        self.saveornextBtn.backgroundColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        self.saveornextBtn.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.saveornextBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.saveornextBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .highlighted)
        self.saveornextBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .selected)
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .clear
        self.insideView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.LanguageCollectionView.backgroundColor = .clear
        self.navigationView.backgroundColor = .clear
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.headingLabel.text = self.filterObj?.title
        filterLayout = FilterCollectionViewLayout()//TagCellLayout(alignment: .left, delegate: self)
        LanguageCollectionView.collectionViewLayout = filterLayout
        LanguageCollectionView.register(UINib.init(nibName: "FilterGenres_Cell", bundle: nil)  , forCellWithReuseIdentifier: "FilterGenres_Cell")
        self.skiporclearButton.setTitle("Cancel", for: UIControl.State.normal)
        self.skiporclearButton.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.skiporclearButton.buttonCornerDesignWithBorder(AppTheme.instance.currentTheme.cardSubtitleColor, borderWidth: CGFloat(1.0))
        self.saveornextBtn.setTitle("Apply".localized, for: UIControl.State.normal)
        self.saveornextBtn.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.saveornextBtn.backgroundColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        self.saveornextBtn.buttonCornerDesignWithBorder(.white, borderWidth: 1.0)
       
        self.filtersArray = (filterObj?.items)!
        if self.selectedFiltersArray.count == 0, let titleobj = filtersArray.first(where: {$0.title == firstObj}) {
            self.selectedFiltersArray.add(titleobj.code)
        }
        
        self.previousFiltersArray = NSMutableArray.init(array: self.selectedFiltersArray)
      //  setupViews()
        /*
        categoriesColorArr = NSMutableArray()
        categoriesColorArr.addObjects(from: [UIColor.init(red: 18.0/255.0, green: 148.0/255.0, blue: 246.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 63.0/255.0, green: 77.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 106.0/255.0, green: 27.0/255.0, blue: 154.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 11.0/255.0, green: 155.0/255.0, blue: 175.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 76.0/255.0, green: 176.0/255.0, blue: 80.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 203.0/255.0, green: 18.0/255.0, blue: 79.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 241.0/255.0, green: 149.0/255.0, blue: 1.0/255.0, alpha: 1.0)
            ,UIColor.init(red: 16.0/255.0, green: 103.0/255.0, blue: 201.0/255.0, alpha: 1.0)])

        */
       
        
        
        self.filterCellData.removeAll()
        for item in self.filtersArray {
            var cellData = FilterItemTitle()
            cellData.title = item.title
            self.filterCellData.append(cellData)
        }
        self.LanguageCollectionView.layoutIfNeeded()
        self.LanguageCollectionView.reloadData()

        /*
        if self.fromPage == true {
            //PREF_GENRES
           if  (OTTSdk.preferenceManager.user?.languages .isEmpty)! {
                
                let langStr:String = (OTTSdk.preferenceManager.user?.languages)!
                self.printLog(log:langStr as AnyObject?)
                let arr = langStr.components(separatedBy: ",")
                for langArrStr in arr {
                    if langArrStr != "" {
                        selectedLanguagesArray.add(langArrStr)
                    }
                }
                self.printLog(log:selectedLanguagesArray)
            }
            
            if self.Signup_Process == true {
                self.skiporclearButton.setTitle("Skip", for: UIControl.State.normal)
                self.saveornextBtn.setTitle("Next", for: UIControl.State.normal)
            }
            else{
                self.skiporclearButton.setTitle("Clear", for: UIControl.State.normal)
                self.saveornextBtn.setTitle("Done", for: UIControl.State.normal)
            }
            
          
        }else{
            
            /**/
             if  OTTSdk.preferenceManager.user?.languages .isEmpty == false {
                
    
                let langStr:String = (OTTSdk.preferenceManager.user?.languages)!
                self.printLog(log:langStr as AnyObject?)
                let arr = langStr.components(separatedBy: ",")
                for langArrStr in arr {
                    if langArrStr != "" {
                        selectedLanguagesArray.add(langArrStr)
                    }
                }
                self.printLog(log:selectedLanguagesArray)
            }
            
            self.skiporclearButton.setTitle("Cancel", for: UIControl.State.normal)
            self.saveornextBtn.setTitle("Save", for: UIControl.State.normal)
        }
        */
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

/*
        self.startAnimating(allowInteraction: false)
        let qosClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        backgroundQueue.async(execute: {
        
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                
                self.stopAnimating()

                self.languagesArray = response.contentLanguages
//
//                for lang in self.languagesArray{
//                    if !self.selectedLanguagesArray.contains(lang.code) {
//                        self.selectedLanguagesArray.add(lang.code)
//                    }else
//                    {
//                        self.selectedLanguagesArray.remove(lang.code)
//                    }
//                }
                self.LanguageCollectionView .reloadData()

            }, onFailure: { (error) in
                self.stopAnimating()
                Log(message: error.message)
            })
        });
 */
        
        for item in filterCellData {
            if self.rows < LanguageCollectionView.frame.width {
                self.rows += item.answerHeight + 25
            } else {
                self.filterHeight.constant += 35.0
                self.rows -= LanguageCollectionView.frame.width
            }
        }
        
        
        self.insideView.frame = CGRect(x: 0, y: self.view.frame.height - CGFloat(filterHeight.constant), width: UIScreen.main.bounds.width, height: CGFloat(filterHeight.constant))
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
   /*
    func calculateActualSize(cellSizes: CGSize, numColums: CGFloat, interItemSpacing: CGFloat, secInsets: UIEdgeInsets) -> CGSize {
        let newW = (UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - secInsets.left - secInsets.right) / numColums
        let imageSize = cellSizes
        let returnHeight = (newW / imageSize.width) * imageSize.height
        return CGSize(width: newW, height: returnHeight)
    }
    func setupViews() {
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
         self.calculateNumCols()
        cCFL.setupLayout()
        LanguageCollectionView.collectionViewLayout = cCFL
    }*/
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @IBAction func backAction(_ sender: AnyObject) {
        self.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    // Show alert
    func showAlertWithText (header : String, message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    @IBAction func skipAction(_ sender: AnyObject) {
        self.selectedFiltersArray = NSMutableArray.init(array: self.previousFiltersArray)
        self.backAction(UIButton())
    }
    @IBAction func NextBtnAction(_ sender: AnyObject) {
        let filters = NSMutableArray.init(array: self.selectedFiltersArray)
        self.delegate.filterSelected(filterList: filters, filter: self.filterObj!)
        self.backAction(UIButton())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
           // self.calculateNumCols()
            self.LanguageCollectionView.collectionViewLayout.invalidateLayout()
            self.LanguageCollectionView.reloadData()
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}
extension FiltersViewController: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        let item = self.filterCellData[index]
        let width = item.answerHeight
        return CGSize(width: width, height: CGFloat(20))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.filterCellData[indexPath.item]
        let width = item.answerHeight + 16
        return CGSize(width: width, height: CGFloat(20))
        
    }
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.filterCellData.count > 0 ? self.filterCellData.count : 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterGenres_Cell" as String, for: indexPath)

        let filterItem = self.filterCellData[indexPath.item]
        let filterData = filtersArray[indexPath.item]
        let filterImageVIew = cell1.contentView.viewWithTag(1) as! UIImageView
        let filterTitle = cell1.contentView.viewWithTag(2) as! UILabel
        let checkButton = cell1.contentView.viewWithTag(3) as! UIButton
        
        filterTitle.text = filterItem.title
        
//        var imageWidthConstraint : NSLayoutConstraint?
//        for constraint in filterImageVIew.constraints as [NSLayoutConstraint] {
//            if constraint.identifier == "imageWidthConstraint" {
//                imageWidthConstraint = constraint
//            }
//        }
      /*
        if filterItem.image.count == 0{
            filterImageVIew.isHidden = true
            imageWidthConstraint?.constant = 0
            filterTitle.textAlignment = .center
        }
        else{
            imageWidthConstraint?.constant = 35
            filterImageVIew.isHidden = false
            filterImageVIew.loadingImageFromUrl(filterItem.image, category: "")
            filterTitle.textAlignment = .left
        }
        checkButton.setImage(#imageLiteral(resourceName: "check_selected"), for: UIControl.State.selected)
       */
        /***selected genres**/
        if selectedFiltersArray.contains(filterData.code) {
            checkButton.isSelected = true
            filterTitle.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
            filterTitle.textColor = UIColor.black
        }else{
            checkButton.isSelected = false
            filterTitle.backgroundColor = .clear
            filterTitle.textColor = UIColor.white
            cell1.backgroundColor = .clear
        }
        cell1.viewCornerDesignWithBorder(.white)
        /*let  i  = (indexPath.row as Int) % Int(categoriesColorArr.count)
        cell1.backgroundColor = categoriesColorArr[i] as? UIColor*/
        cell1.backgroundColor = UIColor.clear
        filterImageVIew.isHidden = true
        checkButton.isHidden = true
        /***selected genres***/
        return cell1
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: TagCellLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
//    func languageSelected(_ sender: AnyObject?) -> Void {
//        let btn = sender as! UIButton
//        btn.isSelected = true
//        btn.setImage(#imageLiteral(resourceName: "check_selected"), for: UIControl.State.selected)
//    }
    
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let checkButton = cell.contentView.viewWithTag(3) as! UIButton

        if checkButton.isSelected == true {
            checkButton.isSelected = false
        }else{
            checkButton.isSelected = true
        }
        
        let dict = filtersArray[indexPath.item]
        
        if (self.filterObj?.multiSelectable)! {
            if self.selectedFiltersArray.contains(dict.code) {
                self.selectedFiltersArray.remove(dict.code)
            }
            else {
                self.selectedFiltersArray.add(dict.code)
            }
        }
        else {
            if self.selectedFiltersArray.contains(dict.code) {
                self.selectedFiltersArray.removeAllObjects()
            }
            else {
                self.selectedFiltersArray.removeAllObjects()
                self.selectedFiltersArray.add(dict.code)
            }
        }
        self.LanguageCollectionView.reloadData()
        if self.selectedFiltersArray.count == 0 {
            self.saveornextBtn.alpha = 0.5
            self.saveornextBtn.isUserInteractionEnabled = false
        }
        else {
            self.saveornextBtn.alpha = 1.0
            self.saveornextBtn.isUserInteractionEnabled = true
        }
    }
    

}

extension FiltersViewController {
    private func setupCollView(collView: DynmicHeightCollectionView){
        
        let layout = FilterCollectionViewLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        collView.frame = .zero
        collView.collectionViewLayout = layout
        collView.translatesAutoresizingMaskIntoConstraints = false
        //    collView.isScrollEnabled = false
        collView.delegate = self
        collView.dataSource = self
        collView.backgroundColor = .clear
    }
}

class FilterCollectionViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
      var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
      
      var leftMargin: CGFloat = self.sectionInset.left
      
      for attributes in attributesForElementsInRect! {
        if (attributes.frame.origin.x == self.sectionInset.left) {
          leftMargin = self.sectionInset.left
        } else {
          var newLeftAlignedFrame = attributes.frame
          
          if leftMargin + attributes.frame.width < self.collectionViewContentSize.width {
            newLeftAlignedFrame.origin.x = leftMargin
          } else {
            newLeftAlignedFrame.origin.x = self.sectionInset.left
          }
          
          attributes.frame = newLeftAlignedFrame
        }
        leftMargin += attributes.frame.size.width + 8
        newAttributesForElementsInRect.append(attributes)
      }
      return newAttributesForElementsInRect
    }
}


class DynmicHeightCollectionView: UICollectionView {
    
    
  
  var isDynamicSizeRequired = false
//
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
      
      if self.intrinsicContentSize.height > frame.size.height {
        self.invalidateIntrinsicContentSize()
      }
      if isDynamicSizeRequired {
        self.invalidateIntrinsicContentSize()
      }
    }
  }
//
  override var intrinsicContentSize: CGSize {
    return contentSize
  }
}
