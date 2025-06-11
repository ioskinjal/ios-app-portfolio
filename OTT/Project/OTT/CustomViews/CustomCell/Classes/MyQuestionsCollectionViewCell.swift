//
//  MyQuestionsCollectionViewCell.swift
//  OTT
//
//  Created by Rajesh Nekkanti on 15/04/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit

protocol MyQuestionsDelegate : AnyObject {
    func onClickAnswer(cell:MyQuestionsCollectionViewCell)
    func onClickAttachment(cell:MyQuestionsCollectionViewCell)
    func onClickArrow(cell:MyQuestionsCollectionViewCell)
    func onClickThumbnails(cell:MyQuestionsCollectionViewCell, tag:Int)
}

class MyQuestionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgCountLbl: UILabel!
//    @IBOutlet weak var stackTimeLbl: UILabel!
    @IBOutlet weak var dropDownArrowBtn: UIButton!
    @IBOutlet weak var titleLabelHeightConstraint : NSLayoutConstraint?
    
    weak var delegate : MyQuestionsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.titleLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.dateLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.imgCountLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.backgroundColor = AppTheme.instance.currentTheme.chatTableBGView
        addCorenerRadiusToComponents(element: imgOne)
        addCorenerRadiusToComponents(element: imgTwo)
        addCorenerRadiusToComponents(element: imgCountLbl)
        addTapGestureToComponents(element: imgOne)
        addTapGestureToComponents(element: imgTwo)
        addTapGestureToComponents(element: imgCountLbl)
        
    }
    
    
    func addTapGestureToComponents(element:UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        element.addGestureRecognizer(tap)
    }
    
    func addCorenerRadiusToComponents(element:UIView) {
        element.viewBorderWidthWithTwo(color: AppTheme.instance.currentTheme.myQuestionsCellBorderColor, isWidthOne: true)
        element.isUserInteractionEnabled = true
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        Log(message: "\(sender?.view?.tag as Any)")
        delegate?.onClickThumbnails(cell: self, tag: (sender?.view!.tag)!)
    }

    @IBAction func answerAction(_ sender: UIButton) {
        delegate?.onClickAnswer(cell: self)
    }
    
    
    @IBAction func attacmentAction(_ sender: UIButton) {
        delegate?.onClickAttachment(cell: self)
    }
    
    
    @IBAction func arrowBtnAction(_ sender: UIButton) {
        delegate?.onClickArrow(cell: self)
    }
    
}
