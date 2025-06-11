//
//  AppTheme.swift
//  OTT
//
//  Created by Chandra on 5/27/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit

public class AppTheme: NSObject {
    public class var instance: AppTheme {
        struct Singleton {
            static let obj = AppTheme()
        }
        return Singleton.obj
    }
    var currentTheme : AppTheme!
    var cardTitleColor:UIColor!
    var cardSubtitleColor:UIColor!
    var chromecastIconColor:UIColor!
    var applicationBGColor:UIColor!
    var navigationViewBarColor:UIColor!
    var userProfileTextFieldColor:UIColor!
    var tvGuideDateCellColor:UIColor!
    var guideTimeBgColor:UIColor!
    var tvGuideChannelBgColor:UIColor!
    var tvGuideContentCellColor:UIColor!
    var tvGuideContentCellBorderColor:UIColor!
    var noContentAvailableTitleColor:UIColor!
    var plsTryAgainTitleColor:UIColor!
    var themeColor:UIColor!
    var menuSelBgColor: UIColor!
    var submenuBgColor: UIColor!
    var navigationBarColor:UIColor!
    var navigationBarTextColor:UIColor!
    var transactionFailedtextColor:UIColor!
    var chatTextBGView:UIColor!
    var chatTableBGView:UIColor!
    var blockerInfoLabelColor:UIColor!
    var hintInfoLabelColor:UIColor!
    var myQuestionsCellBorderColor:UIColor!
    var playerRecommedationsHeaderBgColor:UIColor!
    var rateNowViewBgColor:UIColor!
    var rateNowViewBgBorderColor:UIColor!
    var rateNowButtonBgColor:UIColor!
    var rateNowButtonBorderColor:UIColor!
    var progressBarTrackColor:UIColor!
    
    var RegisterNavColor: UIColor!
    var viewDivColor: UIColor!
    var langSelBg: UIColor!
    var langSelBorder: UIColor!
    var langUnselBg: UIColor!
    var langUnselBorder: UIColor!
    var textFieldBorderColor: UIColor!
    var rentInfoTextLabelColor: UIColor!
    var expireTextColor: UIColor!
    var transactionSuccessColor : UIColor!
    var isStatusBarWhiteColor : Bool!
    var changeMobileColor : UIColor!
    var watchedProgressTintColor : UIColor!
    var tabBarSelectedText : UIColor!
    var unThemeColor : UIColor!
    var cellBackgorundColor : UIColor!
    var buttonsAndHeaderLblColor : UIColor!
    var buttonsAndHeaderLblColorWhite50 : UIColor!
    var guideDatesTextColor : UIColor!
    var tabBarDimGray : UIColor!
    var lineColor : UIColor!
    var homeCollectionBGColor : UIColor!
    var deSelectedTitleColor : UIColor!
    var tvGuideTimeBackgroundColor : UIColor!
    var downloadingPercentageColor : UIColor!
    var guideArrowsBgGradientColor : UIColor!
    var detailspageChannelBorderColor : UIColor!
    var shortNameBackgroundColor: UIColor!
}

