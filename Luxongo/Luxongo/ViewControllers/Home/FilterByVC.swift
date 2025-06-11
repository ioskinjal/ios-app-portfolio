//
//  FilterByVC.swift
//  Luxongo
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FilterByVC: BaseViewController {
    
    //MARK:- Properties
    
    static var storyboardInstance:FilterByVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: FilterByVC.identifier) as! FilterByVC
    }
    
    @IBOutlet weak var stackViewPrice: UIStackView!
    @IBOutlet weak var btnFree: UIButton!{
        didSet{
            self.btnFree.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }
    }
    @IBOutlet weak var btnPaid: UIButton!{
        didSet{
            self.btnPaid.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }
    }
    
    
    @IBOutlet weak var subCategoryStackview: UIStackView!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnbestMatch: UIButton!
    @IBOutlet weak var constSubCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var constCategoryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constEventTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewSubCategory: UICollectionView!{
        didSet{
            collectionViewSubCategory.delegate = self
            collectionViewSubCategory.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewCategory: UICollectionView!{
        didSet{
            collectionViewCategory.delegate = self
            collectionViewCategory.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewEventType: UICollectionView!{
        didSet{
            collectionViewEventType.delegate = self
            collectionViewEventType.dataSource = self
        }
    }
    @IBOutlet weak var txtStartDate: UITextField!{
        didSet{
            let startPickerview =  UIDatePicker()
            startPickerview.datePickerMode = .date
            startPickerview.addTarget(self, action: #selector(startDate(_:)), for: UIControl.Event.valueChanged)
            txtStartDate.inputView = startPickerview
            
            
        }
    }
    
    let datePickerViewEnd =  UIDatePicker()
    @IBOutlet weak var txtEndDate: UITextField!{
        didSet{
            
            datePickerViewEnd.datePickerMode = .date
            datePickerViewEnd.addTarget(self, action: #selector(endDate(_:)), for: UIControl.Event.valueChanged)
            txtEndDate.inputView = datePickerViewEnd
            
            
        }
    }
    
    @objc func endDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        datePickerViewEnd.minimumDate = formatter.date(from: txtStartDate.text ?? "")
        txtEndDate.text = formatter.string(from: sender.date)
        
    }
    
    @IBOutlet weak var txtFromPrice: UITextField!
    
    @IBOutlet weak var txtToPrice: UITextField!
    
    
    var categoryList = [Category]()
    var selectedCat:Category?
    var subCategoryList = [SubCategory]()
    var selectedSubCat:SubCategory?
    var eventTypeList = [EventType]()
    var selectedEventType:EventType?
    var parentVC:SearchResultListVC?
    
    func setTicketType(isFree : Bool) {
        self.btnPaid.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        self.btnFree.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        if(isFree) {
            self.btnFree.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            stackViewPrice.isHidden = true
        } else {
            self.btnPaid.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
             stackViewPrice.isHidden = false
        }
    }
    
    @IBAction func onClickPaid(_ sender: UIButton) {
        setTicketType(isFree: false)
    }
    
    @IBAction func onClickFree(_ sender: UIButton) {
        setTicketType(isFree: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if parentVC?.param["event_price_type"]as? String == "f"{
            onClickFree(btnFree)
        }else{
            onClickPaid(btnPaid)
        }
        
        if parentVC?.param["sort_by"]as? String == "best_match"{
            onClickFree(btnbestMatch)
        }else{
            onClickPaid(btnDefault)
        }
        
        txtStartDate.text = parentVC?.param["event_start_date"] as? String
        txtEndDate.text = parentVC?.param["event_end_date"] as? String
        txtFromPrice.text = parentVC?.param["event_price_start_amount"] as? String
        txtToPrice.text = parentVC?.param["event_price_end_amount"] as? String
        
        getCategories()
    }
    
    
    @objc func startDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtStartDate.text = formatter.string(from: sender.date)
    }
    
    
    
    //MARK:- API Functions
    
    func getCategories(){
        API.shared.call(with: .getCategories, viewController: self, param: [:]) { (response) in
            self.categoryList = Response.fatchDataAsArray(res: response, valueOf: .data).map({Category(dictionary: $0 as! [String:Any])})
            
            let strSelectedCat:Int = self.parentVC?.param["event_category_id"] as? Int ?? 0
            for i in 0..<self.categoryList.count{
                if self.categoryList[i].id == strSelectedCat{
                    self.selectedCat = self.categoryList[i]
                    self.categoryList[i].isChecked = true
                }
            }
            
            self.collectionViewCategory.reloadData()
            self.setupLayoutCategory()
            self.constCategoryHeight.constant = 50
            
        }
        getEventType()
    }
    
    
    
    func getEventType(){
        API.shared.call(with: .getEventTypes, viewController: self, param: [:]) { (response) in
            self.eventTypeList = Response.fatchDataAsArray(res: response, valueOf: .data).map({EventType(dictionary: $0 as! [String:Any])})
            
            let strSelectedEvent:Int = self.parentVC?.param["event_type_id"] as? Int ?? 0
            for i in 0..<self.eventTypeList.count{
                if self.eventTypeList[i].id == strSelectedEvent{
                    self.selectedEventType = self.eventTypeList[i]
                    self.eventTypeList[i].isChecked = true
                    self.getSubCategories()
                }
            }
            
            self.collectionViewEventType.reloadData()
            self.setupLayoutEventType()
            self.constEventTypeHeight.constant = 50
            
        }
    }
    
    func getSubCategories(){
        
        let param = ["category_id":selectedCat?.id ?? 0]
        
        API.shared.call(with: .getSubCategories, viewController: self, param: param) { (response) in
            self.subCategoryList = Response.fatchDataAsArray(res: response, valueOf: .data).map({SubCategory(dictionary: $0 as! [String:Any])})
            
            let strSelectedSubCat:Int = self.parentVC?.param["event_sub_category_id"] as? Int ?? 0
            for i in 0..<self.subCategoryList.count{
                if self.subCategoryList[i].id == strSelectedSubCat{
                    self.selectedSubCat = self.subCategoryList[i]
                    self.subCategoryList[i].isChecked = true
                }
            }
            
            self.collectionViewSubCategory.reloadData()
            self.setupLayoutSubCategory()
            self.constSubCategoryHeight.constant = 50
            self.subCategoryStackview.isHidden = false
            
        }
    }
    
    //MARK:- Layout Functions
    
    func setupLayoutCategory() {
        let layout = TagsCollectionViewLayout()
        
        var cellSizes:[CGSize] = []
        let dummyCell = collectionViewCategory.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: IndexPath(row: 0, section: 0)) as! TagCollectionViewCell
        categoryList.forEach { (str) in
            // cellの期待width
            let expectedCellWidth = str.category_name.width(withConstrainedHeight: dummyCell.label1.frame.height,
                                                            font: dummyCell.label1.font)
            // cellの期待Size
            cellSizes.append(CGSize(width: expectedCellWidth + TagCollectionViewCell.inset.left + TagCollectionViewCell.inset.right,
                                    height: dummyCell.label1.frame.height + TagCollectionViewCell.inset.top + TagCollectionViewCell.inset.bottom))
        }
        
        layout.setup(cellSizes: cellSizes,
                     horizontalMargin: 10,
                     verticalMargin: 10,
                     collectionViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        collectionViewCategory.setCollectionViewLayout(layout, animated: false)
        
    }
    
    func setupLayoutSubCategory() {
        let layout = TagsCollectionViewLayout()
        
        var cellSizes:[CGSize] = []
        let dummyCell = collectionViewSubCategory.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: IndexPath(row: 0, section: 0)) as! TagCollectionViewCell
        subCategoryList.forEach { (str) in
            // cellの期待width
            let expectedCellWidth = str.sub_category_name.width(withConstrainedHeight: dummyCell.label1.frame.height,
                                                                font: dummyCell.label1.font)
            // cellの期待Size
            cellSizes.append(CGSize(width: expectedCellWidth + TagCollectionViewCell.inset.left + TagCollectionViewCell.inset.right,
                                    height: dummyCell.label1.frame.height + TagCollectionViewCell.inset.top + TagCollectionViewCell.inset.bottom))
        }
        
        layout.setup(cellSizes: cellSizes,
                     horizontalMargin: 10,
                     verticalMargin: 10,
                     collectionViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        collectionViewSubCategory.setCollectionViewLayout(layout, animated: false)
        
    }
    
    func setupLayoutEventType() {
        let layout = TagsCollectionViewLayout()
        
        var cellSizes:[CGSize] = []
        let dummyCell = collectionViewEventType.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: IndexPath(row: 0, section: 0)) as! TagCollectionViewCell
        eventTypeList.forEach { (str) in
            // cellの期待width
            let expectedCellWidth = str.type_name.width(withConstrainedHeight: dummyCell.label1.frame.height,
                                                        font: dummyCell.label1.font)
            // cellの期待Size
            cellSizes.append(CGSize(width: expectedCellWidth + TagCollectionViewCell.inset.left + TagCollectionViewCell.inset.right,
                                    height: dummyCell.label1.frame.height + TagCollectionViewCell.inset.top + TagCollectionViewCell.inset.bottom))
        }
        
        layout.setup(cellSizes: cellSizes,
                     horizontalMargin: 10,
                     verticalMargin: 10,
                     collectionViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        collectionViewEventType.setCollectionViewLayout(layout, animated: false)
        
    }
    
    
    //MARK:- UIButton Click Events
    
    @IBAction func onClickCloseFilter(_ sender: GreyButton) {
        dismiss(animated: true)
    }
    
    @IBAction func onClickCategory(_ sender: UIButton) {
        // setupLayoutCategory()
        if constCategoryHeight.constant == collectionViewCategory.contentSize.height{
            constCategoryHeight.constant = 50
            sender.setImage(#imageLiteral(resourceName: "ICrightArrow"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
            constCategoryHeight.constant = collectionViewCategory.contentSize.height
        }
    }
    
    @IBAction func onClickEventType(_ sender: UIButton) {
        if constEventTypeHeight.constant == collectionViewEventType.contentSize.height{
            constEventTypeHeight.constant = 50
            sender.setImage(#imageLiteral(resourceName: "ICrightArrow"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
            constEventTypeHeight.constant = collectionViewEventType.contentSize.height
        }
    }
    @IBAction func onClickSubCategory(_ sender: UIButton) {
        if constSubCategoryHeight.constant == collectionViewSubCategory.contentSize.height{
            constSubCategoryHeight.constant = 50
            sender.setImage(#imageLiteral(resourceName: "ICrightArrow"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
            constSubCategoryHeight.constant = collectionViewSubCategory.contentSize.height
        }
    }
    @IBAction func onClickSortBy(_ sender: UIButton) {
        if sender.tag == 0{
            sender.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            btnDefault.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }else if sender.tag == 1{
            sender.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
            btnbestMatch.setImage(#imageLiteral(resourceName: "radioNormal"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "radioSelected"), for: .normal)
        }
    }
    
    @IBAction func onClickApply(_ sender: BlackBgButton) {
        parentVC?.param["event_type_id"] = selectedEventType?.id
        parentVC?.param["event_category_id"] = selectedCat?.id
        parentVC?.param["event_sub_category_id"] = selectedSubCat?.id
        parentVC?.param["event_start_date"] = txtStartDate.text ?? ""
        parentVC?.param["event_end_date"] = txtEndDate.text ?? ""
        
        if btnFree.currentImage == #imageLiteral(resourceName: "radioSelected"){
            parentVC?.param["event_price_type"] = "f"
        }else{
            parentVC?.param["event_price_type"] = "p"
        }
        
        if btnbestMatch.currentImage == #imageLiteral(resourceName: "radioSelected"){
            parentVC?.param["sort_by"] = "best_match"
        }else{
            parentVC?.param["sort_by"] = "date"
        }
        
        parentVC?.param["event_price_start_amount"] = txtToPrice.text ?? ""
        parentVC?.param["event_price_end_amount"] = txtFromPrice.text ?? ""
        
        dismiss(animated: true)
    }
    
    @IBAction func onClickClear(_ sender: UIButton) {
        selectedCat = nil
        selectedSubCat = nil
        selectedEventType = nil
        
        for i in categoryList{
            i.isChecked = false
        }
        
        for i in eventTypeList{
            i.isChecked = false
        }
        
        for i in subCategoryList{
            i.isChecked = false
        }
        
        collectionViewEventType.reloadData()
        collectionViewCategory.reloadData()
        collectionViewSubCategory.reloadData()
        
        txtStartDate.text = ""
        txtEndDate.text = ""
        txtToPrice.text = ""
        txtFromPrice.text = ""
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FilterByVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewSubCategory{
            return subCategoryList.count
        }else if collectionView == collectionViewEventType{
            return eventTypeList.count
        }
        else{
            return categoryList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewSubCategory{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.label1.text = subCategoryList[indexPath.item].sub_category_name
            if subCategoryList[indexPath.item].isChecked == true{
                cell.layer.borderWidth = 0.0
                cell.viewContainer.backgroundColor = Color.Orange.theme
                cell.label1.textColor = UIColor.black
            }else{
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = Color.grey.textColor.cgColor
                cell.label1.textColor = Color.grey.textColor
                cell.viewContainer.backgroundColor = UIColor.clear
            }
            return cell
        }else if collectionView == collectionViewEventType{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.label1.text = eventTypeList[indexPath.item].type_name
            if eventTypeList[indexPath.item].isChecked == true{
                cell.layer.borderWidth = 0.0
                cell.viewContainer.backgroundColor = Color.Orange.theme
                cell.label1.textColor = UIColor.black
            }else{
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = Color.grey.textColor.cgColor
                cell.label1.textColor = Color.grey.textColor
                cell.viewContainer.backgroundColor = UIColor.clear
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.label1.text = categoryList[indexPath.item].category_name
            if categoryList[indexPath.item].isChecked == true{
                cell.layer.borderWidth = 0.0
                cell.viewContainer.backgroundColor = Color.Orange.theme
                cell.label1.textColor = UIColor.black
            }else{
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = Color.grey.textColor.cgColor
                cell.label1.textColor = Color.grey.textColor
                cell.viewContainer.backgroundColor = UIColor.clear
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSubCategory{
            for i in subCategoryList{
                i.isChecked = false
            }
            subCategoryList[indexPath.item].isChecked = true
            selectedSubCat = subCategoryList[indexPath.item]
            collectionViewSubCategory.reloadData()
        }else if collectionView == collectionViewEventType{
            for i in eventTypeList{
                i.isChecked = false
            }
            eventTypeList[indexPath.item].isChecked = true
            selectedEventType = eventTypeList[indexPath.item]
            collectionViewEventType.reloadData()
        }
        else{
            for i in categoryList{
                i.isChecked = false
            }
            categoryList[indexPath.item].isChecked = true
            selectedCat = categoryList[indexPath.item]
            getSubCategories()
            collectionViewCategory.reloadData()
        }
    }
}
