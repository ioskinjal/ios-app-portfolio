//
//  AttachmentHandler.swift
//  OTT
//
//  Created by Chandoo on 17/03/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import Photos

protocol AttachmentHandlerDelegate {
    func imagePicked(_ imageData:NSData, fileName:String, filePath:String)
    func videoPicked(_ videoData:NSData, fileName:String, filePath:String)
}

class AttachmentHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum AttachmentType: String{
     case camera, video, photoLibrary
    }
    
    public class var instance: AttachmentHandler {
        struct Singleton {
            static let obj = AttachmentHandler()
        }
        return Singleton.obj
    }
    var compressionQuality:CGFloat = 0.8
    var currentVC:UIViewController?
    var delegate : AttachmentHandlerDelegate?

    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        /* Disabling video and document picker
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
            self.documentPicker()
        }))
        */
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        if productType.iPad{
            if let currentPopoverpresentioncontroller = actionSheet.popoverPresentationController{
                //currentPopoverpresentioncontroller.barButtonItem = vc. as? UIBarButtonItem
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (vc.view.bounds.midX), y: (vc.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = vc.view
                vc.present(actionSheet, animated: true, completion: nil)
            }
        }else{
            vc.present(actionSheet, animated: true, completion: nil)
        }
        //vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        if attachmentTypeEnum ==  AttachmentType.camera{
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
                //denied - The user has previously denied access.
            //restricted - The user can't grant access due to restrictions.
            case .denied, .restricted:
                return
                
            default:
                break
            }
        }else if attachmentTypeEnum == AttachmentType.photoLibrary || attachmentTypeEnum == AttachmentType.video{
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary{
                    photoLibrary()
                }
                
                if attachmentTypeEnum == AttachmentType.video{
                    videoLibrary()
                }
            case .denied, .restricted: break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        // photo library access given
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                })
            default:
                break
            }
        }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
            
            if  playerVC != nil{
                playerVC?.isNavigatingToBrowser = true 
                playerVC?.player.pause()
            }
            
        }
    }

    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            DispatchQueue.main.async {
                myPickerController.delegate = self
                DispatchQueue.main.async {
                    myPickerController.sourceType = .photoLibrary
                    DispatchQueue.main.async {
                        self.currentVC?.present(myPickerController, animated: true, completion: nil)
                        if  playerVC != nil{
                            playerVC?.isNavigatingToBrowser = true
                            playerVC?.player.pause()
                        }
                    }
                }
            }
        }
    }
    
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
//            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - ImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let fileDetails = self.getSelectedDetails(info: info)
        let fileName = fileDetails.fileName
        let filePath = fileDetails.filePath
        let imageData = fileDetails.imageData
        let videoData = fileDetails.videoData
        
        if imageData != nil {
            self.delegate?.imagePicked(imageData! as NSData, fileName: fileName, filePath: filePath)
        } else if videoData != nil {
            self.delegate?.videoPicked(videoData!, fileName: fileName, filePath: filePath)
        }
        if playerVC != nil{
            playerVC?.player.playFromCurrentTime()
            if playerVC?.playBtn != nil {
                playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
            }
            playerVC?.isNavigatingToBrowser = false
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if playerVC != nil {
            playerVC?.stopAnimating()
            playerVC?.stopAnimating1()
            playerVC?.stopAnimatingPlayer(false)
            playerVC?.player.playFromCurrentTime()
            if playerVC?.playBtn != nil {
                playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
            }
            playerVC?.isNavigatingToBrowser = false
            
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func getSelectedDetails(info : [UIImagePickerController.InfoKey : Any]) -> (fileName : String, filePath:String, imageData:Data?, videoData:NSData?) {
        var fileName = ""
        var filePath = ""
        var imageData : Data?
        var videoData : NSData?
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                if let resourceObj = assetResources.first {
                    fileName = resourceObj.originalFilename
                } else {
                    fileName = ""
                }
            } else {
                fileName = ""
            }
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let imgName = imageURL.lastPathComponent
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                filePath = (documentDirectory?.appending(imgName))!
            } else {
                filePath = ""
            }
        } else {
            fileName = "QuestionImage.png"
            filePath = ""
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageData = image.jpegData(compressionQuality: self.compressionQuality)
        } else{
            print("Something went wrong in  image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            videoData = NSData(contentsOf: videoUrl as URL)!
        }
        else{
            print("Something went wrong in  video")
        }
        
        return (fileName,filePath,imageData,videoData)
    }
}
