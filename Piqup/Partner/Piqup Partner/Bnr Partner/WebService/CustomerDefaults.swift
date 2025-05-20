//
//  CustomerDefaults.swift
//  BooknRide
//
//  Created by KASP on 15/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Photos
let device_token = "deviceToken"

class CustomerDefaults: NSObject {

    class func saveDeviceToken(token:String) {
        
        UserDefaults.standard.set(token, forKey: device_token)
        UserDefaults.standard.synchronize()

        }
    
    class func getDeviceToken() -> String{
        
        return UserDefaults.standard.object(forKey: device_token) as? String ?? ""

    }
    
}
extension UIImagePickerController{
    
    func getPickedFileName(info: [String:Any]) -> String? {
        
        
//        var fileName: String = "Attachment"
//        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
//            let assets = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//            let assetResource = PHAssetResource.assetResources(for: assets.firstObject!)
//            fileName = assetResource.first?.originalFilename ?? "Attachment"
//        }
//        print(fileName)
//        return fileName
        
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                if let fileName = (asset.value(forKey: "filename")) as? String {
                    print("\(fileName)")
                    return fileName
                }
                else{return nil}
            }
            else{return nil}
        } else {
            // Fallback on earlier versions
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                if let asset = result.firstObject {
                    print(asset.value(forKey: "filename")!)
                    return asset.value(forKey: "filename") as? String ?? ""
                }
                else{return nil}
            }
            else{return nil}
        }
        
}
}
