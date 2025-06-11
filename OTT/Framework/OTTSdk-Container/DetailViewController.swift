//
//  DetailViewController.swift
//  OTTSdk-Container
//
//  Created by Muzaffar on 29/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ApiCallsDelegate {
    
    var info = [String : Any]()
    var logInfo : [String : Any]?
    let titleButton =  UIButton(type: .custom)
    
    var logKey : String{
        get{
            return titleButton.isSelected ? "attributedText" : "completeText"
        }
    }
    
    @IBOutlet weak var logTextView: UITextView!
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logTextView.text = ""
        ApiCalls.instance.delegate = self
        ApiCalls.instance.call(info: info)
    }
    
    //MARK:- methods
    
    func configureView() {
        
        let button1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(DetailViewController.shareText))
        self.navigationItem.rightBarButtonItem  = button1
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.logupdated(notification:)), name:  NSNotification.Name(rawValue: "logNotifcation"), object: nil)
        
        //TitleButton
        titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleButton.setTitle("Complete Log", for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.addTarget(self, action:  #selector(DetailViewController.logTypeChange), for: .touchUpInside)
        self.navigationItem.titleView = titleButton
        
    }
    
    
    func presentAlert(inputs : [String],data : [String]?, onSuccess : @escaping ([String])-> Void){
        
        let alertController = UIAlertController(title: "OTT", message: "Please provide input", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard let textFields = alertController.textFields else{
                return
            }
            var userInputs = [String]()
            for textField in textFields{
                userInputs.append(textField.text ?? "")
            }
            onSuccess(userInputs)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        for input in inputs{
            alertController.addTextField { (textField) in
                textField.clearButtonMode = UITextField.ViewMode.always
                if let text = data?[inputs.index(of: input)!]{
                    textField.text = text
                }
                textField.placeholder = input
            }
        }
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Log
    
    @objc func logTypeChange(button: UIButton) {
        button.isSelected = !button.isSelected
        if let attrib = logInfo?[logKey] as? NSMutableAttributedString{
            updateText(attrib: attrib)
        }
        button.setTitle(button.isSelected ? "Mini Log" : "Complete Log"  , for: .normal)
    }
    
    @objc func logupdated(notification : Notification)  {
        logInfo = (notification.object as? [String : Any])!
        if let attrib = logInfo?[logKey] as? NSMutableAttributedString{
            updateText(attrib: attrib)
        }
    }
    func updateText(attrib : NSMutableAttributedString)  {
        
        logTextView.attributedText = attrib
        let stringLength:Int = self.logTextView.text.count
        self.logTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
    
    
    @objc func shareText() {
        
        let shareItems = [logTextView.attributedText.string]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        // activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}

