//
//  ContainerView.swift
//  Luxongo
//
//  Created by admin on 7/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

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
    
    private class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
//    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
//        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
//        embed(
//            parent: parent,
//            container: container,
//            child: vc,
//            previous: parent.children.first
//        )
//        completion?(vc)
//    }
    
    class func embed(withViewController childVC:UIViewController, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        embed(
            parent: parent,
            container: container,
            child: childVC,
            previous: parent.children.first
        )
        completion?(childVC)
    }
    
}

/*
//Usage:

switch id {
case MessageVC.identifier:
    let nextView: MessageVC!
    nextView = MessageVC.storyboardInstance!
    //nextView.messageList = SearchMsgData.messages_res!
    //nextView.projInfo = self.projInfo
    ViewEmbedder.embed(
        withViewController: nextView,
        parent: self,
        container: self.rootContainerView){ vc in
            // do things when embed complete
    }
    
}

*/
