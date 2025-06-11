//
//  MediaCatalogManager.swift
//  YuppTV
//
//  Created by Muzaffar on 03/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit


public class MediaCatalogManager: NSObject {
    
    static let  encMacro = "/enc"
    
    public enum TargetPage: String {
        case home = "home"
        case live = "live"
        case catchup = "catchup"
    }
    
    public enum SortBy: String {
        case latest = "latest"
    }
    
    public enum SourceType: String {
        case yuppTVHome = "yupptvhome"
    }
    
    public enum PromoType: String {
        case yuppTVPromo = "Yupptvpromo"
    }

    internal override init() {
        super.init()
    }
    
    /**
     Get all sections for provided page
     
     - Parameters:
         - targetPage : TargetPage enum
             - home : home Page
             - live : TargetPage Page
             - catchup : live Page
         - onSuccess:
             - SectionMetaData list: Array of SectionMetaData object
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func sectionsMetadata(targetPage : TargetPage, onSuccess : @escaping ([SectionMetaData])-> Void, onFailure : @escaping(APIError) -> Void){
        
        var target = "yupptvhome" // TargetPage.home
        if  targetPage == TargetPage.live {
            target = "yupptvlive"
        }
        if  targetPage == TargetPage.catchup {
            target = "yupptvcatchup"
        }
        
        let params = "target_page="+target+"&language="+YuppTVSDK.preferenceManager.selectedLanguages
        API.instance.request(baseUrl: API.url.sectionMetadataList, parameters: params, methodType: .get, info: nil, logString: "SectionsMetaData", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionMetaData.getSectionList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     To get the details of a section (SEO data and targetParams).
     
     - Parameters:
         - sectionCode : sectionCode
         - onSuccess: 
             - SectionMetaData : SectionMetaData object
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func sectionDetails(sectionCode : String, onSuccess : @escaping (SectionMetaData)-> Void, onFailure : @escaping(APIError) -> Void){

        let params = "section_code=" + sectionCode
        API.instance.request(baseUrl: API.url.sectionDetails, parameters: params, methodType: .get, info: nil, logString: "SectionDetails", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionMetaData.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    
    /**
     Get provided sections details
     
     - Parameters:
         - sections : Comma separated Section codes.
         - sortBy : sortBy enum
             - latest : latest first. by Default latest
         - count : No. of items in each section. Default : 30
         - lastIndex: Pagination movies list get by this value. To the first request
             it should be -1, and for subsequent requests, send the
             value that has been received from the previous request. If
             items count in response is less than requested count or
             count=0, items list is completed.
         - onSuccess:
             - SectionData list:
                ````
                * Note : for content,  typecast .data as bellow based on .dataType
                    + .channel : [Channel]
                    + .movie : [Movie]
                    + .tvShowEpisode : [Episode]
                    + .epg : [EPG]
                    + .tvshow : [TVShow]
                ````
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func sectionsData(sections : String, sortBy : SortBy,count : String, lastIndex : Int, onSuccess : @escaping ([SectionData])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "sections="+sections+"&lang="+YuppTVSDK.preferenceManager.selectedLanguages+"&sort=Latest&count="+count+"&last_index="+String(lastIndex)
        API.instance.request(baseUrl: API.url.sectionData, parameters: params, methodType: .get, info: nil, logString: "SectionsData", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionData.sectionDataList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     This API can be called to display data in channel details/player
     page for menu with code bestofchannel.
     
     - Parameters:
         - channelCode : channel Code from section data request
         - noOfDays : No. of Days catch-up     Default : 10
         - onSuccess:
             - ChannelDetailsResponse: ChannelDetailsResponse object
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelDetails(channelCode : String,noOfDays : String, onSuccess : @escaping (ChannelDetailsResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_code="+channelCode+"&days="+noOfDays
        API.instance.request(baseUrl: API.url.channelDetails, parameters: params, methodType: .get, info: nil, logString: "ChannelDetails", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelDetailsResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    /**
     Get Programs from provided date
     
     - Parameters:
         - channelCode : channel Code from section data request
         - startDay : start day of the channel from which user is requesting EPG
         - noOfDays : no of days catch up to be returned.
         - onSuccess: 
             - Program: Array of Program objects
         - onFailure: 
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelEPG(channelCode : String,startDay : String, noOfDays : String, onSuccess : @escaping ([Program])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_code="+channelCode+"&start_day="+startDay+"&days="+noOfDays
        API.instance.request(baseUrl: API.url.epgGuide, parameters: params, methodType: .get, info: nil, logString: "ChannelEPGGuide", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Program.programEpgList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Get Channel Movies
     
     - Parameters:
         - channelID : channel Code from section data request
         - count : Default - 30
         - lastIndex : no of days catch up to be returned.
         - onSuccess: 
             - Channel: Array of Channel objects
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelMovies(channelID : String,count : String, lastIndex : String, onSuccess : @escaping (ChannelMenuResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_id="+channelID+"&count="+count+"&last_index="+lastIndex
        API.instance.request(baseUrl: API.url.channelMovies, parameters: params, methodType: .get, info: nil, logString: "ChannelMovies", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelMenuResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    
    /**
     Get Channel Shows
     
     - Parameters:
         - channelID : channel Code from section data request
         - count : Default - 30
         - lastIndex : no of days catch up to be returned.
         - onSuccess: 
             - Channel: Array of Channel objects
         - onFailure: 
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelShows(channelID : String,count : String, lastIndex : String, onSuccess : @escaping (ChannelMenuResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_id="+channelID+"&count="+count+"&last_index="+lastIndex
        API.instance.request(baseUrl: API.url.channelShows, parameters: params, methodType: .get, info: nil, logString: "ChannelShows", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelMenuResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }

    
    /**
     Get Channel Oneoffs. (Ex: New Year special, Asia Cup)
     
     - Parameters:
         - channelID : channel Code from section data request
         - count : Default - 30
         - lastIndex : no of days catch up to be returned.
         - onSuccess: 
             - Channel: Array of Channel objects
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelOneoffs(channelID : String,count : String, lastIndex : String, onSuccess : @escaping (ChannelMenuResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_id="+channelID+"&count="+count+"&last_index="+lastIndex
        API.instance.request(baseUrl: API.url.channelOneOffs, parameters: params, methodType: .get, info: nil, logString: "ChannelOneoffs", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelMenuResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     This API can be called to display data in channel details/player
        page for menu with code bestofchannel.
     - Parameters:
         - channelID : Id of the channel
         - count : No. of items to be returned in each section
         - onSuccess: ChannelMenuResponse successful
             - ChannelMenuResponse: Array of ChannelMenuResponse objects
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func channelsMenu(channelID : String,count : String, onSuccess : @escaping ([ChannelMenuResponse])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "channel_id="+channelID+"&count="+count
        API.instance.request(baseUrl: API.url.channelDetailsMenu, parameters: params, methodType: .get, info: nil, logString: "ChannelsMenu", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelMenuResponse.menuList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    

    /**
     Stream API
     - Parameters:
         - channelID : Id of the program
         - onSuccess: stream request successful
              * Stype : mp4 (or) HLS
              * isMultiPratStream : true if catch-up streams are multiple available.
              * Code : 404 : channel not found
              * -3  Stream not found
              * -15 Device activation required.
              * isUserLoggedIn : ture/false : false then show sign in button with message in response.
                 Preview stream available.
              * isSubscribed : ture/false : false then show subscribe button with message in response.
                 Preview stream available.
         
         - onFailure: failed
         - APIError: error object with code and message
     - Returns: void
     */
    