public class ReelDramaTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "1C1124")
        self.themeColor = UIColor.init(hexString: "EB3495")
        self.lineColor = UIColor.init(hexString: "EB3495")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "261C2E")
        self.navigationViewBarColor = UIColor.init(hexString: "281C31")
        self.homeCollectionBGColor = UIColor.init(hexString: "281C31")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "f3f3f6")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor(red: 58/255.0, green: 37/255.0, blue: 72/255.0, alpha: 0.9)
        self.langSelBorder = UIColor.init(hexString: "70428B")
        self.langUnselBg = UIColor.init(hexString: "1C1124")
        self.langUnselBorder = UIColor.init(hexString: "452F53")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "EB3495")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.watchedProgressTintColor = UIColor.init(hexString: "EB3495")
        self.changeMobileColor = UIColor.init(hexString: "EB3495")
        self.tabBarSelectedText = UIColor.init(hexString: "EB3495")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("f3f3f6")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class FirstShowsTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "0F0F1C")
        self.themeColor = UIColor.init(hexString: "d99200")
        self.lineColor = UIColor.init(hexString: "d99200")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "1D1D3E")
        self.navigationViewBarColor = UIColor.init(hexString: "18182F")
        self.homeCollectionBGColor = UIColor.init(hexString: "18182F")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "f3f3f6")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "2C2C70")
        self.langSelBorder = UIColor.init(hexString: "4F4F9D")
        self.langUnselBg = UIColor.init(hexString: "0F0F1C")
        self.langUnselBorder = UIColor.init(hexString: "4F4F9D")
        self.textFieldBorderColor = UIColor.init(hexString: "585858")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "d99200")
        self.watchedProgressTintColor = UIColor.init(hexString: "d99200")
        self.tabBarSelectedText = UIColor.init(hexString: "d99200")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("f3f3f6")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class TsatTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "17191c")
        self.themeColor = UIColor.init(hexString: "e30615")
        self.lineColor = UIColor.init(hexString: "e30615")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "1d1f23")
        self.navigationViewBarColor = UIColor.init(hexString: "1d1f23")
        self.homeCollectionBGColor = UIColor.init(hexString: "1d1f23")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "f3f3f6")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "2C2C70")
        self.langSelBorder = UIColor.init(hexString: "4F4F9D")
        self.langUnselBg = UIColor.init(hexString: "0F0F1C")
        self.langUnselBorder = UIColor.init(hexString: "4F4F9D")
        self.textFieldBorderColor = UIColor.init(hexString: "585858")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "e30615")
        self.watchedProgressTintColor = UIColor.init(hexString: "e30615")
        self.tabBarSelectedText = UIColor.init(hexString: "e30615")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("f3f3f6")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class AasthaLightTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.init(hexString: "414141")
        self.cardSubtitleColor = UIColor.init(hexString: "888888")
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "f4f4f7")
        self.themeColor = UIColor.init(hexString: "cc3300")
        self.lineColor = UIColor.init(hexString: "ffffff")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "cc3300")
        self.navigationViewBarColor = UIColor.init(hexString: "cc3300")
        self.homeCollectionBGColor = UIColor.init(hexString: "fcfafa")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "ffffff")

        self.tvGuideContentCellColor = UIColor.init(hexString: "ffffff")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "f3f3f6")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "e3e3e6")
        tvGuideTimeBackgroundColor = UIColor(hexString: "f3f3f6")
        self.noContentAvailableTitleColor = UIColor.init(hexString: "414141")
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.init(hexString: "414141")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "ffffff")
        self.langSelBorder = UIColor.init(hexString: "7b7b7b")
        self.langUnselBg = UIColor.init(hexString: "f2f2f2")
        self.langUnselBorder = UIColor.init(hexString: "c3c3c3")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "e83d01")
        self.watchedProgressTintColor = UIColor.init(hexString: "d99200")
        self.tabBarSelectedText = UIColor.init(hexString: "cc3300")
        self.cellBackgorundColor = UIColor.white
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("666666")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("f3f3f6")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class AasthaDarkTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.init(hexString: "ffffff")
        self.cardSubtitleColor = UIColor.init(hexString: "b3b3b3")
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.whiteAlpha50
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "cc3300")
        self.lineColor = UIColor.init(hexString: "cc3300")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "222222")
        self.navigationViewBarColor = UIColor.init(hexString: "222222")
        self.navigationBarTextColor = UIColor.white
        self.homeCollectionBGColor = UIColor.init(hexString: "222222")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "1c1c1c")

        self.tvGuideContentCellColor = UIColor.init(hexString: "1c1c1c")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "2e2e2e")
        self.guideTimeBgColor = UIColor.init(hexString: "292929")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "292929")
        self.tvGuideTimeBackgroundColor = UIColor(hexString: "292929")
        self.noContentAvailableTitleColor = UIColor.init(hexString: "414141")
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "ffffff")
        self.langSelBorder = UIColor.init(hexString: "7b7b7b")
        self.langUnselBg = UIColor.init(hexString: "f2f2f2")
        self.langUnselBorder = UIColor.init(hexString: "c3c3c3")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "e83d01")
        self.watchedProgressTintColor = UIColor.init(hexString: "cc3300")
        self.tabBarSelectedText = UIColor.init(hexString: "cc3300")
        self.cellBackgorundColor = UIColor.init(hexString: "222222")
        self.buttonsAndHeaderLblColor = .white
        self.buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        self.tabBarDimGray = UIColor.colorFromHexString("666666")
        self.downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("141414")
        self.detailspageChannelBorderColor = UIColor.colorFromHexString("3c3c3c")
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class GoTVTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "ff2ccd")
        self.lineColor = UIColor.init(hexString: "EB3495")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "222222")
        self.navigationViewBarColor = UIColor.init(hexString: "222222")
        self.navigationBarTextColor = UIColor.white
        self.homeCollectionBGColor = UIColor.init(hexString: "222222")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        self.tvGuideTimeBackgroundColor = UIColor(hexString: "1c1c23")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor(red: 58/255.0, green: 37/255.0, blue: 72/255.0, alpha: 0.9)
        self.langSelBorder = UIColor.init(hexString: "70428B")
        self.langUnselBg = UIColor.init(hexString: "1C1124")
        self.langUnselBorder = UIColor.init(hexString: "452F53")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "EB3495")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.watchedProgressTintColor = UIColor.init(hexString: "EB3495")
        self.changeMobileColor = UIColor.init(hexString: "EB3495")
        self.tabBarSelectedText = UIColor.init(hexString: "EB3495")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("f3f3f6")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}

