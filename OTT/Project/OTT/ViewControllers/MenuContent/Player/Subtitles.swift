//
//  Subtitles.swift
//  Subtitles
//
//  Created by mhergon on 23/12/15.
//  Copyright © 2015 mhergon. All rights reserved.
//

import ObjectiveC
import MediaPlayer
import AVKit
import CoreMedia

private struct AssociatedKeys {
    static var FontKey = "FontKey"
    static var ColorKey = "FontKey"
    static var SubtitleKey = "SubtitleKey"
    static var SubtitleHeightKey = "SubtitleHeightKey"
    static var SubtitleWidthKey = "SubtitleWidthKey"
    static var PayloadKey = "PayloadKey"
}

public class Subtitles {
    
    // MARK: - Properties
    fileprivate var parsedPayload: NSDictionary?

    // MARK: - Public methods
    public init(file filePath: URL, encoding: String.Encoding = String.Encoding.utf8) {
        
        // Get string
        let string = try! String(contentsOf: filePath, encoding: encoding)
        
        // Parse string
        parsedPayload = Subtitles.parseSubRip(string)
        
    }
    
    public init(subtitles string: String) {
        
        // Parse string
        parsedPayload = Subtitles.parseSubRip(string)
        
    }
    
    /// Search subtitles at time
    ///
    /// - Parameter time: Time
    /// - Returns: String if exists
    public func searchSubtitles(at time: TimeInterval) -> String? {
        
        return Subtitles.searchSubtitles(parsedPayload, time)
        
    }
    
    // MARK: - Private methods

    /// Subtitle parser
    ///
    /// - Parameter payload: Input string
    /// - Returns: NSDictionary
    fileprivate static func parseSubRip(_ payload: String) -> NSDictionary? {
        
        do {
            
            // Prepare payload
            var payload = payload.replacingOccurrences(of: "\n\r\n", with: "\n\n")
            payload = payload.replacingOccurrences(of: "\n\n\n", with: "\n\n")
            payload = payload.replacingOccurrences(of: "\r\n", with: "\n")
            
            // Parsed dict
            let parsed = NSMutableDictionary()
            
            // Get groups
            let regexStr = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"
            let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
            let matches = regex.matches(in: payload, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, payload.count))
            for m in matches {
                
                let group = (payload as NSString).substring(with: m.range)
                
                // Get index
                var regex = try NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
                var match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
                guard let i = match.first else {
                    continue
                }
                let index = (group as NSString).substring(with: i.range)
                
                // Get "from" & "to" time
                regex = try NSRegularExpression(pattern: "\\d{1,2}:\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
                match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
                guard match.count == 2 else {
                    continue
                }
                guard let from = match.first, let to = match.last else {
                    continue
                }
                
                var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0
                
                let fromStr = (group as NSString).substring(with: from.range)
                var scanner = Scanner(string: fromStr)
                scanner.scanDouble(&h)
                scanner.scanString(":", into: nil)
                scanner.scanDouble(&m)
                scanner.scanString(":", into: nil)
                scanner.scanDouble(&s)
                scanner.scanString(",", into: nil)
                scanner.scanDouble(&c)
                let fromTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
                
                let toStr = (group as NSString).substring(with: to.range)
                scanner = Scanner(string: toStr)
                scanner.scanDouble(&h)
                scanner.scanString(":", into: nil)
                scanner.scanDouble(&m)
                scanner.scanString(":", into: nil)
                scanner.scanDouble(&s)
                scanner.scanString(",", into: nil)
                scanner.scanDouble(&c)
                let toTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
                
                // Get text & check if empty
                let range = NSMakeRange(0, to.range.location + to.range.length + 1)
                guard (group as NSString).length - range.length > 0 else {
                    continue
                }
                let text = (group as NSString).replacingCharacters(in: range, with: "")
                
                // Create final object
                let final = NSMutableDictionary()
                final["from"] = fromTime
                final["to"] = toTime
                final["text"] = text
                parsed[index] = final
                
            }
            
            return parsed
            
        } catch {
            
            return nil
            
        }
        
    }
    
    /// Search subtitle on time
    ///
    /// - Parameters:
    ///   - payload: Inout payload
    ///   - time: Time
    /// - Returns: String
    fileprivate static func searchSubtitles(_ payload: NSDictionary?, _ time: TimeInterval) -> String? {
        
        let predicate = NSPredicate(format: "(%f >= %K) AND (%f <= %K)", time, "from", time, "to")
        
        guard let values = payload?.allValues, let result = (values as NSArray).filtered(using: predicate).first as? NSDictionary else {
            return nil
        }
        
        guard let text = result.value(forKey: "text") as? String else {
            return nil
        }
        
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
}

extension PlayerViewController {
    
