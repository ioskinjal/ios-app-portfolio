/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A simple class that represents an entry from the `Streams.plist` file in the main application bundle.
 */

import Foundation
public class Stream: NSObject {
        
    // MARK: Properties
    
    /// The name of the stream.
    var name: String = ""

    /// The subtitle of the stream.
    var subTitle: String = ""

    /// The URL pointing to the HLS stream.
    var playlistURL: String = ""
    
    /// The image data of the stream.
    var imageData : NSData?

    /// The targetPath of the stream.
    var targetPath : String = ""
    
    /// The targetPath of the stream.
    var userID : Int = 0

    /// The targetPath of the stream.
    var analyticsMetaID : String = ""
    
    var downloaded_end_date : Double = 0.0
    var downloaded_start_date : Double = 0.0
    var bit_rate = ""
    var download_size = ""
    var video_duration = ""
    var video_download = false
    public override init() {
        super.init()
    }
}
/*class Stream: Codable {
    
    // MARK: Types
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case playlistURL = "playlist_url"
    }
    
    // MARK: Properties
    
    /// The name of the stream.
    let name: String
    
    /// The URL pointing to the HLS stream.
    let playlistURL: String
}

extension Stream: Equatable {
    static func ==(lhs: Stream, rhs: Stream) -> Bool {
        return (lhs.name == rhs.name) && (lhs.playlistURL == rhs.playlistURL)
    }
}*/
