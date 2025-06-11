//
//  TVGuideDescPopUpViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 18/06/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol ProgramRecordConfirmationPopUpProtocol {
    func programRecordConfirmClicked(programObj:Card?, selectedPrefButtonIndex:Int, sectionIndex:Int, rowIndex:Int)
    func programRecordCancelClicked()
}

class ProgramRecordConfirmationPopUp: UIViewController {

    @IBOutlet weak var chooseYourRecordingPrefLbl: UILabel!
    @IBOutlet weak var selectedProgramDesc: UITextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    @IBOutlet weak var selectedProgramLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var watchNowBtn: UIButton!
    
    @IBOutlet weak var button1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button4HeightConstraint: NSLayoutConstraint!
    
    var programObj:Card?
    var titleStr = ""
    var delegate:ProgramRecordConfirmationPopUpProtocol! = nil
    var sectionIndex = 0
    var rowIndex = 0
    var recordPrefButtonIndex = 0

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if programObj != nil {
            var optionsArr = [String]()
            for marker in programObj!.display.markers {
                if marker.markerType == .record || marker.markerType == .stoprecord {
                    optionsArr = marker.value.components(separatedBy: ",")
                }
            }
            var buttonIndex = 0
            for (index, option) in optionsArr.enumerated() {
                var content_type = ""
                let strArr = option.components(separatedBy: "&")
                if strArr.count > 2 {
                    content_type = strArr[0].components(separatedBy: "=")[1]
                }
                var tempString = ""
                if content_type == "1"{
                   tempString = "Record only this episode"
                    self.selectedProgramLbl.text = (self.programObj?.display.title)!
                    buttonIndex = buttonIndex + 1
                }
                else if content_type == "2"{
                    tempString = "Record the complete show"
                    self.selectedProgramLbl.text = (self.programObj?.display.title)!
                    buttonIndex = buttonIndex + 1
                }
                else if content_type == "4"{
                    tempString = "Record every day at this time \n(\((self.programObj?.display.subtitle1)!))"
                    self.selectedProgramLbl.text = (self.programObj?.display.title)!
                    buttonIndex = buttonIndex + 1
                }
                else if content_type == "3"{
                    tempString = "Record All the upcoming programs"
                    self.selectedProgramLbl.text = (self.programObj?.display.parentName)!
                    buttonIndex = buttonIndex + 1
                }
                self.selectedProgramDesc.text = self.programObj?.display.subtitle2
                if index == 0{
                    button1.setTitle(tempString, for: .normal)
                }
                else if index == 1{
                    button2.setTitle(tempString, for: .normal)
                }
                else if index == 2{
                    button3.setTitle(tempString, for: .normal)
                }
                else if index == 3{
                    button4.setTitle(tempString, for: .normal)
                }
                if (button1.titleLabel?.text) != nil{
                    button1HeightConstraint.constant = (content_type == "3" ? 50 : 27)
                    button1.isHidden = false
                }
                else{
                    button1HeightConstraint.constant = 0
                    button1.isHidden = true
                }
                if (button2.titleLabel?.text) != nil{
                    button2HeightConstraint.constant = (content_type == "3" ? 50 : 27)
                    button2.isHidden = false
                }
                else{
                    button2HeightConstraint.constant = 0
                    button2.isHidden = true
                }
                
                if (button3.titleLabel?.text) != nil{
                    button3HeightConstraint.constant = (content_type == "3" ? 50 : 27)
                    button3.isHidden = false
                }
                else{
                    button3HeightConstraint.constant = 0
                    button3.isHidden = true
                }
                
                if (button4.titleLabel?.text) != nil{
                    button4HeightConstraint.constant = (content_type == "3" ? 50 : 27)
                    button4.isHidden = false
                }
                else{
                    button4HeightConstraint.constant = 0
                    button4.isHidden = true
                }

            }
            var buttonHeight:CGFloat = 0.0
            buttonHeight = buttonHeight + button1HeightConstraint.constant
            buttonHeight = buttonHeight + button2HeightConstraint.constant
            buttonHeight = buttonHeight + button3HeightConstraint.constant
            buttonHeight = buttonHeight + button4HeightConstraint.constant
            self.view.frame.size.height = 227.0 + buttonHeight
        } else {
            self.selectedProgramLbl.text = "All the upcoming programs of ‘\(titleStr)’ will be recorded."
        }
        // Do any additional setup after loading the view.
        cancelBtn.setTitle("cancel".localized, for: .normal)
        watchNowBtn.setTitle("Confirm".localized, for: .normal)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.delegate.programRecordCancelClicked()
    }
    
    @IBAction func watchNowBtnClicked(_ sender: Any) {
        if programObj != nil {
            self.delegate.programRecordConfirmClicked(programObj: self.programObj!, selectedPrefButtonIndex: self.recordPrefButtonIndex, sectionIndex: self.sectionIndex, rowIndex: self.rowIndex)
        } else {
            self.delegate.programRecordConfirmClicked(programObj: nil, selectedPrefButtonIndex: self.recordPrefButtonIndex, sectionIndex: self.sectionIndex, rowIndex: self.rowIndex)
        }
    }
    
    @IBAction func recordPreferenceClicked(_ sender: UIButton) {
        self.disableAllThePreferenceBtn()
        sender.setImage(UIImage(named: "Record_check_selected"), for: UIControl.State())
        recordPrefButtonIndex = sender.tag - 1
    }
    
    func disableAllThePreferenceBtn() {
        self.button1.setImage(UIImage(named: "Record_circle_green_icon"), for: UIControl.State())
        self.button2.setImage(UIImage(named: "Record_circle_green_icon"), for: UIControl.State())
        self.button3.setImage(UIImage(named: "Record_circle_green_icon"), for: UIControl.State())
        self.button4.setImage(UIImage(named: "Record_circle_green_icon"), for: UIControl.State())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
