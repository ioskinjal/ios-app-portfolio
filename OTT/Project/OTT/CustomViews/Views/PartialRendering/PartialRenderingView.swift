//
//  PartialRenderingView.swift
//  OTT
//
//  Created by Muzaffar Ali on 17/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol PartialRenderingViewDelegate {
    func record(confirm : Bool, content : Any?)
    func errorIn(partialRenderingView : PartialRenderingView, errorMessage : String)
    func didSelected(card : Card?, content : Any?, templateElement : TemplateElement? )
}

extension PartialRenderingViewDelegate{
    func errorIn(partialRenderingView : PartialRenderingView, errorMessage : String){
        // making this method as optional
    }
}

class PartialRenderingView: UIView, UITableViewDelegate, UITableViewDataSource, PRHeaderTableViewCellDelegate, PRRecordOptionsViewDelegate {
    static var templates : [TemplateResponse]?
    var transparentView : UIView?
    var tableView = UITableView(frame: AppDelegate.getDelegate().window!.bounds)
    var card : Card?
    var tableContent = [Any]()
    var prButtons = [TemplateElement]()
    var prUIButtons = [UIButton]()
    var prHeader = PRHeader.init()
    var recordingView : PRRecordOptionsView?
    var content : Any? // Channel
    var delegate : PartialRenderingViewDelegate?
    var templateData : TemplateData?
    var showInfoOnly = false
    var showOnlyRecordOptions = false
    var isFromPlayer = false
    var headerCell : PRHeaderTableViewCell?
    let recordNotificationName = NSNotification.Name(rawValue: "recordNotificationName")
    let padding = 10
    let EdgesSpacing = 15
    internal var _bitrate : Double = 0
    var bitrate : Double{
        set{
            if headerCell != nil{
                headerCell!.bitrateLabel.text = ""
                if self.isFromPlayer && (AppDelegate.getDelegate().configs?.showStreamBitRate ?? false){
                    headerCell!.bitrateLabel.text = "Bitrate:" + String(format: "%.0f", newValue)
                }
            }
            _bitrate = newValue
        }
        get{
            return _bitrate
        }
    }
    
    public class var instance: PartialRenderingView {
        struct Singleton {
            static let obj = PartialRenderingView.init(frame: AppDelegate.getDelegate().window!.bounds)
        }
        return Singleton.obj
    }
    
    struct PRHeader{
        var imageUrl = ""
        var title = ""
        var subTitle = ""
        var subTitle1 = ""
        var subTitle2 = ""
        var status : String?
        var statusElementSubtype : String?
        init() {
        }
    }
    
    struct PRText {
        enum PRElementSubtype {
            case cast
            case description
        }
        var prElementSubtype = PRElementSubtype.cast
        var data = ""
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.initViews()
    }
    
