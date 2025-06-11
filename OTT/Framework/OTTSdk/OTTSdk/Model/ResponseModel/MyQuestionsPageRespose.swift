//
//  MyQuestionsPageRespose.swift
//  OTTSdk
//
//  Created by Srikanth on 4/20/20.
//  Copyright © 2020 YuppTV. All rights reserved.
//

import UIKit


public class QuestionGenresResponse: YuppModel {
    public var genreArray = [String]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let tempArray = json["genre"] as? [String]{
            genreArray = tempArray
        }
    }
}
 
public class QuestionGenresContentResponse: YuppModel {
    public var contentNameData = [Any]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let tempArray = json["contentName"] as? [[Any]]{
            contentNameData = tempArray
        }
    }
}

public class MyQuestionsResponse: YuppModel {
    public var genre = ""
    public var chapterName = ""
    public var questions = [MyQuestions]()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        genre = getString(value: json["genre"])
        chapterName = getString(value: json["chapterName"])
        questions = MyQuestions.array(json: json["questions"])
    }
}

public class MyQuestions: YuppModel {
    public var question = ""
    public var postedTime = NSNumber()
    public var lastUpdatedTime = NSNumber()
    public var id = 0
    public var contentType = ""
    public var lastUpdatedBy = ""
    public var status = 0
    public var attachmentPath = ""
    public var contentId = 0
    public var userId = 0
    public var fromModerator = false
    public var hasAttachment = false
    public var userName = ""
           

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        question = getString(value: json["question"])
        postedTime = getNSNumber(value:json["postedTime"])
        lastUpdatedTime = getNSNumber(value:json["lastUpdatedTime"])
        id = getInt(value: json["id"])
        contentType = getString(value: json["contentType"])
        lastUpdatedBy = getString(value: json["lastUpdatedBy"])
        status = getInt(value: json["status"])
        attachmentPath = getImageUrl(value: json["attachmentPath"])
        contentId = getInt(value: json["contentId"])
        userId = getInt(value: json["userId"])
        fromModerator = getBool(value: json["fromModerator"])
        hasAttachment = getBool(value: json["hasAttachment"])
        userName = getString(value: json["userName"])
    }

    public static func array(json : Any?) -> [MyQuestions]{
        var list = [MyQuestions]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(MyQuestions(obj))
            }
        }
        return list
    }

}

