//
//  MyQuestionsViewController.swift
//  OTT
//
//  Created by Rajesh Nekkanti on 15/04/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit


let MyQuestionCellIdentifier = "MyQuestionsCollectionViewCell"


class MyQuestionsViewController: UIViewController {
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dropDownButtonsBgView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dropDownTxtFiledOne: DropDown!
    @IBOutlet weak var dropDownTxtFieldTwo: DropDown!
    
    let noQuestionsString = "Only Attachments"
    var genreListArray = [String]()
    var genreContentListTitlesArray = [String]()
    var genreContentListIdsArray = [Int]()
    var questionListArray = [MyQuestions]()
    var selectedGenreIndex = -1
    var selectedContentIndex = -1
    var expandableContentIndex = -1
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationBarColor
        self.titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.dropDownTxtFiledOne.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
         self.dropDownTxtFieldTwo.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.headerLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        collectionView.register(UINib.init(nibName: MyQuestionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: MyQuestionCellIdentifier)
        self.headerLbl.text = ""
        dropDownTxtFiledOne.isSearchEnable = false
        dropDownTxtFieldTwo.isSearchEnable = false
        dropDownTxtFiledOne.backgroundColor =  AppTheme.instance.currentTheme.chatTableBGView
        dropDownTxtFieldTwo.backgroundColor =  AppTheme.instance.currentTheme.chatTableBGView
        self.handleUI(true)
        addDropDownListData()
        getGenresListData()
    }
    func getGenresListData(){
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.getMyQuestionsGenresList(onSuccess: { (genres) in
            self.genreListArray = genres.genreArray
            if self.genreListArray.count > 0{
                self.selectedGenreIndex = 1
                self.dropDownTxtFiledOne.optionArray = self.genreListArray
                self.dropDownTxtFiledOne.text = self.genreListArray[self.selectedGenreIndex]
                self.stopAnimating()
                self.getContentListData()
            }
            else{
                self.stopAnimating()
                self.showAlert(mgs: "No Questions Found")
            }
        }) { (error) in
            self.stopAnimating()
            self.showAlert(mgs: error.message)
        }
    }
    func getContentListData(){
        self.startAnimating(allowInteraction: false)
        self.genreContentListIdsArray.removeAll()
        self.genreContentListTitlesArray.removeAll()
        self.dropDownTxtFieldTwo.selectedIndex = 0
        OTTSdk.userManager.getMyQuestionsGenresContentList(genre_code: self.genreListArray[self.selectedGenreIndex], onSuccess: { (genresData) in
            if  genresData.contentNameData.count > 0 {
                self.selectedContentIndex = 0
                for contentItem in genresData.contentNameData {
                    if let item = contentItem as? [Any] {
                        if let tempStr = item[0] as? String{
                            self.genreContentListTitlesArray.append(tempStr)
                        }
                        if let tempId = item[1] as? Int{
                            self.genreContentListIdsArray.append(tempId)
                        }
                    }
                }
                self.dropDownTxtFieldTwo.optionArray = self.genreContentListTitlesArray
                self.dropDownTxtFieldTwo.text = self.genreContentListTitlesArray[self.selectedContentIndex]

                self.getQuestionsList()
            }
            else{
                self.stopAnimating()
                self.showAlert(mgs: "No Questions Found")
            }
        }) { (error) in
            print ("error2:\(error.message)")
            self.stopAnimating()
            self.showAlert(mgs: error.message)
        }
    }
    func getQuestionsList(){
        self.startAnimating(allowInteraction: false)
        
        OTTSdk.userManager.getMyQuestionsList(genre_code: self.genreListArray[self.selectedGenreIndex], content_id: self.genreContentListIdsArray[self.selectedContentIndex], onSuccess: { (response) in
            self.headerLbl.text = response.chapterName
            self.questionListArray = response.questions
            if self.questionListArray.count > 0 {
                self.expandableContentIndex = -1
                self.collectionView.reloadData()
                self.handleUI(false)
                self.stopAnimating()
            }
            else{
                self.stopAnimating()
                self.showAlert(mgs: "No Questions Found")
            }
            
        }) { (error) in
            print ("error3:\(error.message)")
            self.stopAnimating()
            self.showAlert(mgs: error.message)
        }
        
    }
    func handleUI(_ isHidden:Bool) {
        self.headerLbl.isHidden = isHidden
        self.dropDownTxtFiledOne.isHidden = isHidden
        self.dropDownTxtFieldTwo.isHidden = isHidden
        self.collectionView.isHidden = isHidden
    }
    func addDropDownListData() {
       
        dropDownTxtFiledOne.didSelect{(selectedText , selectedIndex ,_) in
            if self.selectedGenreIndex != selectedIndex {
                self.dropDownTxtFiledOne.text = "\(selectedText)"
                self.selectedGenreIndex = selectedIndex
                self.getContentListData()
            }
        }
        dropDownTxtFieldTwo.didSelect{(selectedText , selectedIndex ,_) in
            if self.selectedContentIndex != selectedIndex {
                self.dropDownTxtFieldTwo.text = "\(selectedText)"
                self.selectedContentIndex = selectedIndex
                self.getQuestionsList()
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(mgs:String) {
        errorAlert(forTitle: String.getAppName(), message: mgs, needAction: true) { (flag) in
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension MyQuestionsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questionListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MyQuestionCellIdentifier, for: indexPath) as! MyQuestionsCollectionViewCell
        
        let questionDict = self.questionListArray[indexPath.row]
        cell.titleLbl.font = UIFont.ottRegularFont(withSize: 14)
        cell.dateLbl.font = UIFont.ottMediumFont(withSize: 10)
        cell.titleLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        cell.dateLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor

        cell.titleLbl.text = questionDict.question
        let timeTokenStr = NSString.init(string: "\(questionDict.postedTime)").substring(to: 10)
        cell.dateLbl.text = self.getDate(unixdate: Int(timeTokenStr)!)
        cell.dropDownArrowBtn.isHidden = (questionDict.hasAttachment ? false : true)
        if (questionDict.hasAttachment && questionDict.attachmentPath.count > 0) {
            if questionDict.question == "" {
                 cell.titleLbl.text = noQuestionsString
            }
            cell.imgOne.isHidden = false
            cell.imgOne.loadingImageFromUrl(questionDict.attachmentPath, category: "tv")
        }
        else{
            cell.imgOne.isHidden = true
        }
        if self.expandableContentIndex == indexPath.row {
            cell.dropDownArrowBtn.setImage(UIImage.init(named: "cellDropDownUpArrow"), for: .normal)
        }
        else{
            cell.dropDownArrowBtn.setImage(UIImage.init(named: "cellDropDownArrow"), for: .normal) 
        }
//        cell.titleLbl.sizeToFit()
        cell.titleLabelHeightConstraint?.constant = CGFloat(getLabelHeight(labelText: cell.titleLbl!.text!)+10)
        // not required Second image as we are uploading only one image
        
        print ("")
        
        cell.imgTwo.isHidden = true
        cell.imgCountLbl.isHidden = true
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var tempHH = 10
        let tempQuestionObj = self.questionListArray[indexPath.row]
        if tempQuestionObj.question == "" && tempQuestionObj.hasAttachment{
             tempHH = tempHH + getLabelHeight(labelText: noQuestionsString) + 42
        }
        else{
            tempHH = tempHH + getLabelHeight(labelText: tempQuestionObj.question) + 42
        }
        
        if (tempQuestionObj.hasAttachment && (indexPath.row ==  self.expandableContentIndex)) {
            tempHH = tempHH + 80
        }
        return CGSize(width: self.collectionView.frame.width - 20, height: CGFloat(tempHH))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}


extension MyQuestionsViewController : MyQuestionsDelegate {
    func onClickThumbnails(cell: MyQuestionsCollectionViewCell, tag: Int) {
        let indexPath = self.collectionView.indexPath(for: cell)
        if (indexPath != nil) {
            let tempQuestionObj = self.questionListArray[indexPath!.row]
            if tempQuestionObj.hasAttachment {
                if playerVC != nil {
                    playerVC?.player.pause()
                    playerVC?.isNavigatingToBrowser = true
                }
                let attachmentVC = AttachmentViewController.init(nibName: "AttachmentViewController", bundle: nil)
                attachmentVC.attachmentImagePath = tempQuestionObj.attachmentPath
                self.present(attachmentVC, animated: true, completion: nil)
            }
        }
        
    }
    
    func onClickAnswer(cell: MyQuestionsCollectionViewCell) {
//        let indexPath = self.collectionView.indexPath(for: cell)
//        showAlert(mgs: "\(indexPath?.row ?? 0)")
//        print(indexPath!.row)
        
    }
    
    func onClickAttachment(cell: MyQuestionsCollectionViewCell) {
//        let indexPath = self.collectionView.indexPath(for: cell)
//        print(indexPath!.row)
//        showAlert(mgs: "\(indexPath?.row ?? 0)")
        
    }
    
    func onClickArrow(cell: MyQuestionsCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        if self.expandableContentIndex == indexPath?.row ?? -1 {
            self.expandableContentIndex = -1
        }
        else{
            self.expandableContentIndex = indexPath?.row ?? -1
        }
        self.collectionView.reloadData()
    }

    func getDate(unixdate: Int) -> String {
        if unixdate == 0 {return ""}
        let tempDate = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.amSymbol = "AM"
        dayTimePeriodFormatter.pmSymbol = "PM"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        let dateString = dayTimePeriodFormatter.string(from: tempDate as Date)
        return dateString
    }
    func getLabelHeight(labelText:String) -> Int {
        let constraintRect = CGSize(width: (self.collectionView.frame.width - 62), height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = labelText.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 14.0)], context: nil)
        return Int(boundingBox.height)
    }
    
}