    func initViews(){
        if transparentView == nil{
            AppDelegate.getDelegate().isPartialViewLoaded = true
            self.transparentView = UIView()
            self.transparentView!.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.transparentView!.frame = AppDelegate.getDelegate().window!.bounds
            self.addSubview(self.transparentView!)
            
            //TransparentView
            self.transparentView!.isUserInteractionEnabled = true
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
            self.transparentView!.addGestureRecognizer(singleTap)
        }
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        

        
        //TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.tableView.register(UINib(nibName:PRHeaderTableViewCell.nibName , bundle: nil), forCellReuseIdentifier: PRHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName:PRAvailableTableViewCell.nibName , bundle: nil), forCellReuseIdentifier: PRAvailableTableViewCell.identifier)
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.init(hexString: "#2b2b36")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if DeviceType.IS_IPHONE_X {
            self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: AppDelegate.getDelegate().window!.bounds.width, height: 10.0))
        } else {
            self.tableView.tableFooterView = UIView()
        }
        self.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.separatorStyle = .none
        

        adjustTableFrame()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
    }
    
    var contentSize = CGSize.zero
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tableView && keyPath == "contentSize" {

//                print("#PRV : \(contentSize.equalTo(self.tableView.contentSize)) : \(self.contentSize), \(self.tableView.contentSize)")
//                if !contentSize.equalTo(self.tableView.contentSize){
                    self.contentSize = self.tableView.contentSize
                    self.adjustTableFrame()
//                }
                
                
                //                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                //                    self.tableView.frame.size.height = newSize.height
                //                }
            }
        }
    }
    
    deinit {
        printYLog("#Partial Rendering : " + #function)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
        
    //MARK: - Network Methods
    static func getAllTemplates(templatesList : @escaping (_ response : [TemplateResponse]?)-> Void){
        if PartialRenderingView.templates == nil{
            UIApplication.topVC()!.startAnimating(allowInteraction: false)
            OTTSdk.mediaCatalogManager.templatesList(onSuccess: { (templates) in
                UIApplication.topVC()!.stopAnimating()
                PartialRenderingView.templates = templates
                templatesList(PartialRenderingView.templates)
            }) { (error) in
                UIApplication.topVC()!.stopAnimating()
                templatesList(nil)
            }
        }
        else{
            templatesList(PartialRenderingView.templates)
        }
    }
    
    func getTemplateFor(code : String, completion :  @escaping(_ template : TemplateResponse?) -> Void){
        PartialRenderingView.getAllTemplates { (allTemplates) in
//            if allTemplates != nil{
//                if let _template = allTemplates!.first(where: { ($0.code == code) } ){
//                    completion(_template)
//                    return;
//                }
//            }
        
            UIApplication.topVC()!.startAnimating(allowInteraction: false)
            OTTSdk.mediaCatalogManager.templateFor(code: code, onSuccess: { (template) in
                UIApplication.topVC()!.stopAnimating()
                completion(template)
            }, onFailure: { (error) in
                UIApplication.topVC()!.stopAnimating()
                 self.showAlert(withMessage: error.message)
                self.disableAllButtons(selectedButton: nil, disable: false)
                self.dismiss()
                completion(nil)
            })
        }
    }
    
    //MARK: - Custom Methods
    
    func showAlert(withMessage message : String = "Please try after some time"){
        if !self.isFromPlayer{
            self.dismiss()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: message)
        }
        self.delegate?.errorIn(partialRenderingView: self, errorMessage: message)
    }
    
    /// Only for info on the player
    func reloadFor(title : String, subTitle : String, imageUrl  : String, description  : String, isFromPlayer : Bool = false, subTitle1 : String, cast : String, status : String, statusElementSubtype : String) {
        self.reset()
        self.initViews()
        self.prHeader = PRHeader()
        self.prHeader.title = title
        self.prHeader.subTitle = subTitle
        self.prHeader.subTitle1 = subTitle1
        self.prHeader.imageUrl = imageUrl
        self.prHeader.status = status
        self.prHeader.statusElementSubtype = statusElementSubtype
        self.tableContent.removeAll()
        self.tableContent.append(self.prHeader)
        self.isFromPlayer = isFromPlayer
        
        if description.count > 0{
            let prText = PRText.init(prElementSubtype: .description, data: description)
            self.tableContent.append(prText)
        }
        if cast.count > 0 {
            let prText = PRText.init(prElementSubtype: .cast, data: cast)
            self.tableContent.append(prText)
        }
        AppDelegate.getDelegate().isPartialViewLoaded = true
        reloadDataWithFrameUpdate()
        AppDelegate.getDelegate().window?.addSubview(self)
    }

    func reloadFor(card : Card, content : Any?, showOnlyRecordOptions : Bool = false, showInfoOnly : Bool = false, partialRenderingViewDelegate : PartialRenderingViewDelegate?, isFromPlayer : Bool = false){
        self.reset()
        self.card = card
        self.content = content
        self.showInfoOnly = showInfoOnly
        self.delegate = partialRenderingViewDelegate
        self.isFromPlayer = isFromPlayer
        AppDelegate.getDelegate().window?.addSubview(self)
        self.showOnlyRecordOptions = showOnlyRecordOptions
        if showOnlyRecordOptions == true{
            // Player -> Recording
            if let recordingForm = (card.target.pageAttributes?["recordingForm"] as? String), recordingForm.count > 0{
                self.getRecordingForm(recordingForm, nil)
            }
        }
        else{
            //
            self.getTemplateFor(code: card.template) { (templateResponse) in
                if templateResponse != nil{
                    self.resetDataForTemplate(template: templateResponse!)
                }
                else{
                    //TODO: - Show Error as we haven't any template to show
                    printYLog(#function , "  #line: ", #line , "  error:  we haven't any template to show")
                }
            }
        }
        
    }
    
    func disableAllButtons(selectedButton : UIButton?, disable : Bool = false){
        if disable == true{
            for button in self.prUIButtons{
                if button.titleLabel?.text?.lowercased().contains("record") == false{
                    button.titleLabel?.textColor = UIColor.white
                }
                button.isUserInteractionEnabled = false
                if button == selectedButton{
                    button.backgroundColor = UIColor.init(hexString: "525260")
                }
                else{
                    button.titleLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
                    button.backgroundColor = UIColor.init(hexString: "41414e")
                }
            }
        }
        else{
            for (index,button) in self.prUIButtons.enumerated(){
                button.isUserInteractionEnabled = true
                if button.titleLabel?.text?.lowercased().contains("record") == false{
                    button.titleLabel?.textColor = UIColor.white
                }
                if index == 0{
                    button.backgroundColor =  AppTheme.instance.currentTheme.themeColor
                }
                else{
                    button.backgroundColor =  UIColor.init(hexString: "41414e")
                }
            }
        }
    }
    
    fileprivate func getRecordingForm(_ code: String, _ button: UIButton?) {
        UIApplication.topVC()!.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.getRecordingForm(code: code, path: self.card!.target.path, onSuccess: { (recordingFormResponse) in
            UIApplication.topVC()!.stopAnimating()
            self.recordingView = PRRecordOptionsView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 200))
            let info = self.recordingView!.resetUI(for: recordingFormResponse)
            self.recordingView!.frame.size.height = info.height
            if info.canShow{
                AppDelegate.getDelegate().isPartialViewLoaded = true
                self.recordingView!.card = self.card
                self.recordingView!.delegate = self
                if self.tableContent.count == 0{
                    self.tableContent.append(self.recordingView!)
                    self.tableView.reloadData()
                }
                else{
                    self.tableContent.append(self.recordingView!)
                    self.tableView.insertRows(at: [IndexPath.init(row: self.tableContent.count - 1, section: 0)], with: UITableView.RowAnimation.none)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(50)) {
                        self.disableAllButtons(selectedButton: button, disable: true)
                    }
                }
            }
            else{
                self.showAlert()

            }
        }) { (error) in
            UIApplication.topVC()!.stopAnimating()
            self.showAlert(withMessage: error.message)
            self.disableAllButtons(selectedButton: nil, disable: false)
            self.dismiss()
            //TODO: - Handle error case when there is an issue with fetching record options
        }
    }
    
    @objc func buttonTap(button : UIButton) {

        if let templateElement = self.prButtons.first(where: { ($0.id == button.tag) } ){
            
            if (templateElement.elementSubtype == "subscribe") || (templateElement.elementSubtype == "record_upgrade")  {
                let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
                self.showAlert(withMessage: alertMessage)
            }
            else if (templateElement.elementSubtype == "addonsubscribe") {
                let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
                self.showAlert(withMessage: alertMessage)
                return
            }
            else if templateElement.elementSubtype == "form-field"{
                
                switch templateElement.elementCode.lowercased(){
                case "record", "record_upgrade" , "delete_record" , "stop_record":
                    self.getRecordingForm(templateElement.target, button)
                    break
                case "expiry":
                    let alertMessage = "It seems you purchased an existing package in other Device, To update package please login in same device and upgrade !!!"
                        self.showAlert(withMessage: alertMessage)
                    break
                default :
                    self.showAlert(withMessage: "Unable to handle elementCode \(templateElement.elementCode).")
                    break
                }
            }
            else{
                self.delegate?.didSelected(card: self.card, content: self.content, templateElement: templateElement)
                self.dismiss()
            }
            printYLog(templateElement.data + " : " + String(button.tag))
        }
        else{
            printYLog("No button for tag : \(button.tag)")
            dismiss()
        }
    }
    
    func reset(){
        self.card = nil
        self.prButtons = [TemplateElement]()
        self.prHeader = PRHeader.init()
        self.tableContent.removeAll()
        self.tableView.reloadData()
        self.templateData = nil
        
        self.showInfoOnly = false
        self.showOnlyRecordOptions = false
        self.isFromPlayer = false
    }
    
    func resetDataForTemplate(template : TemplateResponse){
        if let code = card?.template{
            UIApplication.topVC()!.startAnimating(allowInteraction: false)
            OTTSdk.mediaCatalogManager.templateDataFor(template_code: code, path: card!.target.path , onSuccess: { (templateData) in
                UIApplication.topVC()!.stopAnimating()
                self.fill(templateData: templateData , in: template)
            }) { (error) in
                UIApplication.topVC()!.stopAnimating()
                self.showAlert(withMessage: error.message)
                self.dismiss()
            }
        }
        else{
            // Shouldn't reach here
            printYLog(#function , "  #line: ", #line , "  error:  no template code")
        }
    }
    
    func fill(templateData : TemplateData, in template : TemplateResponse){
        self.templateData = templateData
        if template.code != templateData.templateCode{
            // Shouldn't reach here. Ignoring as in worst case we will have some data to show
            printYLog(#function , "  #line: ", #line , "  error:  template Codes are not matching")
        }
        
        
         //TODO:- update the template values
        let prefix = "key:"
        
        for row in template.rows{
            for templateElement in row.templateElements{
                let copy = Mirror(reflecting: templateElement)
                for child in copy.children.makeIterator() {
                    if let keyValue = child.value as? String, keyValue.hasPrefix(prefix){
                        let key = keyValue.suffix(keyValue.count - prefix.count)
                        var finalyKey = key
                        if key == "description"{
                            finalyKey = "description_"
                        }
                        
                        var value : Any! = "#someRandomValueWhichDoesNotHaveValue"
                        if let _value = templateData.data.safeValueForKey(key: String(finalyKey)){
                            value = _value
                        }
                        else{
                            if let _value = templateData.data.rawData[String(finalyKey)]{
                                value = _value
                            }
                        }
                        

                        if ((value as? String) != nil){
                            templateElement.setValue(value, forKey: child.label!)
                        }
                        else if ((value as? Bool) != nil){
                            templateElement.setValue(String(value as! Bool), forKey: child.label!)
                            
                        }
                        else if ((value as? Float) != nil){
                            templateElement.setValue(String(value as! Float), forKey: child.label!)
                        }
                        else if ((value as? NSNumber) != nil){
                            templateElement.setValue((value as! NSNumber).stringValue, forKey: child.label!)
                        }
                        else{
                            printYLog((child.value as! String) + " ----  to ---- ---------------" )
                        }
                    }
                }
            }
        }
        AppDelegate.getDelegate().isPartialViewLoaded = true
        self.updateTableContentArrayFor(template: template)
        reloadDataWithFrameUpdate()
    }
    
    func reloadDataWithFrameUpdate(){
        CATransaction.begin()
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.layoutIfNeeded()
        CATransaction.commit()
        self.adjustTableFrame()
        
    }
    
    func updateTableContentArrayFor(template : TemplateResponse){
        // Header
        
        self.tableContent.removeAll()
        self.tableView.reloadData()
        
        /*
         Line 1: Title    {name}
         
         Line 2: Channel Name {subtitle}
         
         Line 3: Timing with details {subtitle1}
         
         Line 4: TV-PG  {subtitle2} {subtitle3}  {subtitle4}
         
         name: "Murder, She Wrote"
         subtitle: "Hallmark Movies & Mysteries
         subtitle1: "Sun, Jul 19 | 11:30 AM - 12:30 PM"
         
         subtitle2: "Repeat "
         subtitle3: "| S12 Ep257"
         
         subtitle4: " | TVPG"
         
         */
        var headerFound = false
        var subtitle2 = ""
        var subtitle3 = ""
        var subtitle4 = ""
        for row in template.rows{
            if row.rowDataType == "content"{
                for templateElement in row.templateElements{
                    if Bool(templateElement.displayCondition) ?? false{
                        //print ("templateElement.elementSubtype : \(templateElement.elementSubtype)")
                        //print ("templateElement.elementCode : \(templateElement.elementCode)")
                        if templateElement.elementType == "image"{
                            headerFound = true
                            prHeader.imageUrl = templateElement.data
                        }
                        if templateElement.elementSubtype == "title"{
                            headerFound = true
                            prHeader.title = templateElement.data
                        }
                        else if templateElement.elementSubtype == "subtitle"{
                            if templateElement.elementCode == "subtitle"{
                                headerFound = true
                                prHeader.subTitle = templateElement.data
                            }
                            else if templateElement.elementCode == "subtitle1" {
                                prHeader.subTitle1 = templateElement.data
                            }
                            else if templateElement.elementCode == "subtitle2" {
                                subtitle2 = templateElement.data
                            }
                            else if templateElement.elementCode == "subtitle3" {
                                subtitle3 = templateElement.data
                            }
                            else if templateElement.elementCode == "subtitle4" {
                                subtitle4 = templateElement.data
                            }
                        }
                        else if (templateElement.elementSubtype == "expires") || (templateElement.elementSubtype == "expires_day") || (templateElement.elementSubtype == "expires_today") || (templateElement.elementSubtype == "available_soon_label") || (templateElement.elementSubtype == "expiry") || (templateElement.elementSubtype == "expiring_soon") || (templateElement.elementSubtype == "expires_hours") || (templateElement.elementSubtype == "expires_minutes") || (templateElement.elementSubtype == "expiry_time") || (templateElement.elementSubtype == "availableUntil") {
                            headerFound = true
                            /* if (templateElement.elementSubtype == "expiry_time") {
                             let availableDateText = "\(Date().getFullDate("\(templateElement.data)", inFormat: AppDelegate.getDelegate().availableUntilDateFormat))"
                             prHeader.status = "\(AppDelegate.getDelegate().availableUntilText) \(availableDateText)"
                             }
                             else {
                             prHeader.status = templateElement.data
                             }*/
                            prHeader.status = templateElement.data
                            prHeader.statusElementSubtype = templateElement.elementSubtype
                        }
                        
                        // Text
                        if ((templateElement.elementSubtype == "description") || (templateElement.elementSubtype == "description_upgrade") || (templateElement.elementSubtype == "description_subscribe")) && (templateElement.data.count > 0){
                            let prText = PRText.init(prElementSubtype: .description, data: templateElement.data)
                            self.tableContent.append(prText)
                        }
                        else if (templateElement.elementSubtype == "cast") && (templateElement.data.count > 0) {
                            let prText = PRText.init(prElementSubtype: .cast, data: templateElement.data)
                            self.tableContent.append(prText)
                        }
                        else if (templateElement.elementSubtype == "available") || (templateElement.elementSubtype == "available_record") || (templateElement.elementSubtype == "streamnotavailable"){
                            self.tableContent.append(templateElement)
                        }
                    }
                }
            }
        }
        
        // Header
        let subTitlesRow = subtitle2 + subtitle3 + subtitle4
        prHeader.subTitle2 = subTitlesRow
        if headerFound{
            if self.tableContent.count > 0{
                self.tableContent.insert(prHeader, at: 0)
            }
            else{
                self.tableContent.append(prHeader)
            }
        }
        
        //subTitlesRow
        //let subTitlesRow = subtitle2 + subtitle3 + subtitle4
        //prHeader.subTitle2 = subTitlesRow
        /* if subTitlesRow.count > 0{
         let prText = PRText.init(prElementSubtype: .description, data: subTitlesRow)
         if headerFound{
         self.tableContent.insert(prText, at: 1)
         }
         else{
         self.tableContent.append(prText)
         }
         }*/
        
        // Buttons and Text
        prButtons.removeAll()
        if showInfoOnly == false{
            for row in template.rows{
                // Buttons
                if (row.rowDataType == "button"){
                    //                prButtons.append(contentsOf: row.templateElements)
                    for button in row.templateElements{
                        if Bool(button.displayCondition) ?? false{
                            prButtons.append(button)
                        }
                    }
                }
            }
        }
        if prButtons.count > 0{
            self.tableContent.append(prButtons)
        }
        // not_available text has to be added from formdata if available.
        if let notAvailableText = self.templateData?.data.rawData["not_available"] as? String{
            if notAvailableText.count > 0{
                var templateElement = TemplateElement.init(["data":notAvailableText])
                templateElement.elementCode = "not_available"
                self.tableContent.append(templateElement)
            }
        }
    }
    
    
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    fileprivate func adjustTableFrame() {
        let bottomPadding : CGFloat = (productType.iPad ? 30 : 5)
        if let player = playerVC, (player.view.isHidden == false) {
            if player.view.frame.size.height > AppDelegate.getDelegate().window!.bounds.size.height{
            }
            else{
//                bottomPadding = bottomPadding + (AppDelegate.getDelegate().window!.bounds.size.height - player.view.frame.origin.y       )
            }
        }
        
        self.layoutIfNeeded()
        self.transparentView!.frame = AppDelegate.getDelegate().window!.bounds // Player has different orientation
        self.frame = AppDelegate.getDelegate().window!.bounds
        let screenFrame = AppDelegate.getDelegate().window!.bounds
        let maxHeight = (self.frame.size.height )
        var tableHeight = self.tableView.contentSize.height
        self.tableView.isScrollEnabled = false
        if (self.tableView.contentSize.height > maxHeight){
            tableHeight = maxHeight
            self.tableView.isScrollEnabled = true
        }
        tableHeight = (tableHeight != 0) ? (tableHeight + bottomPadding) : 0
        let tableFrame = CGRect.init(x: 0, y: screenFrame.size.height - tableHeight, width: screenFrame.size.width, height: tableHeight)
        self.tableView.frame = tableFrame
//        print("#PRV : frame : \(self.tableView.frame)")
    }
    
    //MARK: - PRRecordOptionsViewDelegate
    func record(confirm : Bool){
        self.delegate?.record(confirm: confirm, content: self.content)
        self.disableAllButtons(selectedButton: nil, disable: false)
        var recordingIndex = -1
        for (index,content) in tableContent.enumerated(){
            if let _content = (content as? PRRecordOptionsView), _content == self.recordingView{
                recordingIndex = index
            }
        }
        if recordingIndex != -1{
            self.tableContent.remove(at: recordingIndex)
            self.tableView.deleteRows(at: [IndexPath.init(row: recordingIndex, section: 0)], with: UITableView.RowAnimation.fade)
        }
        if confirm{
            if self.showOnlyRecordOptions == false{
            // Reload
                reloadFor(card : self.card!, content: self.content, partialRenderingViewDelegate: self.delegate)
            }
            
            // Update MyRecordings Tab and close the PartialRendering if it is presented from itself
            NotificationCenter.default.post(name: PartialRenderingView.instance.recordNotificationName, object: ["content":self.content])
            if let contentViewController = PartialRenderingView.instance.delegate as? ContentViewController{
                if contentViewController.targetedMenu == "my_recordings"{
                    self.dismiss()
                }
            }
           /* else if let episodeSeriesViewController = PartialRenderingView.instance.delegate as? EpisodeSeriesDetailsController {
                if episodeSeriesViewController.contentType == "epgseriesdetails" || episodeSeriesViewController.contentType == "tvshowdetails" {
                    self.dismiss()
                }
            }
            else if let listViewController = PartialRenderingView.instance.delegate as? ListViewController {
                if listViewController.isFromEpgSeriesDetails {
                    self.dismiss()
                }
            }*/
        }
    }
    
    //MARK: - PRHeaderTableViewCellDelegate Methods
    func closeButtonTap(){
        dismiss()
    }
    
    func dismiss(){
        AppDelegate.getDelegate().isPartialViewLoaded = false
        self.removeFromSuperview()
    }
    
    //MARK: - TableView Delegate and DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = tableContent[indexPath.row]
        if content is PRHeader {
            
            let prHeader = content as! PRHeader
            let cell = tableView.dequeueReusableCell(withIdentifier: PRHeaderTableViewCell.identifier) as? PRHeaderTableViewCell
            cell?.isFromPlayerPage = self.isFromPlayer
            cell?.contentImageView?.sd_setImage(with: URL(string: prHeader.imageUrl) , placeholderImage: UIImage.init(named: "Default-TVShows"))
            cell?.delegate = self
            cell?.titleLabel.text = prHeader.title
            cell?.subtitleLabel.text = prHeader.subTitle
            cell?.subtitle1Label.text = prHeader.subTitle1
            cell?.subtitle2Label.text = prHeader.subTitle2
            cell?.selectionStyle = .none
            if  self.isFromPlayer {
                 cell?.subtitleLabelTopConstraint?.constant = 6
                 cell?.subtitleLabel1TopConstraint?.constant = 6
                 cell?.subtitleLabel2HeightConstraint?.constant = 3
            }
            else {
                let val = productType.iPad ? 8 : 3
                cell?.subtitleLabelTopConstraint?.constant = CGFloat(val)
                cell?.subtitleLabel1TopConstraint?.constant = CGFloat(val)
                cell?.subtitleLabel2TopConstraint?.constant = CGFloat(val)
                cell?.subtitleLabel2HeightConstraint?.constant = 14
            }
            cell?.setStatus(status: prHeader.status, statusElementSubtype: prHeader.statusElementSubtype)
            headerCell = cell
            self.bitrate = _bitrate
            return cell!
        }
        else if content is PRText {
            let prText = content as! PRText
            let cell = self.getFreshCell(for: self.tableView)
            
            if prText.prElementSubtype == .cast{
                let text = "Cast & Crew:"
                let castAttributedString = NSMutableAttributedString(string: text)
                castAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.6), range: NSRange(location:0,length:text.count))
                castAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.ottRegularFont(withSize: 12) , range: NSRange(location:0,length:text.count))
                
                let data = prText.data
                let dataAttributedString = NSMutableAttributedString(string: data)
                dataAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.9), range: NSRange(location:0,length:data.count))
                dataAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.ottRegularFont(withSize: 12) , range: NSRange(location:0,length:data.count))
                
                let result = NSMutableAttributedString()
                result.append(castAttributedString)
                result.append(NSMutableAttributedString(string: "\n"))
                result.append(dataAttributedString)
                cell.textLabel?.attributedText = result
                
            }
            else{
                cell.textLabel?.text = prText.data
            }
            
            return cell
        }
        else if content is TemplateElement {
            let templateElement = content as! TemplateElement
            let cell = tableView.dequeueReusableCell(withIdentifier: PRAvailableTableViewCell.identifier) as? PRAvailableTableViewCell
            cell?.titleLabel.text = templateElement.data
            if templateElement.elementCode == "not_available" {
                cell?.infoImageView.image = UIImage.init(named: "info_icon_green")
                cell?.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
                cell?.titleContentView.layer.borderColor = AppTheme.instance.currentTheme.themeColor.cgColor
                cell?.titleContentView.backgroundColor = UIColor.init(hexString: "18181f")
            }
            else{
                cell?.infoImageView.image = UIImage.init(named: "player-info")
                cell?.titleLabel.textColor = UIColor.init(hexString: "ffffff")
                cell?.titleContentView.layer.borderColor = UIColor.init(hexString: "3e3e4a").cgColor
                cell?.titleContentView.backgroundColor = UIColor.init(hexString: "2D2E3B")
            }
            cell?.selectionStyle = .none
            
            self.tableView.estimatedRowHeight = 44
            self.tableView.rowHeight = UITableView.automaticDimension
            
            return cell!
        }
        else if content is [TemplateElement] {
            //buttons
            let cell = self.getFreshCell(for: self.tableView)
            
            let templateElements = content as! [TemplateElement]
          
            var maxButtonsAllowed = 3

            if templateElements.count == 3{
                var tempRows = 0
                let tempAvilableWidth = Int((AppDelegate.getDelegate().window?.screen.bounds.size.width)!) - (templateElements.count * padding) - (2 * EdgesSpacing)
                for (_,templateElement) in templateElements.enumerated(){
                    var buttonText = templateElement.data
                    if (templateElement.elementSubtype == "addonsubscribe") {
                        buttonText = buttonText + ".............."
                    }
                    let size = buttonText.size(withAttributes:[.font: UIFont.ottRegularFont(withSize: 12)])
                    
                    if Int(size.width) > (tempAvilableWidth / templateElements.count) {
                        tempRows = tempRows + 1
                    }
                }
                if (tempRows + 1 == 2){
                    maxButtonsAllowed = 2
                }
            }
                                 
           
            var availableWidth = (Int(self.tableView.frame.size.width) - (padding * (((templateElements.count > maxButtonsAllowed ? maxButtonsAllowed : templateElements.count) - 2 ) + 1)) -  (2 * EdgesSpacing))
                        
            var x = EdgesSpacing
            var y = 5
            var addonIndex = -1
            var tempYY = 0
//            let width : Int =  availableWidth / templateElements.count
            self.prUIButtons.removeAll()
            for (index,templateElement) in templateElements.enumerated(){
                var width = availableWidth / templateElements.count
                var height = (productType.iPad ? 50 : 35)
                if (templateElement.elementSubtype == "addonsubscribe") {
                    width = (productType.iPhone ? (availableWidth) : (availableWidth / 2))
                    addonIndex = index
                    height = (productType.iPad ? 50 : 45)
                }
                else {
                    if addonIndex >= 0 {
                        if productType.iPhone {
                            if templateElements.count == 2 {
                                width = (availableWidth / ((templateElements.count) - 1)) + EdgesSpacing
                            }
                            else {
                                width = (availableWidth / ((templateElements.count) - 1))
                            }
                        }
                        else {
                            width = ((availableWidth/2) / ((templateElements.count) - 1))
                        }
                    }
                }
               
                let rowNumber = (index / maxButtonsAllowed) + 1
                
                if templateElements.count > maxButtonsAllowed{
                   
                    let rowNumber = (index / maxButtonsAllowed) + 1
                    let remainingButtons = (templateElements.count - ((rowNumber - 1) * maxButtonsAllowed))
                    let buttonsInRow = (remainingButtons > maxButtonsAllowed) ?  maxButtonsAllowed : remainingButtons
                     availableWidth = (Int(self.tableView.frame.size.width) - (padding * (buttonsInRow - 1)) -  (2 * EdgesSpacing))
                    width = availableWidth / buttonsInRow
                }
                if (templateElement.elementSubtype == "addonsubscribe") {
                    if templateElements.count == 1 {
                        width = availableWidth
                    }
                    else {
                        width = (productType.iPad ? (availableWidth / 2) : (availableWidth + EdgesSpacing))
                    }
                }

//                let button = UIButton.buttonWithFrame(withXposition: CGFloat(x), withYposition: 5, withWidth: CGFloat(width), withHeight: 35, andElementData: , withSize: 14, isRowBtnType: false)
                
                let button = UIButton.init()
                y = (rowNumber - 1) * (height + 10)
                
                if x > availableWidth - 30 {
                    x = EdgesSpacing
                    if (addonIndex >= 0 && productType.iPhone) {
                        y = y + (height + 10)
                    }
                }
                if (addonIndex >= 0 && addonIndex < index && productType.iPhone) {
                    tempYY = 10
                    if index > 1 {
                        y = y + (height + 10)
                    }
                }
                if index % maxButtonsAllowed == 0{
                    x = EdgesSpacing
                }
                button.frame = CGRect.init(x: x, y: (y + tempYY), width: width, height: height)
                button.tag = templateElement.id
                
                var shouldDisable = false
                if let _shouldDisable = self.templateData?.data.rawData["disable_\(templateElement.elementCode)"] as? String{
                    if _shouldDisable.lowercased() == "true" {
                        shouldDisable = true
                    }
                }
                
                if templateElement.elementCode == "record"{
                    if shouldDisable {
                        button.setTitle(" • \(templateElement.data)", for: UIControl.State.normal)
                    }
                    else {
                        self.addDotToButtonTitle(button: button, title:  templateElement.data)
                    }
                }
                else{
                    button.setTitle(templateElement.data, for: UIControl.State.normal)
                }
                if index == 0{
                    button.backgroundColor = AppTheme.instance.currentTheme.themeColor
                    button.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
                }
                else{
                    button.backgroundColor = UIColor.init(hexString: "41414e")
                    button.setTitleColor(AppTheme.instance.currentTheme.navigationBarTextColor, for: .normal)
                }
                self.prUIButtons.append(button)
                button.titleLabel?.font = UIFont.ottRegularFont(withSize: 12)
                button.addTarget(self, action: #selector(buttonTap(button:)), for: UIControl.Event.touchUpInside)
                button.isEnabled = true
               
                if shouldDisable == true {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.init(hexString: "41414e")
                    button.setTitleColor(UIColor.whiteAlpha50, for: .normal)
                }
                    
               
                cell.contentView.addSubview(button)
                x = Int(button.frame.origin.x + button.frame.size.width) + padding
                
                //Progressbar for resume button
                if let watchedValue =  self.templateData?.data.watchedPosition,  templateElement.elementSubtype.lowercased() == "resume"{
                    let progressView = UIProgressView.init(frame: CGRect.init(x: button.frame.origin.x, y: button.frame.origin.y + button.frame.size.height - 2, width: button.frame.size.width, height: 2))
                    progressView.progress = watchedValue
                    progressView.trackTintColor = UIColor.init(hexString: "545460")
                    progressView.progressTintColor = UIColor.init(hexString: "f93822")
                    cell.contentView.addSubview(progressView)
                }
            }
            return cell
        }
        else if let recordOptionsView = content as? PRRecordOptionsView{
            // Record options
            let cell = self.getFreshCell(for: self.tableView)
            cell.backgroundColor = UIColor.init(hexString: "1b1b26")
            cell.contentView.addSubview(recordOptionsView)
            return cell
        }
        else {
            let cell = self.getFreshCell(for: self.tableView)
            cell.contentView.backgroundColor = .red
            return cell
        }
    }
    
    func getFreshCell(for tableView : UITableView) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        cell?.textLabel?.text = ""
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.attributedText = nil
        cell?.textLabel?.font = UIFont.ottRegularFont(withSize: 12)
        cell?.textLabel?.textColor = UIColor.white.withAlphaComponent(0.9)
        cell?.backgroundView = nil
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        for view in cell?.contentView.subviews ?? []{
            if (view is UIButton) || (view is PRRecordOptionsView) || (view is UIProgressView){
                view.removeFromSuperview()
            }
        }
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        return cell!
        
    }
    
    func addDotToButtonTitle(button : UIButton, title : String){
        let text = "•"
        let dotAttributedString = NSMutableAttributedString(string: text)
        dotAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "ff4b4b"), range: NSRange(location:0,length:text.count))
        
        let textAttributedString = NSMutableAttributedString(string: title)
        textAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:title.count))
        textAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.ottRegularFont(withSize: 12) , range: NSRange(location:0,length:title.count))
        
        let result = NSMutableAttributedString()
        result.append(dotAttributedString)
        result.append(NSMutableAttributedString(string: " "))
        result.append(textAttributedString)
        
        button.setAttributedTitle(result, for: UIControl.State.normal)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = tableContent[indexPath.row]
        if content is PRHeader {
            var headerHeight = 0
            if self.isFromPlayer == true {
                headerHeight = (productType.iPad ? 119 : 78)
            }
            else {
                headerHeight = (productType.iPad ? 106 : 93)
                let imageWidth = (productType.iPad ? 190 : 125) + 45
                let fontVal = (productType.iPad ? 14 : 12)
                let font = UIFont.ottRegularFont(withSize: CGFloat(fontVal))
                let hh = getLabelHeight(labelText: prHeader.subTitle2, fontVal: font, labelWidth: imageWidth)
                if hh > 16 {
                    headerHeight = headerHeight + (hh - 16)
                }
                if prHeader.status != nil && prHeader.statusElementSubtype != nil {
                    headerHeight = headerHeight + 38
                }
            }
            return CGFloat(headerHeight)
        }
        else if content is PRText {
            tableView.rowHeight = UITableView.automaticDimension
            return UITableView.automaticDimension
        }
        else if content is TemplateElement {
            tableView.rowHeight = UITableView.automaticDimension
            return UITableView.automaticDimension
        }
        else if content is [TemplateElement]{
            if let buttons = content as? [TemplateElement]{
                var addonHeightDiff = 0
                var totalRows = 0
                if buttons.count > 3{
                    totalRows = buttons.count / 3
                    totalRows = (totalRows + 1)
                }
                else {
                    var tempRows = 0
                    let tempAvilableWidth = Int((AppDelegate.getDelegate().window?.screen.bounds.size.width)!) - (buttons.count * padding) - (2 * EdgesSpacing)
                    for (_,templateElement) in buttons.enumerated(){
                        var buttonText = templateElement.data
                        if (templateElement.elementSubtype == "addonsubscribe") {
                            if productType.iPad {
                                buttonText = buttonText + ".............."
                            }
                            else {
                                buttonText = buttonText + "......................."
                            }
                            addonHeightDiff = 10
                        }
                        let size = buttonText.size(withAttributes:[.font: UIFont.ottRegularFont(withSize: 12)])
                        if Int(size.width) > (tempAvilableWidth / buttons.count) {
                            tempRows = tempRows + 1
                        }
                    }
                    totalRows = tempRows + 1
                }
                                
                return (CGFloat((totalRows) * (productType.iPad ?  50 : 45))) + CGFloat(addonHeightDiff)
            }
            return 60
        }
        else if let recordOptionsView = content as? PRRecordOptionsView{
            return recordOptionsView.viewHeight
        }
        return 100
    }
    
    
    func getLabelHeight(labelText:String,fontVal:UIFont,labelWidth:Int) -> Int {
        let constraintRect = CGSize(width: (self.tableView.frame.width - CGFloat(labelWidth)), height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = labelText.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: fontVal], context: nil)
        return Int(boundingBox.height)
    }
    
}

