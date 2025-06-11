//
//  CastCrewModel.swift
//  YUPPTV
//
//  Created by Chandra Sekhar on 11/15/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit

class CastCrewModel: NSObject {
    var name :String!
    var imageUrl = ""
    var type = ""
    var code = ""
    
    init(withImageUrl imagePath : String, castName : String , castType : String , castCode:String) {
        imageUrl = imagePath
        name = castName
        type = castType
        code = castCode
    }
}
