//
//  NewFilter.swift
//  OTT
//
//  Created by Malviya Ishansh on 10/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit

class NewFilterViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var filters: NewFilterCollectionView!
    
    var filtersArray = [FilterItem]()
    var filterObj:Filter?
    var selectedFiltersArray = NSMutableArray()
    var previousFiltersArray = NSMutableArray()
    var delegate : FilterSelectionProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .clear
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.label.text = self.filterObj?.title
        
        self.previousFiltersArray = NSMutableArray.init(array: self.selectedFiltersArray)
        self.filters.register(NewFilterCollectionViewCell.self, forCellWithReuseIdentifier: NewFilterCollectionViewCell.identifier)
        self.filtersArray = (filterObj?.items)!
        self.filters.reloadData()
        self.filters.backgroundColor = .clear
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.filters.collectionViewLayout.invalidateLayout()
            self.filters.reloadData()
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func showAlertWithText (header : String, message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }

    @IBAction func cancel(_ sender: Any) {
        self.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func apply(_ sender: Any) {
        let filters = NSMutableArray.init(array: self.selectedFiltersArray)
        self.delegate.filterSelected(filterList: filters, filter: self.filterObj!)
        self.cancel(UIButton())
    }
}

extension NewFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.filtersArray.count > 0 ? self.filtersArray.count : 0)
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 = self.filters.dequeueReusableCell(withReuseIdentifier: NewFilterCollectionViewCell.identifier, for: indexPath) as! NewFilterCollectionViewCell
        
        let filterItem = filtersArray[indexPath.item]
       
        if selectedFiltersArray.contains(filterItem.code) {
            cell1.backgroundColor =  UIColor(hexString: "eeeeee")
            cell1.titleLabel.textColor = UIColor(hexString: "000000")
        }
        
        
        return cell1
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! NewFilterCollectionViewCell
        if cell.filter?.selected == true {
            cell.filter?.selected = false
        } else {
            cell.filter?.selected = true
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
        self.filters.reloadData()
    }
}
