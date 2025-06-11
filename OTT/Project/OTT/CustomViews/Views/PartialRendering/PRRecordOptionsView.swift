//
//  PRRecordOptionsView.swift
//  OTT
//
//  Created by Muzaffar Ali on 26/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk


@objc protocol PRRecordOptionsViewDelegate {
    @objc func record(confirm : Bool)
}

class PRRecordOptionsView: UIView, PRRecordRadioButtonViewDelegate {
    var formResponse : RecordingFormResponse?
    var radioButtons = [PRRecordRadioButtonView]()
    var buttons = [UIButton]()
    var viewHeight : CGFloat = 200
    weak var delegate : PRRecordOptionsViewDelegate?
    var card : Card?

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.init(hexString: "1b1b26")
    }
    
    func resetUI(for recordingFormResponse : RecordingFormResponse) -> (height : CGFloat, labelElement : FormElement?, canShow : Bool ){
        var labelElement : FormElement?
        self.formResponse = recordingFormResponse
        let buttonHeight  : CGFloat = 35
        var y : CGFloat = 20
        let yPadding : CGFloat = 10
        var canShow = false
        
        for formElement in formResponse?.elements ?? []{
            if formElement.fieldType ==  "label"{
                canShow = true
                labelElement = formElement
                let label = UILabel.init(frame: CGRect.init(x: 15, y: y - 20, width: self.frame.size.width - 30, height: 45))
                label.font = UIFont.ottMediumFont(withSize: 16)
                label.textColor = .white
                label.text = formElement.data
                label.numberOfLines = 0
                y = label.frame.origin.y + label.frame.size.height + yPadding
                self.addSubview(label)
            }
            else if formElement.fieldType ==  "radio-button"{
                canShow = true
                let radioButton = PRRecordRadioButtonView.init(frame: CGRect.init(x: 15, y: 10, width: self.frame.size.width - 30, height: 40))
                radioButton.updateUI(element: formElement)
                radioButton.delegate = self
                if radioButtons.count == 0{
                    radioButton.isSelected = true
                }
                radioButtons.append(radioButton)
            }
            else if (formElement.fieldType ==  "submit") || (formElement.fieldType ==  "cancel"){
                canShow = true
                let button = UIButton.init(frame: CGRect.init(x: 15, y: 10, width: 90, height: buttonHeight))
                button.setTitle(formElement.data, for: .normal)
                button.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
                button.tag = formElement.id
                button.addTarget(self, action: #selector(buttonTap(button:)) , for: .touchUpInside)
                buttons.append(button)
            }
        }
        var radioButtonXValue : CGFloat = 15
        var radioButtonYValue = y
        var radioButtonHeight : CGFloat = 40
        for radioButton in radioButtons{
            self.addSubview(radioButton)
            radioButton.frame.origin.x = radioButtonXValue
            if UIDevice.current.orientation.isLandscape == true{
                radioButton.frame.origin.y = radioButtonYValue
                radioButton.label.numberOfLines = 1
                radioButton.label.font = UIFont.ottRegularFont(withSize: 14)
                radioButton.label.sizeToFit()
                radioButton.frame.size.width = radioButton.label.frame.origin.x + radioButton.label.frame.size.width + 10
                if radioButtonXValue + radioButton.frame.size.width > AppDelegate.getDelegate().window!.frame.size.width {
                    radioButtonXValue = 15
                    radioButtonYValue = radioButtonYValue + radioButtonHeight + 20
                    radioButton.frame.origin.x = radioButtonXValue
                    radioButton.frame.origin.y = radioButtonYValue
                }
                else {
                    radioButtonXValue = radioButton.frame.origin.x + radioButton.frame.size.width + 20
                }
                radioButtonHeight = radioButton.frame.size.height
            }
            else{
                radioButton.frame.origin.y = y
                y = radioButton.frame.origin.y + radioButton.frame.size.height + yPadding
            }
        }
        if UIDevice.current.orientation.isLandscape == true{
            y = radioButtonYValue + radioButtonHeight  + yPadding
        }
        y = y + 15
        var x : CGFloat = 15
        let xPadding : CGFloat = 10
        for (index,button) in buttons.enumerated(){
            button.frame.origin.x = x
            button.frame.origin.y = y
            button.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
            if index == 0{
                button.backgroundColor = AppTheme.instance.currentTheme.themeColor
            }
            else{
                button.backgroundColor = UIColor.clear
                button.layer.borderColor = UIColor.init(hexString: "41414e").cgColor
                button.layer.borderWidth = 1.0
            }
            button.layer.cornerRadius = 2.0
            self.addSubview(button)
            x = button.frame.origin.x + button.frame.size.width + xPadding
        }
        
        if buttons.count > 0{
            y = y + buttonHeight + 20
        }

        self.viewHeight = y
        return (y,labelElement,canShow)
    }
    
    @objc func buttonTap(button : UIButton){
        
        if let element = formResponse?.elements.first(where: { ($0.id == button.tag) } ){
            if element.fieldType == "submit"{
                if let prRecordRadioButtonView = radioButtons.first(where: { ($0.isSelected == true) } ){
                    OTTSdk.mediaCatalogManager.submitRecordingForm(code: element.formCode, path: self.card!.target.path, elementCode: prRecordRadioButtonView.formElement!.elementCode, value: prRecordRadioButtonView.formElement!.value, onSuccess: { (successMessage) in
                        self.delegate?.record(confirm: true)
                    }) { (error) in
                        AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: error.message)
                        self.delegate?.record(confirm: false)
                    }
                }
                else{
                    printYLog("--------------------------------no prRecordRadioButtonView")
                }
            }
            else if (element.fieldType ==  "cancel"){
                self.delegate?.record(confirm: false)
            }
        }
    }
    
    // MARK: - PRRecordRadioButtonViewDelegate
    func didSelected(radioButtonView : PRRecordRadioButtonView){
        for radioButton in radioButtons{
            radioButton.isSelected = (radioButton.formElement?.id == radioButtonView.formElement?.id)
        }
    }
}

