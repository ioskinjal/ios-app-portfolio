//
//  CustomControl.swift
//  Talabtech
//
//  Created by NCT 24 on 06/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class WhiteBorderButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        //backgroundColor = appColor.greenColor
        setTitleColor(Color.white, for: .normal)
        titleLabel?.font = RobotoFont.regular(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(self.bounds.height * 0.2, borderWidth: 1.0, color: Color.white)
    }
    
}
class ViewEmbedder {
    class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        
        //        let flag:CGFloat = container.center.x
        //        container.center.x = -1000.0
        //        UIView.animate(withDuration: 0.3, animations: {
        //            container.center.x = flag
        //        }, completion: nil)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.children.first
        )
        completion?(vc)
    }
    
    class func embed(withViewController childVC:UIViewController, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        embed(
            parent: parent,
            container: container,
            child: childVC,
            previous: parent.children.first
        )
        completion?(childVC)
    }
    class func showNoRecordError(collectionView: UICollectionView, count: Int, message: String = "No Photos Added") {
        if(count > 0) {
            collectionView.backgroundView?.isHidden = true
        } else {
            collectionView.backgroundView?.isHidden = false
            let noDataLabel: UILabel  = UILabel(frame: collectionView.bounds)
            noDataLabel.text = message
            noDataLabel.textColor = UIColor.black
            noDataLabel.font = UIFont(name:"Raleway-Regular", size: 16.0)
            noDataLabel.textAlignment = .center
            collectionView.backgroundView = noDataLabel
        }
    }
}
class GreenButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        backgroundColor = Color.green.theam
        setTitleColor(Color.white, for: .normal)
        titleLabel?.font = RobotoFont.medium(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(self.bounds.height * 0.1)
    }
    
}

