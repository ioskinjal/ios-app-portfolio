//
//  MediaCatalogManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit


public class MediaCatalogManager: NSObject {
    
    /**
     Content page like for TVShows tab, Movies Tab ...
     
     - Parameters:
         - path: path from Tab response
         - onSuccess: PageContentResponse object
         - onFailure: APIError object
     - Returns: Void
     
     */
    
    public func pageContent(path : String, onSuccess : @escaping (PageContentResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
//        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        let params = "path=" + path
        API.instance.request(baseUrl: API.url.pageContent, parameters: params, methodType: .get, info: nil, logString: "PageContent", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let pageResponse = PageContentResponse(_response)
            if pageResponse.info.pageType == .player{
                OTTSdk.appManager.updateLocation(onSuccess: { (response) in }) { (error) in }
            }
            onSuccess(pageResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Monthly Planner Page ...
     
     - Parameters:
         - path: path from Tab response
         - onSuccess: PlannerResponse object
         - onFailure: APIError object
     - Returns: Void
     
     */
    
    public func plannerContent(path : String, onSuccess : @escaping (PlannerResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
//        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        let params = "key=" + path
        API.instance.request(baseUrl: API.url.monthlyPlanner, parameters: params, methodType: .get, info: nil, logString: "plannerContent", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let pageResponse = PlannerResponse(_response)
            
            onSuccess(pageResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Monthly planner Page to get Months List
     
     - Parameters:
         - path: path from Tab response
         - onSuccess: PlannerResponse object
         - onFailure: APIError object
     - Returns: Void
     
     */
    
    public func monthsList(path : String, onSuccess : @escaping (MonthsDataResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
//        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        let params = "data_set_code=" + path
        API.instance.request(baseUrl: API.url.monthlyList, parameters: params, methodType: .get, info: nil, logString: "Months List", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(MonthsDataResponse.init(_response))
            
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Get Page Section Content
     
     - Parameters:
         - path : path from Tab response
         - code: section Code
         - offset: last index
         - count : optional, no of cards
         - filter : optional. Applies in list pages. Value should be sent in format of
             key1:value1,value2;key2:value3, whereas keys and values are available in list page filters
             objects.
         - onSuccess: success
         - sectionsData : SectionData Array
         - onFailure: failed
         - error : APIError object
     - Returns: Void
     
     */
    public func sectionContent(path : String,code : String,offset : Int?,count : Int?,filter : String?, onSuccess : @escaping (_ sectionsData : [SectionData])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = "path=" + path + "&code=" + code
        if let _offset = offset{
            params =  params + "&offset=" + String(describing: _offset)
        }
        if let _count = count{
            params =  params + "&count=" + String(describing: _count)
        }
        if let _filter = filter{
            params =  params + "&filter=" + _filter
        }
        
        API.instance.request(baseUrl: API.url.sectionContent, parameters: params, methodType: .get, info: nil, logString: "SectionContent", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionData.sectionsDataList(json: _response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     TV Guide Content
     
     - Parameters:
     - start_time : epg start time
     - end_time: epg end time
     - filter : optional. Applies in list pages. Value should be sent in format of
     key1:value1,value2;key2:value3, whereas keys and values are available in list page filters
     objects.
     - onSuccess: success
     - TVGuideResponse : TVGuideResponse
     - onFailure: failed
     - error : APIError object
     - Returns: Void
     
     */
    public func tvGuideContent(start_time : NSNumber?, end_time : NSNumber?, filter : String?, skip_tabs : Int?, page : Int?, pagesize : Int?, channel_ids : String? , onSuccess : @escaping (TVGuideResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = ""
        if let start_time = start_time{
            params =  params + "start_time=" + String(describing: start_time)
        }
        if let end_time = end_time{
            params =  params + "&end_time=" + String(describing: end_time)
        }
        if let _filter = filter{
            params =  params + "&filter=" + _filter
        }
        if let _skip_tabs = skip_tabs{
            params =  params + "&skip_tabs=" + "\(_skip_tabs)"
        }
        if let _page = page{
            params =  params + "&page=" + "\(_page)"
        }
        if let _pagesize = pagesize{
            params =  params + "&pagesize=" + "\(_pagesize)"
        }
        if let _channel_ids = channel_ids{
            params =  params + "&channel_ids=" + _channel_ids
        }

        API.instance.request(baseUrl: API.url.tvGuideContent, parameters: params, methodType: .get, info: nil, logString: "TVGuideContent", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let tvGuideResponse = TVGuideResponse.init(_response)
            onSuccess(tvGuideResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }

    
    /**
     Next Video Content
     - Next Video Content : This api is used when ((dataType:epg and contentType:vod) == false) in streamResponse.analyticsInfo
     
     - Parameters:
         - path : path of present video content
         - offset: last index
         - count : optional, no of cards
         - onSuccess: success
         - sectionsData : SectionData
         - onFailure: failed
         - error : APIError object
     - Returns: Void
     
     */
    public func nextVideoContent(path : String,offset : Int?,count : Int?, onSuccess : @escaping (_ sectionsData : SectionData)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = "path=" + path
        if let _offset = offset{
            params =  params + "&offset=" + String(describing: _offset)
        }
        if let _count = count{
            params =  params + "&count=" + String(describing: _count)
        }
        
        API.instance.request(baseUrl: API.url.nextVideoContent, parameters: params, methodType: .get, info: nil, logString: "NextVideoContent", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            
            onSuccess(SectionData.init(_response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Next Epg Content : This api is used when dataType:epg and contentType:vod in streamResponse.analyticsInfo
     - Jira : https://yupptv.atlassian.net/browse/YOP-6005
     - Parameters:
         - path : path of present video content
         - offset: last index
         - count : optional, no of cards
         - onSuccess: success
         - sectionsData : SectionData
         - onFailure: failed
         - error : APIError object
     - Returns: Void
     
     */
    public func nextEpgsContent(path : String,offset : Int = -1,count : Int = 1, onSuccess : @escaping (_ sectionsData : SectionData)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        let params = "path=" + path + "&offset=" + String(describing: offset) + "&count=" + String(describing: count)
        
        API.instance.request(baseUrl: API.url.nextEpgContent, parameters: params, methodType: .get, info: nil, logString: "NextEpgContent", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            
            onSuccess(SectionData.init(_response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    

    /**
     Get Cards for Continue Watching
     
     - Parameters:
     - payLoad: Array items list for continue watching
     - onSuccess: success
     - sectionsData : SectionData Array
     - onFailure: failed
     - error : APIError object
     - Returns: Void
     
     */
    public func getCardsForContinueWatching(payLoad : [String:Any], onSuccess : @escaping (_ pageData : [PageData])-> Void, onFailure : @escaping(_ error : APIError) -> Void){

        API.instance.request(baseUrl: API.url.commonCards, parameters: "", methodType: .post, info: ["DICTIONARY" : payLoad], logString: "getCardsForContinueWatching", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(PageData.data(json: _response))
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }

    
    /**
     Get Stream information
     
     - Parameters:
         - path : target Path
         - onSuccess: Success
         - response: successfull message
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func streamWithEncryption(path : String , network_type : String, stream_type : String?, pin : String? = nil ,onSuccess : @escaping (_ response : StreamResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var dictionary : [String : String] = ["path" : path,"network_type":network_type]
        if let streamType = stream_type, streamType.count > 0 {
            dictionary["stream_type"] = streamType
        }
        if let _pin = pin, _pin.count > 0{
            dictionary["pin"] = _pin
        }
        
        API.instance.requestWithEncryption(dictionary: dictionary, requestType: "page/stream", logString: "Stream", onSuccess:{ (response) in
            let streamResponse = StreamResponse.init(response)
            onSuccess(streamResponse)
            return
        }) { (error) in
            onFailure(error)
        }
    }
    public func stream(path : String , network_type : String,stream_type : String , stream_pin : String, onSuccess : @escaping (_ response : StreamResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        var params = "path=" + path
            params = params + "&network_type=" + network_type
        if stream_type != "" {
            params = params + "&stream_type=" + stream_type
        }
        if stream_pin.count > 0 {
            params = params + "&pin=" + stream_pin
        }
        if OTTSdk.preferenceManager.featuresResponse?.systemFeatures.encryptApisList.fields.stream == true {
            var dictionary : [String : String] = ["path" : path,"network_type":network_type]
            if stream_type != "" {
                dictionary["stream_type"] = stream_type
            }
            if stream_pin.count > 0{
                dictionary["pin"] = stream_pin
            }
            API.instance.requestWithEncryption(dictionary: dictionary, requestType: "page/stream", logString: "Stream", onSuccess:{ (response) in
                let streamResponse = StreamResponse.init(response)
                onSuccess(streamResponse)
                return
            }) { (error) in
                onFailure(error)
            }
        }else {
            API.instance.request(baseUrl: API.url.stream, parameters: params, methodType: .get, info: nil, logString: "Stream", onSuccess: { (response) in
                
                guard let _response = response as? [String : Any] else{
                    onFailure(APIError.defaultError())
                    return
                }
                onSuccess(StreamResponse(_response))
                
                return
            }) { (error) in
                onFailure(error)
                return
            }
        }
    }
    
    /**
     Get Encrypted Stream information
     
     - Parameters:
     - path : target Path
     - onSuccess: Success
     - response: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    
    public func getEncryptedStream(payLoad : [String:Any] ,onSuccess : @escaping (_ response : StreamResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //#warning static url as we have some issue with pointing to beta
        API.instance.request(baseUrl: API.url.encryptedStream, parameters: "", methodType: .post, info: payLoad, logString: "EncryptedStream", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(StreamResponse(_response))
            
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }

    
    /**
     Search
     
     - Parameters:
         - query : string from suggestions api
         - onSuccess: Success
         - response: PageContentResponse object
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func search(query : String ,genre : String? ,language : String? ,dataType : String?, page : Int? ,pageSize : Int? ,onSuccess : @escaping (_ response : [SearchResponse])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "query=" + query
        if let genreStr = genre {
            params = params + "&genre=" + genreStr
        }
        if let languageStr = language {
            params = params + "&language=" + languageStr
        }
        if let dataTypeStr = dataType {
            params = params + "&dataType=" + dataTypeStr
        }
        if let pageStr = page {
            params = params + "&page=" + "\(pageStr)"
        }
        if let pageSizeStr = pageSize {
            params = params + "&pageSize=" + "\(pageSizeStr)"
        }

        API.instance.request(baseUrl: API.url.searchQuery, parameters: params, methodType: .get, info: nil, logString: "Search", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SearchResponse.searchArray(json: _response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    
    /**
     Suggestions
     
     - Parameters:
         - query : string to be searched
         - onSuccess: Success
         - response: String list
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func suggestions(query : String ,onSuccess : @escaping (_ response : [String])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "query=" + query
        API.instance.request(baseUrl: API.url.searchSuggestions, parameters: params, methodType: .get, info: nil, logString: "Suggestions", onSuccess: { (response) in
            
            guard let _response = response as? [String] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(_response)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
        Content Feedback
        
        ````
        Required parameters: path, rating and description
        
        ````
        
        - Parameters:
        - path : content path
        - rating : content rating by user
        - description : rating description
        - onSuccess: Success
        ````
        */
       
       public func contentFeedback(path : String? ,rating:String?,description : String? ,onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
           
           var params = ""
           if path != nil{
               params = "rating=" + String(rating!)
           }
           if rating != nil{
               params = params + "&path=" + String(path!)
           }
           if description != nil{
               params = params + "&description=" + description!
           }
           API.instance.request(baseUrl: API.url.contentFeedback, parameters: params, methodType: .post, info: nil, logString: "ContentFeedback", onSuccess: { (response) in
               
               guard let message = (response as? [String : Any])?["message"] as? String else{
                   onSuccess("")
                   return
               }
               onSuccess(message)
               
               return
           }) { (error) in
               onFailure(error)
               return
           }
       }
    /**
     Start/Stop Program Record
     
     - Parameters:
     - content_type : string to be searched
     - content_id : string to be searched
     - action : string to be searched
     - onSuccess: Success
     - response: String Message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     
    
    public func startStopRecord(content_type : String, content_id : String, action : String,onSuccess : @escaping (_ response : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "content_type=" + content_type
        params = params + "&content_id=" + content_id
        params = params + "&action=" + action
        API.instance.request(baseUrl: API.url.recordURL, parameters: params, methodType: .get, info: nil, logString: "StartStopRecording", onSuccess: { (response) in
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }*/

    /**
     Get Template
     
     - Parameters:
     - code : required Template Code
     - onSuccess: Success
     - response: TemplateResponse Object
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func templateFor(code : String,onSuccess : @escaping (_ response : TemplateResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "code=" + code
        API.instance.request(baseUrl: API.url.template, parameters: params, methodType: .get, info: nil, logString: "templateFor", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let templateResponse = TemplateResponse(_response)
            onSuccess(templateResponse)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get Template Data
     
     - Parameters:
     - template_code : required Template Code
     - path : required Template path
     - onSuccess: Success
     - response: TemplateData Object
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    
    public func templateDataFor(template_code : String,path : String,onSuccess : @escaping (_ response : TemplateData)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "template_code=" + template_code
        params = params + "&path=" + path

        API.instance.request(baseUrl: API.url.templateData, parameters: params, methodType: .get, info: nil, logString: "TemplateData", onSuccess: { (response) in
            
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let templateDataResponse = TemplateData(_response)
            onSuccess(templateDataResponse)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get List of Templates
     
     - Parameters:
         - template_code : required Template Code
         - path : required Template path
         - onSuccess: Success
         - response: array of TemplateResponse Object
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func templatesList(onSuccess : @escaping (_ response : [TemplateResponse])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        API.instance.request(baseUrl: API.url.templateList, parameters: "", methodType: .get, info: nil, logString: "TemplateList", onSuccess: { (response) in
            
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            let templateDataResponse = TemplateResponse.array(json: _response)
            onSuccess(templateDataResponse)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Stream Poll
     - Parameters:
         - pollKey : streamPollKey from the stream response
         - event_type : player status event type
         - onSuccess: Success
         - message: message
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func poll(pollKey : String, event_type : Int,onSuccess : @escaping (_ message : String )-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "poll_key=" + pollKey + "&event_type=" + String(event_type)
        API.instance.request(baseUrl: API.url.streampoll, parameters: params, methodType: .post, info: nil, logString: "StreamPoll", onSuccess: { (response) in
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     Stream Active Sessions
     - Parameters:
         - onSuccess: Success
         - activeSessions: StreamActiveSessions list
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func streamActiveSessions(pollKey : String?, onSuccess : @escaping (_ activeSessions : [StreamActiveSession] )-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = ""
        if pollKey != nil{
            params = "current_poll_key=" + pollKey!
        }
        API.instance.request(baseUrl: API.url.streamActiveSessions, parameters:params , methodType: .get, info: nil, logString: "StreamActiveSessions", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            let streamActiveSession = StreamActiveSession.array(json: _response)
            onSuccess(streamActiveSession)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }
    
    /**
     End Stream Session
     - Parameters:
         - pollKey : playerSessionId from the streamActiveSessions response
         - onSuccess: Success
         - message: message
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func endStreamSession(pollKey : String,onSuccess : @escaping (_ message : String )-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        let params = "poll_key=" + pollKey

        API.instance.request(baseUrl: API.url.streamSessionEnd, parameters: params, methodType: .post, info: nil, logString: "EndStreamSession", onSuccess: { (response) in
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get Recording Form
     - Parameters:
         - code : Code of the content
         - path : path of the content
         - onSuccess: Success
         - message: message
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func getRecordingForm(code : String, path : String,onSuccess : @escaping (_ recordingFormResponse : RecordingFormResponse )-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        var params = "code=" + code
        params = params + "&path=" + path

        API.instance.request(baseUrl: API.url.getRecordingForm, parameters: params, methodType: .get, info: nil, logString: "getRecordingForm", onSuccess: { (response) in
            
            guard let response = (response as? [String : Any]) else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(RecordingFormResponse.init(response))
            return
            
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Submit Recording Form
     - Parameters:
         - code : Code of the content
         - path : path of the content
         - onSuccess: Success
         - message: message
         - onFailure: Unsuccessfull request
         - error : APIError object
     - Returns: Void
     
     */
    
    public func submitRecordingForm(code : String, path : String, elementCode : String, value : String, onSuccess : @escaping (_ message : String )-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //elementCode key, value value
        let params = "code=" + code + "&path=" + path
        let infoValue = ["code":code,"path": path,"fields":[elementCode:value]] as [String : Any]
        
        
        
//        {
//            "code" : "recording_form",
//            "path" : "epg/play/177075",
//            "fields" : {
//                "record_program" : "action:1;contentId:{id};contentType:program"
//            }
//        }
        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: fields, options: .prettyPrinted)
//            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
//            params = params + "&fields=" + "\(jsonString)"
//        } catch {
//        }


        API.instance.request(baseUrl: API.url.submitRecordingForm, parameters: params, methodType: .post, info: ["DICTIONARY" : infoValue], logString: "SubmitRecordingForm", onSuccess: { (response) in
            
            guard let message = ((response as? [String : Any])?["message"] as? String) else{
                onSuccess("")
                return
            }
            onSuccess(message)
            return

        }) { (error) in
            onFailure(error)
            return
        }
    }

    
    /**
     Get TV Guide Channels
     
     - Parameters:
     - filter : filter to apply on channels like genre and language etc
     - skip_tabs: to skip tvguide dates list default false
     - time_zone : user time zone
     key1:value1,value2;key2:value3, whereas keys and values are available in list page filters
     objects.
     - onSuccess: success
     - TVGuideResponse : TVGuideResponse
     - onFailure: failed
     - error : APIError object
     - Returns: Void
     
     */
    public func getTVGuideChannels(filter : String?, skip_tabs : Int?, time_zone : String? , onSuccess : @escaping (TVGuideResponse)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = ""
        if let _filter = filter{
            params =  params + "&filter=" + _filter
        }
        if let _skip_tabs = skip_tabs{
            params =  params + "&skip_tabs=" + "\(_skip_tabs)"
        }
        if let _time_zone = time_zone{
            params =  params + "&time_zone=" + "\(_time_zone)"
        }

        API.instance.request(baseUrl: API.url.getTVGuideChannels, parameters: params, methodType: .get, info: nil, logString: "GetTVGuideChannels", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let tvGuideResponse = TVGuideResponse.init(_response)
            onSuccess(tvGuideResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get Programs For Channels
     
     - Parameters:
     - channel_ids : list of channel ids with comma seperated
     - start_time: start date
     - end_time : end date
     - time_zone : user time zone
     - onSuccess: success
     - [ChannelProgramsResponse] : [ChannelProgramsResponse]
     - onFailure: failed
     - error : APIError object
     - Returns: Void
     
     */
    public func getProgramForChannels(channel_ids : String?, start_time : String?, end_time : String?, time_zone : String? , onSuccess : @escaping ([ChannelProgramsResponse])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = ""
        if let _channel_ids = channel_ids{
            params =  params + "&channel_ids=" + _channel_ids
        }
        if let _start_time = start_time{
            params =  params + "&start_time=" + _start_time
        }
        if let _end_time = end_time{
            params =  params + "&end_time=" + _end_time
        }
        if let _time_zone = time_zone{
            params =  params + "&time_zone=" + "\(_time_zone)"
        }

        API.instance.request(baseUrl: API.url.getProgramForChannels, parameters: params, methodType: .get, info: nil, logString: "GetProgramForChannels", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let tvGuideResponse = ChannelProgramsResponse.channelPrograms(json: _response["data"])
            onSuccess(tvGuideResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }

    /**
     Get User Programs For Channels
     
     - Parameters:
     - channel_ids : list of channel ids with comma seperated
     - start_time: start date
     - end_time : end date
     - time_zone : user time zone
     - onSuccess: success
     - [UserProgramResponse] : [UserProgramResponse]
     - onFailure: failed
     - error : APIError object
     - Returns: Void
     
     */
    public func getUserProgramForChannels(channel_ids : String?, start_time : String?, end_time : String?, time_zone : String? , onSuccess : @escaping ([UserProgramResponse])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //        let info = ["HEADERS":["tenant-code":OTTSdk.preferenceManager.tenantCode]]
        var params = ""
        if let _channel_ids = channel_ids{
            params =  params + "&channel_ids=" + _channel_ids
        }
        if let _start_time = start_time{
            params =  params + "&start_time=" + _start_time
        }
        if let _end_time = end_time{
            params =  params + "&end_time=" + _end_time
        }
        if let _time_zone = time_zone{
            params =  params + "&time_zone=" + "\(_time_zone)"
        }

        API.instance.request(baseUrl: API.url.getUserDataForChannels, parameters: params, methodType: .get, info: nil, logString: "GetProgramForChannels", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            let tvGuideResponse = UserProgramResponse.userChannelPrograms(json: _response["data"])
            onSuccess(tvGuideResponse)
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Content Download Request
     
     - Parameters:
     - path : target Path
     - onSuccess: Success
     - response: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    public func contentDownloadRequest(path : String ,onSuccess : @escaping (_ response : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //#warning static url as we have some issue with pointing to beta
        let infoDic = ["path" : path] as [String:Any]
        API.instance.request(baseUrl: API.url.contentDownloadRequest, parameters: "", methodType: .post, info: ["DICTIONARY" : infoDic], logString: "ContentDownloadRequest", onSuccess: { (response) in
            
            guard response is [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess("")
            
            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
    /**
     Delete Download Video Request
     
     - Parameters:
     - path : target Path
     - onSuccess: Success
     - response: successfull message
     - onFailure: Unsuccessfull request
     - error : APIError object
     - Returns: Void
     
     */
    public func deleteDownloadVideoRequest(paths : [String] ,onSuccess : @escaping (_ response : [String])-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        //#warning static url as we have some issue with pointing to beta
        let infoDic = ["paths" : paths] as [String:Any]
        API.instance.request(baseUrl: API.url.deleteDownloadVideoRequest, parameters: "", methodType: .post, info: ["DICTIONARY" : infoDic], logString: "DeleteDownloadVideoRequest", onSuccess: { (response) in
            
            guard let _response = response as? [String:Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(_response["paths"] as! [String])

            return
        }) { (error) in
            onFailure(error)
            return
        }
    }
}