@objc protocol PRRecordRadioButtonViewDelegate {
    @objc func didSelected(radioButtonView : PRRecordRadioButtonView)
}

class PRRecordRadioButtonView: UIView {
    private let selectedBorderColor = AppTheme.instance.currentTheme.themeColor
    private let deSelectedBorderColor = UIColor.init(hexString: "525260")
    
    let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
    let label = UILabel.init(frame: CGRect.init(x: 40, y: 0, width: AppDelegate.getDelegate().window?.bounds.size.width ?? 300, height: 20))
    var formElement : FormElement?
    private var _selected = false
    var delegate : PRRecordRadioButtonViewDelegate?
    var isSelected : Bool{
        set{
            _selected = newValue
            updateForSelectionState(_selected)
        }
        get{
            return _selected
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        imageView.center = CGPoint.init(x: 20, y: rect.size.height/2)
        self.addSubview(imageView)
        
        label.frame = CGRect.init(x: 40, y: 0, width: rect.size.width - 40, height: rect.size.height)
        label.textColor = UIColor.white
        label.font = UIFont.ottRegularFont(withSize: 14)
        self.addSubview(label)
        
        self.updateForSelectionState(self.isSelected)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureSelector(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureSelector(gesture : UITapGestureRecognizer){
        self.delegate?.didSelected(radioButtonView: self)
    }
    
    func updateUI(element : FormElement, isSelected : Bool = false){
        self.isSelected = isSelected
        self.formElement = element
        
        self.label.text = element.data
        updateForSelectionState(isSelected)
    }
    
    fileprivate func updateForSelectionState(_ isSelected: Bool) {
        if isSelected{
            self.layer.borderColor = selectedBorderColor?.cgColor
            imageView.image = UIImage.init(named: "PartialRendering-RadioButton-check")
        }
        else{
            self.layer.borderColor = deSelectedBorderColor.cgColor
            imageView.image = UIImage.init(named: "PartialRendering-RadioButton-uncheck")
        }
    }
    
}
