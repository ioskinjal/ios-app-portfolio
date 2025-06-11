//
//  TVGuideDescPopUpViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 18/06/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol TVGuideDescPopUpProtocol {
    func tvGuideWatchNowClicked(programObj:Card)
    func tvGuideDescPopUpCancelled()
}

class TVGuideDescPopUpViewController: UIViewController {

    @IBOutlet weak var selectedProgramLbl: UILabel!
    @IBOutlet weak var selectedProgramDesc: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var watchNowBtn: UIButton!
    
    var programObj:Card?
    var delegate:TVGuideDescPopUpProtocol! = nil

    override func viewWillAppear(_ animated: Bool) {
        selectedProgramDesc.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedProgramDesc.isScrollEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.selectedProgramLbl.text = self.programObj?.display.title
        self.selectedProgramDesc.text = self.programObj?.display.subtitle2
        // Do any additional setup after loading the view.
        cancelBtn.setTitle("cancel".localized, for: .normal)
        watchNowBtn.setTitle("Watch Now".localized, for: .normal)
        
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.delegate.tvGuideDescPopUpCancelled()
    }
    
    @IBAction func watchNowBtnClicked(_ sender: Any) {
        self.delegate.tvGuideWatchNowClicked(programObj: self.programObj!)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.selectedProgramDesc.setContentOffset(CGPoint.zero, animated: false)
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