public class yvsTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "f47200")
        self.lineColor = UIColor.init(hexString: "f47200")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "222222")
        self.navigationViewBarColor = UIColor.init(hexString: "222222")
        self.navigationBarTextColor = UIColor.white
        self.homeCollectionBGColor = UIColor.init(hexString: "222222")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        self.tvGuideTimeBackgroundColor = UIColor(hexString: "1c1c23")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor(red: 58/255.0, green: 37/255.0, blue: 72/255.0, alpha: 0.9)
        self.langSelBorder = UIColor.init(hexString: "70428B")
        self.langUnselBg = UIColor.init(hexString: "1C1124")
        self.langUnselBorder = UIColor.init(hexString: "452F53")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "f47200")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.watchedProgressTintColor = UIColor.init(hexString: "f47200")
        self.changeMobileColor = UIColor.init(hexString: "f47200")
        self.tabBarSelectedText = UIColor.init(hexString: "f47200")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("141414")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}

public class supposetvTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.white
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "97d1ff")
        self.lineColor = UIColor.init(hexString: "97d1ff")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "222222")
        self.navigationViewBarColor = UIColor.init(hexString: "222222")
        self.navigationBarTextColor = UIColor.white
        self.homeCollectionBGColor = UIColor.init(hexString: "222222")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        self.tvGuideTimeBackgroundColor = UIColor(hexString: "1c1c23")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c23")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
       // self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.progressBarTrackColor = UIColor.init(hexString: "97d1ff")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor(red: 58/255.0, green: 37/255.0, blue: 72/255.0, alpha: 0.9)
        self.langSelBorder = UIColor.init(hexString: "70428B")
        self.langUnselBg = UIColor.init(hexString: "1C1124")
        self.langUnselBorder = UIColor.init(hexString: "452F53")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "97d1ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.watchedProgressTintColor = UIColor.init(hexString: "97d1ff")
        self.changeMobileColor = UIColor.init(hexString: "97d1ff")
        self.tabBarSelectedText = UIColor.init(hexString: "97d1ff")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = UIColor.init(hexString: "141414")
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = UIColor.init(hexString: "97d1ff")
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("141414")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class mobitelTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "00b4eb")
        self.lineColor = UIColor.init(hexString: "00b4eb")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "222222")
        self.navigationViewBarColor = UIColor.init(hexString: "222222")
        self.navigationBarTextColor = UIColor.white
        self.homeCollectionBGColor = UIColor.init(hexString: "222222")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "2b2b36")

        self.tvGuideContentCellColor = UIColor.init(hexString: "191922")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        self.tvGuideTimeBackgroundColor = UIColor(hexString: "1c1c23")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c23")
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor(red: 58/255.0, green: 37/255.0, blue: 72/255.0, alpha: 0.9)
        self.langSelBorder = UIColor.init(hexString: "70428B")
        self.langUnselBg = UIColor.init(hexString: "1C1124")
        self.langUnselBorder = UIColor.init(hexString: "452F53")
        self.textFieldBorderColor = UIColor.init(hexString: "898b95")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "00b4eb")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.watchedProgressTintColor = UIColor.init(hexString: "00b4eb")
        self.changeMobileColor = UIColor.init(hexString: "00b4eb")
        self.tabBarSelectedText = UIColor.init(hexString: "00b4eb")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = UIColor.white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = .white
        tabBarDimGray = UIColor.colorFromHexString("46464B")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("141414")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
