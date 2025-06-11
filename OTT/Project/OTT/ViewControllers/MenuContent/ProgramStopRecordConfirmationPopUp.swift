//
//  TVGuideDescPopUpViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 18/06/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol ProgramStopRecordConfirmationPopUpUpProtocol {
    func programStopRecordConfirmClicked(programObj:Card?, sectionIndex:Int, rowIndex:Int)
    func programStopRecordCancelClicked()
}

class ProgramStopRecordConfirmationPopUp: UIViewController {

    @IBOutlet weak var selectedProgramLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var watchNowBtn: UIButton!
    
    var programObj:Card?
    var delegate:ProgramStopRecordConfirmationPopUpUpProtocol! = nil
    var sectionIndex = 0
    var rowIndex = 0
    var titleStr = ""

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if programObj != nil {
            var content_type = ""
            for marker in programObj!.display.markers {
                if marker.markerType == .record || marker.markerType == .stoprecord {
                    let strArr = marker.value.components(separatedBy: "&")
                    if strArr.count > 2 {
                        content_type = strArr[0].components(separatedBy: "=")[1]
                    }
                }
            }
            if content_type == "3"{
                self.selectedProgramLbl.text = "‘\((self.programObj?.display.parentName)!)’ is being recorded. Do you want to stop?"
            }
            else if content_type == "2"{
                self.selectedProgramLbl.text = "‘\((self.programObj?.display.title)!)’ is being recorded. Do you want to stop?"
            }
            else{
                self.selectedProgramLbl.text = "‘\((self.programObj?.display.title)!)’ is scheduled for recording.\nDo you want to stop?"
            }
        } else {
            self.selectedProgramLbl.text = "‘\(titleStr)’ is scheduled for recording.\nDo you want to stop?"
        }
 
        
        
        // Do any additional setup after loading the view.
        cancelBtn.setTitle("cancel".localized, for: .normal)
        watchNowBtn.setTitle("Stop Recording".localized, for: .normal)
        
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.delegate.programStopRecordCancelClicked()
    }
    
    @IBAction func watchNowBtnClicked(_ sender: Any) {
        if programObj != nil {
            self.delegate.programStopRecordConfirmClicked(programObj: self.programObj, sectionIndex: self.sectionIndex, rowIndex: self.rowIndex)
        } else {
            self.delegate.programStopRecordConfirmClicked(programObj: nil, sectionIndex: self.sectionIndex, rowIndex: self.rowIndex)
        }
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