    public func stream(channelID : String, onSuccess : @escaping (ChannelStreamResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "epg_id="+channelID
        API.instance.request(baseUrl: API.url.stream, parameters: params, methodType: .post, info: nil, logString: "Stream", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(ChannelStreamResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Suggested Channels API
     - Parameters:
         - programId : Id of the epg
         - count: Default 30
         - onSuccess: List of Channel object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func suggestedChannels(programId : String,count : String, onSuccess : @escaping ([Channel])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "program_id="+programId+"&count="+count
        API.instance.request(baseUrl: API.url.suggestedChannels, parameters: params, methodType: .get, info: nil, logString: "SuggestedChannels", onSuccess: { (response) in
            guard let _response = (response as? [String : Any])?["data"] as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Channel.channelList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Banners
     - Parameters:
         - sourceType : SourceType enum
         - promoType : PromoType enum
         - sourceSubtype : string Optional- "" for dotcom home page
         - count : integer Optional-No of banners to be returned
         - onSuccess : list of Banner objects
             * title : Title of the banner
             * targetType : The following are the possible types along with its actions
                 * channel - Channel Details Page
                 * movie - Movie Details Page
                 * redirect - Open in browser(External / Third party url)
                 * tvshow - TVShow Details Page
                 * tvshowepisode - Player Page of TVShow Episode
                 * epg - Player Page of Program
             * targetJson : Json object which contains required parameters to redirect to the
                             appropriate page on click of banner.
             * sourceType : Possible source Types.
                 * yupptvhome : homepage banner image
                 * Yupptvpromo : homepage Promo Image
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func banners(sourceType : SourceType ,promoType : PromoType,sourceSubtype : String,count : String, onSuccess : @escaping ([Banner])-> Void, onFailure : @escaping(APIError) -> Void){
        
        var source = ""
        if sourceType == .yuppTVHome{
            source = "yupptvhome"
        }
        
        var promo = ""
        if promoType == .yuppTVPromo{
            promo = "Yupptvpromo"
        }
        
        let params = "source_type="+source+"&lang="+YuppTVSDK.preferenceManager.selectedLanguages+"&promo_type="+promo+"&source_subtype="+sourceSubtype+"&count="+count
        API.instance.request(baseUrl: API.url.banners, parameters: params, methodType: .get, info: nil, logString: "Banners", onSuccess: { (response) in
            guard let _response = (response as? [String : Any])?["banners"] as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Banner.getBannersList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
}

//MARK: - Premiers
extension MediaCatalogManager{
    /**
     Premium Movies List API
     - Warning :
         ````
         - Todo : needs to update Failure case
         ````
     - Parameters:
         -  count : Default : ‘20’
         -  lastIndex :integer Pagination movies list get by this value. To the first request
             it should be -1, and for subsequent requests, send the value that has been received from the previous request. If
             movies count in response is less than requested count or count=0, movies list is completed.
         - onSuccess : list of Banner objects
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func premiumMoviesList(count : Int ,lastIndex : Int, onSuccess : @escaping (PremiumMoviesListResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "lang="+YuppTVSDK.preferenceManager.selectedLanguages+"&count="+String(count)+"&last_index="+String(lastIndex)
        API.instance.baseRequest(baseUrl: API.url.premiumMoviesList, parameters: params, methodType: .get, info: nil, logString: "PremiumMoviesList") { (data, response, error) in
            if error != nil {
                onFailure(APIError.init(withMessage: (error?.localizedDescription)!))
            }
            if data != nil{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    onSuccess(PremiumMoviesListResponse.init(withJSON: jsonResult))
                    
                } catch let error as NSError {
                    onFailure(APIError.init(withMessage: error.localizedDescription))
                }
            }
            else{
                onFailure(APIError.defaultError())
            }
        }
    }
    
    /**
     Single Movie detail page
 
     - Parameters:
         - code :Movie code
         - onSuccess : MovieDetailsResponse object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func premiumMovieDetails(code : String, onSuccess : @escaping (MovieDetailsResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "code="+code
        
        API.instance.request(baseUrl: API.url.movieDetails, parameters: params, methodType: .get, info: nil, logString: "PremiumMovieDetails", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
           onSuccess(MovieDetailsResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    

    /**
     Get Stream Key
     
     - To start the Stream requires stream key.
     - To get the stream Key, user must verify his location. By this API a verification Link is sent to user
     registered Mobile number. If the user verifies his location, a stream Key will get in response.
     So this API does 2 functionalities
     + To sent verification Link to Mobile -> sendVerificationLink()
     + To get stream Key. -> getStreamKey()
     
     - Parameters:
         - movieId : Current Movie id
         - onSuccess : StreamKey object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func getStreamKey(movieId : String, onSuccess : @escaping (StreamKeyResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        YuppTVSDK.statusManager.sendVerificationLinkOrGetStreamKey(movieId: movieId, isVerify: "true", onSuccess: { (response) in
            onSuccess(response)
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     Movie Stream request API
     - Parameters:
         - streamKey : Get from getStreamKey().
         - onSuccess: stream request successful
             - count : The number Of stream URLs.
             - sType : sType for secure urls can be "wideVine", "playReady", "mpd", no significance for non secure urls as of now
             - isDefault : Future Purpose
     
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func stream(streamKey : String, onSuccess : @escaping (MovieStreamResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "stream_key=" + streamKey + "&is_drm=1"
        API.instance.request(baseUrl: API.url.movieStream, parameters: params, methodType: .post, info: nil, logString: "Stream", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(MovieStreamResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
}

//MARK: - TVShows
extension MediaCatalogManager{
    
    /**
     TVShows Sections list API
     
     - Parameters:
         - onSuccess: SectionMetaData list
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func tvShowsSectionsMetadata(onSuccess : @escaping ([SectionMetaData])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "target_page=tvshows&language=" + YuppTVSDK.preferenceManager.selectedLanguages
        API.instance.request(baseUrl: API.url.sectionsList, parameters: params, methodType: .get, info: nil, logString: "TVShowsSectionsMetadata", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionMetaData.getSectionList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    
    /**
     Get provided sections details
     
     - Parameters:
         - sections : Comma separated Section codes.
         - sortBy : sortBy enum
         - genre : genre (Ex: Drama)
         - latest : latest first. by Default latest
         - count : No. of items in each section. Default : 30
         - lastIndex: Pagination ... To the first request
             it should be -1, and for subsequent requests, send the
             value that has been received from the previous request. If
             items count in response is less than requested count or
             count=0, items list is completed.
         - onSuccess:
             - SectionData list:
                 ````
                 * Note : for content,  typecast .data as bellow based on .dataType
                     + .tvShowEpisode : [Episode]
                     + .tvshow : [TVShow]
                     + .channel : [Channel]
                     + .movie : [Movie]
                     + .epg : [EPG]
                 ````
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func tvShowsSectionsData(sections : String, sortBy : SortBy,genre : String,count : Int, lastIndex : Int, onSuccess : @escaping ([SectionData])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "sections="+sections+"&lang="+YuppTVSDK.preferenceManager.selectedLanguages+"&sort=Latest&count="+String(count)+"&last_index="+String(lastIndex)
        API.instance.request(baseUrl: API.url.sectionsData, parameters: params, methodType: .get, info: nil, logString: "SectionsData", onSuccess: { (response) in
            guard let _response = response as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SectionData.sectionDataList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     TV Show details
     
     - Parameters:
         - code : TV Show Code
         - seasonId : nill or valid Integer
         - episodeCount : nill or valid Integer
         - onSuccess: TVShowDetailsResponse Object
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func tvShowDetails(code : String, seasonId : Int?, episodeCount : Int?, onSuccess : @escaping (TVShowDetailsResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        var params = "code=" + code
        if seasonId != nil{
            params.append("&season_id="+String(seasonId!))
        }
        if episodeCount != nil{
            params.append("&episode_count="+String(episodeCount!))
        }
        
        API.instance.request(baseUrl: API.url.tvShowDetails, parameters: params, methodType: .get, info: nil, logString: "TvShowDetails", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(TVShowDetailsResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     TV Show Season episodes API
     
     - Parameters:
         - tvshowId : ID of the TV show
         - seasonId : ID of the season
         - lastIndex : nill or index of the last item returned in the previous request
         - count : nill or Number of episodes to be given in the response. By default, 10 episodes
         - onSuccess: SeasonEpisodesResponse Object
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func tvShowSeasonEpisodes(tvshowId : Int,seasonId : Int,lastIndex : Int?,count : Int?, onSuccess : @escaping (SeasonEpisodesResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        var params = "tvshow_id=" + String(tvshowId) + "&season_id=" + String(seasonId)
        if lastIndex != nil{
            params.append("&last_index="+String(lastIndex!))
        }
        if count != nil{
            params.append("&count="+String(count!))
        }
        
        API.instance.request(baseUrl: API.url.tvShowSeasonEpisodes, parameters: params, methodType: .get, info: nil, logString: "TvShowSeasonEpisodes", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(SeasonEpisodesResponse.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     Episode Stream API
     
     - Parameters:
         - tvshowId : ID of the TV show
         - episodeId : ID of the Episode
         - onSuccess: Stream list
         - onFailure:
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func episodeStream (tvshowId : Int,episodeId : Int, onSuccess : @escaping ([Stream])-> Void, onFailure : @escaping(APIError) -> Void){
        
        let params = "tvshow_id=" + String(tvshowId) + "&episode_id=" + String(episodeId)
        API.instance.request(baseUrl: API.url.episodeStream, parameters: params, methodType: .post, info: nil, logString: "EpisodeStream ", onSuccess: { (response) in
            guard let _response = (response as? [String : Any])?["streams"]  as? [[String : Any]] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(Stream.streamList(json: _response))
        }) { (error) in
            onFailure(error)
        }
    }
}