public class pbnsTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "365CAC")
        self.lineColor = UIColor.init(hexString: "365CAC")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "141414")
        self.navigationViewBarColor = UIColor.init(hexString: "141414")
        self.homeCollectionBGColor = UIColor.init(hexString: "141414")
        self.userProfileTextFieldColor = UIColor.gray
        self.tvGuideDateCellColor = UIColor.init(hexString: "1C1C1C")
        self.tvGuideContentCellColor = UIColor.init(hexString: "141414")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "1C1C1C")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "2C2C70")
        self.langSelBorder = UIColor.init(hexString: "4F4F9D")
        self.langUnselBg = UIColor.init(hexString: "0F0F1C")
        self.langUnselBorder = UIColor.init(hexString: "4F4F9D")
        self.textFieldBorderColor = UIColor.init(hexString: "585858")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "BFD5FB")
        self.watchedProgressTintColor = UIColor.init(hexString: "BFD5FB")
        self.tabBarSelectedText = UIColor.init(hexString: "BFD5FB")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = UIColor.colorFromHexString("365CAC")
        tabBarDimGray = UIColor.colorFromHexString("B2B3B2")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("1C1C1C")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}

public class gacTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.init(hexString: "c5c5c5")
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        if let _appBgColour = AppDelegate.getDelegate().dynamicColorCodes["appBgColour"] as? String {
            self.applicationBGColor = UIColor.init(hexString:_appBgColour)
        }
        else {
            self.applicationBGColor = UIColor.init(hexString: "933a30")
        }
        if let _buttonHighlightedColour = AppDelegate.getDelegate().dynamicColorCodes["buttonHighlightedColour"] as? String {
            self.themeColor = UIColor.init(hexString:_buttonHighlightedColour)
        }
        else {
            self.themeColor = UIColor.init(hexString: "365CAC")
        }
        self.lineColor = UIColor.white
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        
        if let _buttonHighlightedColour = AppDelegate.getDelegate().dynamicColorCodes["buttonHighlightedColour"] as? String {
            self.submenuBgColor = UIColor.init(hexString:_buttonHighlightedColour)
        }
        else {
            self.submenuBgColor = UIColor.init(hexString: "ed6b40")
        }
        
        
        if let _filterHighlighedColour = AppDelegate.getDelegate().dynamicColorCodes["filterHighlighedColour"] as? String {
            self.navigationViewBarColor = UIColor.init(hexString:_filterHighlighedColour)
        }
        else {
            self.navigationViewBarColor = UIColor.init(hexString: "ffb93a")
        }
        if let _buttonHighlightedColour = AppDelegate.getDelegate().dynamicColorCodes["buttonHighlightedColour"] as? String {
            self.homeCollectionBGColor = UIColor.init(hexString:_buttonHighlightedColour)
        }
        else {
            self.homeCollectionBGColor = UIColor.init(hexString: "ed6b40")
        }
        self.userProfileTextFieldColor = UIColor.gray
        self.tvGuideDateCellColor = UIColor.init(hexString: "1C1C1C")
        self.tvGuideContentCellColor = UIColor.init(hexString: "141414")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "1C1C1C")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        if let _filterHighlighedColour = AppDelegate.getDelegate().dynamicColorCodes["filterHighlighedColour"] as? String {
            self.navigationBarColor = UIColor.init(hexString:_filterHighlighedColour)
        }
        else {
            self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        }
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        if let _subMenuHighlighedColour = AppDelegate.getDelegate().dynamicColorCodes["subMenuHighlighedColour"] as? String {
            self.langSelBg = UIColor.init(hexString: _subMenuHighlighedColour)
        }
        else {
            self.langSelBg = UIColor.init(hexString: "2C2C70")
        }
        self.langSelBorder = UIColor.init(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 0.16)
        self.langUnselBg = UIColor.init(hexString: "0F0F1C")
        self.langUnselBorder = UIColor.init(hexString: "4F4F9D")
        self.textFieldBorderColor = UIColor.white
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "BFD5FB")
        self.watchedProgressTintColor = UIColor.init(hexString: "BFD5FB")
        self.tabBarSelectedText = UIColor.init(hexString: "ffffff")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = UIColor.colorFromHexString("365CAC")
        tabBarDimGray = UIColor.white.withAlphaComponent(0.7)
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("1C1C1C")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}


