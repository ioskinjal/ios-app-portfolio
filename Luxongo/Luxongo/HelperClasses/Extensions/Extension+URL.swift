//
//  Extension+URL.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVKit

extension URL{
    func getThumbnailFromVideo() -> UIImage?{
        do {
            let asset = AVURLAsset(url: self , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            print(thumbnail)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getDataAndFileNameBasedOnURL() -> (fileData:Data, fileName:String) {
        print("The Url is : \(self)")
        //let fileNameWithoutExtension = self.pathExtension//deletingPathExtension().lastPathComponent
        //print("fileNameWithoutExtension: \(fileNameWithoutExtension)")
        do {
            let data = try Data(contentsOf: self)
            //print("data=\(data)")
            let fileName = self.lastPathComponent
            //print(fileName)
            return (data, fileName)
        }
        catch {/* error handling here */
            return (Data(), "")
        }
    }
    
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