    // MARK: - Public properties
    var subtitleLabel: UILabel? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.SubtitleKey) as? UILabel }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.SubtitleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // MARK: - Private properties
    fileprivate var subtitleLabelHeightConstraint: NSLayoutConstraint? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.SubtitleHeightKey) as? NSLayoutConstraint }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.SubtitleHeightKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    fileprivate var subtitleLabelWidthConstraint: NSLayoutConstraint? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.SubtitleWidthKey) as? NSLayoutConstraint }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.SubtitleWidthKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    fileprivate var parsedPayload: NSDictionary? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.PayloadKey) as? NSDictionary }
        set (value) { objc_setAssociatedObject(self, &AssociatedKeys.PayloadKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // MARK: - Public methods
    func addSubtitles() -> Self {
        
        // Create label
        addSubtitleLabel()
        
        return self
        
    }
    func removeSubTitleObserver() {
        if self.ccTimeObserver != nil {
            self.player.avplayer.removeTimeObserver(self.ccTimeObserver)
            self.ccTimeObserver = nil
//            self.subtitleLabel?.isHidden = true
//            self.subtitleLabel = nil
        }
    }
    func open(file filePath: URL, encoding: String.Encoding = String.Encoding.utf8, fileType:String) {
        
        if let contents = try? String(contentsOf: filePath, encoding: encoding) {
            show(subtitles: contents,fileType:fileType)
        }
        
    }
    
    func show(subtitles string: String,fileType:String) {
        
        // Parse
        var webVTT : WebVTT?
        if fileType == "srt" {
            parsedPayload = Subtitles.parseSubRip(string)
        }
        else if fileType == "vtt" {
            let parser = WebVTTParser(string: string)
             webVTT = try? parser.parse()
        }
        
        removeSubTitleObserver()
        // Add periodic notifications
        self.ccTimeObserver = self.player.avplayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 60),
            queue: DispatchQueue.main,
            using: { [weak self] (time) -> Void in
                
                guard let strongSelf = self else { return }
                guard let label = strongSelf.subtitleLabel else { return }
                var isTextFound = false
                // Search && show subtitles
                if fileType == "srt" {
                    isTextFound = true
                    label.text = Subtitles.searchSubtitles(strongSelf.parsedPayload, time.seconds)
                }
                else if fileType == "vtt" {
                    if webVTT != nil,webVTT!.cues.count > 0 {
                        //let text = webVTT?.cues[0].text
                        //let startTime = webVTT!.cues[0].timeStart
                        //let endTime = webVTT!.cues[0].timeEnd
                        for (_,obj) in webVTT!.cues.enumerated() {
                            
                            
                            let newStartTime = CMTimeMakeWithSeconds(obj.timeStart, preferredTimescale: 1)
                            let newEndTime = CMTimeMakeWithSeconds(obj.timeEnd, preferredTimescale: 1)
                            if newStartTime <= time  && time < newEndTime {
                                label.text = obj.text
                                label.backgroundColor = UIColor.darkText.withAlphaComponent(0.5)
                                isTextFound = true
                                break;
                            }
                        }
                    }
                }
                
                if isTextFound == true && self?.ccButton?.isSelected ?? false == true {
                    if playerVC != nil {
                        if fileType == "vtt" && self?.closeCaptions != nil && self?.closeCaptions.ccList.count == 0{
                            label.isHidden = true
                        }
                        else{
                            label.isHidden = playerVC!.isMinimized ? true : false
                        }
                    }
                    else {
                        label.isHidden = false
                    }
                }
                else {
                    label.isHidden = true
                }
                 
                
                // Adjust size
                let baseSize = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
                let rect = label.sizeThatFits(baseSize)
                if label.text != nil {
                    strongSelf.subtitleLabelHeightConstraint?.constant = rect.height + 5.0
                    strongSelf.subtitleLabelWidthConstraint?.constant = rect.width + 20.0
                } else {
                    strongSelf.subtitleLabelHeightConstraint?.constant = rect.height
                    strongSelf.subtitleLabelWidthConstraint?.constant = rect.width
                }
        })
        
    }
    
    // MARK: - Private methods
    fileprivate func addSubtitleLabel() {
        DispatchQueue.main.async{
            guard let _ = self.subtitleLabel else {
                
                
                // Label
                self.subtitleLabel = UILabel()
                self.subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
                self.subtitleLabel?.backgroundColor = UIColor.clear
                
                self.subtitleLabel?.textAlignment = .center
                self.subtitleLabel?.numberOfLines = 0
                self.subtitleLabel?.font = UIFont.ottBoldFont(withSize: productType.iPad ? 40.0 : 12.0)
                self.subtitleLabel?.textColor = UIColor.white
                self.subtitleLabel?.numberOfLines = 0;
                self.subtitleLabel?.layer.shadowColor = UIColor.black.cgColor
                self.subtitleLabel?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
                self.subtitleLabel?.layer.shadowOpacity = 1.0;
                self.subtitleLabel?.layer.shadowRadius = 5.0;
                self.subtitleLabel?.layer.shouldRasterize = true;
                self.subtitleLabel?.layer.rasterizationScale = UIScreen.main.scale
                self.subtitleLabel?.lineBreakMode = .byWordWrapping
                self.subtitleLabel?.sizeToFit()
                if self.playerHolderView != nil {
                    self.playerHolderView?.addSubview(self.subtitleLabel!)
                }
                
                // Position
                //            var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[l]-(20)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["l" : self.subtitleLabel!])
                
                if self.playerHolderView != nil {
                    //self.playerHolderView?.addConstraints(constraints)
                    //let xConstraint = NSLayoutConstraint(item: self.subtitleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self.playerHolderView, attribute: .centerX, multiplier: 1, constant: 0)
                    self.subtitleLabel?.centerXAnchor.constraint(equalTo: self.playerHolderView.centerXAnchor).isActive = true
                    
                    
                }
                var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[l]-(25)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["l" : self.subtitleLabel!])
                if self.playerHolderView != nil {
                    self.playerHolderView?.addConstraints(constraints)
                }
                self.subtitleLabelHeightConstraint = NSLayoutConstraint(item: self.subtitleLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 30.0)
                
                self.subtitleLabelWidthConstraint = NSLayoutConstraint(item: self.subtitleLabel!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 30.0)
                
                if self.playerHolderView != nil {
                    self.playerHolderView?.addConstraint(self.subtitleLabelHeightConstraint!)
                    self.playerHolderView?.addConstraint(self.subtitleLabelWidthConstraint!)
                }
                
                return
            }
        }
        
    }
    
}