public class airtelSLTheme: AppTheme {
    public override init() {
        super.init()
        self.isStatusBarWhiteColor = true
        self.cardTitleColor = UIColor.white
        self.cardSubtitleColor = UIColor.whiteAlpha50
        self.deSelectedTitleColor = UIColor.whiteAlpha50
        self.chromecastIconColor = UIColor.white
        self.applicationBGColor = UIColor.init(hexString: "141414")
        self.themeColor = UIColor.init(hexString: "365CAC")
        self.lineColor = UIColor.init(hexString: "365CAC")
        self.unThemeColor = UIColor.init(hexString: "303135")
        self.menuSelBgColor = UIColor.init(hexString: "3A2548")
        self.submenuBgColor = UIColor.init(hexString: "be5f49")
        self.navigationViewBarColor = UIColor.init(hexString: "141414")
        self.homeCollectionBGColor = UIColor.init(hexString: "141414")
        self.userProfileTextFieldColor = UIColor.gray
        
        self.tvGuideDateCellColor = UIColor.init(hexString: "1C1C1C")

        self.tvGuideContentCellColor = UIColor.init(hexString: "141414")
        self.tvGuideContentCellBorderColor = UIColor.init(hexString: "323240")
        self.guideTimeBgColor = UIColor.init(hexString: "0c0c14")
        self.tvGuideChannelBgColor = UIColor.init(hexString: "1c1c23")
        tvGuideTimeBackgroundColor = UIColor(hexString: "1C1C1C")
        self.noContentAvailableTitleColor = UIColor.white
        self.plsTryAgainTitleColor = UIColor.white
        self.navigationBarColor = UIColor.init(hexString: "1c1c24")
        self.navigationBarTextColor = UIColor.white
        self.transactionFailedtextColor = UIColor.init(hexString: "ef535d")
        self.chatTextBGView = UIColor.init(hexString: "27272f")
        self.chatTableBGView = UIColor.init(hexString: "1f1f29")
        self.blockerInfoLabelColor = UIColor.init(hexString: "979797")
        self.hintInfoLabelColor = UIColor.init(hexString: "bebec1")
        self.myQuestionsCellBorderColor = UIColor.init(hexString: "939393")
        self.playerRecommedationsHeaderBgColor = UIColor.init(hexString: "16161e")
        self.rateNowViewBgColor = UIColor.init(hexString: "1f1f26")
        self.rateNowButtonBgColor = UIColor.init(hexString: "393941")
        self.rateNowViewBgBorderColor = UIColor.init(hexString: "28282c")
        self.rateNowButtonBorderColor = UIColor.init(hexString: "494957")
        self.progressBarTrackColor = UIColor.init(hexString: "d85956")
        self.viewDivColor = UIColor.init(hexString: "454545")
        self.langSelBg = UIColor.init(hexString: "2C2C70")
        self.langSelBorder = UIColor.init(hexString: "4F4F9D")
        self.langUnselBg = UIColor.init(hexString: "0F0F1C")
        self.langUnselBorder = UIColor.init(hexString: "4F4F9D")
        self.textFieldBorderColor = UIColor.init(hexString: "585858")
        self.rentInfoTextLabelColor = UIColor.init(hexString: "8bc5ff")
        self.expireTextColor = UIColor.init(hexString: "ff0000")
        self.transactionSuccessColor = UIColor.init(hexString: "00d018")
        self.changeMobileColor = UIColor.init(hexString: "BFD5FB")
        self.watchedProgressTintColor = UIColor.init(hexString: "BFD5FB")
        self.tabBarSelectedText = UIColor.init(hexString: "BFD5FB")
        self.cellBackgorundColor = UIColor.clear
        buttonsAndHeaderLblColor = .white
        buttonsAndHeaderLblColorWhite50 = UIColor.whiteAlpha50
        self.guideDatesTextColor = UIColor.colorFromHexString("365CAC")
        tabBarDimGray = UIColor.colorFromHexString("ffffff")
        downloadingPercentageColor = UIColor.colorFromHexString("0091fa")
        self.guideArrowsBgGradientColor = UIColor.colorFromHexString("1C1C1C")
        self.detailspageChannelBorderColor = UIColor.whiteAlpha50
        self.shortNameBackgroundColor = UIColor.colorFromHexString("6687a1")
    }
}
