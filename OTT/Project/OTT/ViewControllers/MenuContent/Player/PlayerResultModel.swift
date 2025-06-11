//
//  PlayerResultModel.swift
//  YuppFlix
//
//  Created by Ankoos on 20/03/17.
//  Copyright © 2017 Ankoos. All rights reserved.
//

import UIKit

struct ContentType {
    static let unknown  = 0
    static let movie    = 1
    static let tvShow   = 2
    static let genres   = 3
    static let section  = 4
}
struct StreamResult {
    var sType = ""
    var url = ""
    var isDefault = false
    var licenseKeys = LicenseKeys()
    var previewDuration = 0
}
struct LicenseKeys{
    var certificate = ""
    var license = ""
}
class PlayerResultModel: NSObject {
    
    
    struct StreamResults {
        var allStreams = [StreamResult]()
        var defaultStream : StreamResult{
            
            set{
                itemStream = newValue
            }
            get{
                return itemStream
            }
        }
        var itemStream = StreamResult()
        
        var defaultFairplayStream : StreamResult{
            
            set{
                itemF_Stream = newValue
            }
            get{
                return itemF_Stream
            }
        }
        var itemF_Stream = StreamResult()
    }
    
    var streams = StreamResults()
    var contentType = ContentType.movie
    var seek : Int = 0

}
