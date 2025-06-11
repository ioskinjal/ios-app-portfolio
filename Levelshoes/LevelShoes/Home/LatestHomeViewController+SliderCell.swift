//
//  LatestHomeViewController+SliderCell.swift
//  LevelShoes
//
//  Created by Narayan Mohapatra on 23/06/2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyGif

extension LatestHomeViewController {
    
    private func getImages() -> [UIImage] {
        return [#imageLiteral(resourceName: "hype woman 3"), #imageLiteral(resourceName: "men_hype"), #imageLiteral(resourceName: "1.2_Spotlight_2x_b14c630d-76b6-4217-aed1-8f29e848ff34_900x")]
    }
    
    func getSliderCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell:SliderCell = tableView.dequeueReusableCell(withIdentifier: SliderCell.identifier, for: indexPath) as! SliderCell
        configureSliderCell(cell, with: indexPath)
        return cell
    }
    
    func configureSliderCell(_ cell: SliderCell, with indexPath: IndexPath) {
        if cell.animationView.datasource == nil {
            cell.animationView.datasource = self
        }

        if signInViewHidden == false {
            if isUserLoggedIn() == true {
                cell.bottomConstraint.constant = 170
            } else {
                cell.bottomConstraint.constant = 186
            }
        } else {
            cell.bottomConstraint.constant = 0
        }
        
        cell.parentVC = self
        var src = landingData?._sourceLanding?.dataList
        if isRTL() {
            src?.reverse()
        }
        var source = src?[indexPath.section]

        if currentIndex != 0 && firstTime == true {
            firstTime = false
            cell.animationView.scroll(to: currentIndex, animated: false) {}
        }
        
        if UserDefaults.standard.value(forKey: "country") as? String != "UAE" {
            cell.lblSignedInDesc.text = "Sorry, we don't deliver here at the moment.".localized
            cell.lblSignedInlbl2.text = currentCountry
        } else {
            let strCountry:String = UserDefaults.standard.value(forKey: "country") as! String
            cell.lblSignedInDesc.text = "It seems like you're in".localized + strCountry +   ". You can update your delivery information here.".localized
        }
        if signInViewHidden == true {
            cell.viewSignedIn.isHidden = true
            cell.viewSignIn.isHidden = true
        } else if isUserLoggedIn() {
            cell.viewSignedIn.isHidden = false
            cell.viewSignIn.isHidden = true
        } else {
            cell.viewSignedIn.isHidden = true
            cell.viewSignIn.isHidden = false
        }
        let countryName = "\(UserDefaults.standard.value(forKey: "country") ?? "")"
        cell.lblSignedInlbl2.text = "   \(UserDefaults.standard.value(forKey: "countryName") ?? "")"
        cell.imgFlag?.downloadSdImage(url: "\(UserDefaults.standard.value(forKey: "flagurl") ?? "")" )
        if LSLocationManager.shared.country != "" && countryName.caseInsensitiveCompare(LSLocationManager.shared.country) != ComparisonResult.orderedSame
        {
           //same store
            cell.lblSignedInlbl2.text = "   \(LSLocationManager.shared.country)"
            // cell.imgFlag?.downloadSdImage(url: "\(UserDefaults.standard.value(forKey: "flagurl") ?? "")" )
        }
       // cell.imgFlag?.image = #imageLiteral(resourceName: "Kuwait")
        
        let closeSignView = {
            self.signInViewHidden = true
            self.tblHome.beginUpdates()
            cell.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                if cell.viewSignIn.isHidden == false {
                    cell.viewSignIn.isHidden = true
                } else {
                    cell.viewSignedIn.isHidden = true
                }
                cell.layoutIfNeeded()
            }, completion: nil)
            
            self.tblHome.setNeedsLayout()
            self.tblHome.endUpdates()
        }
        cell.closeSignViewClicked = {
            closeSignView()
        }
        
        cell.closeSignIn = {
            closeSignView()
        }

        //Gender Tab Selection Animations and Funtionality
        if SelectedCat != previousSelectCat {
            var btn: UIButton?
            if SelectedCat.lowercased() == "men"{
                btn = cell.btnMen
            } else if SelectedCat.lowercased() == "women" {
                btn = cell.btnWomen
            } else if SelectedCat.lowercased() == "kids" {
                btn = cell.btnKids
            }
            if let _ = btn {
                cell.enabledButtons(true)
                UIView.animate(withDuration: 0.1, animations: {
                    cell.mainView.alpha = 0
                }) { (finished) in
                    UIView.animate(withDuration: 0.1) {
                        proceed()
                        cell.mainView.alpha = 1
                    }
                }
            }
        }
        previousSelectCat = SelectedCat
               
        func proceed() {
            source = self.landingData?._sourceLanding?.dataList[indexPath.section]
            
            let defaultsLanguage = UserDefaults.standard.value(forKey: string.language) as? String
            for i in 0..<(source?.arraydata.count)! {
                guard let arrayData = source?.arraydata[i] else { continue }
                for j in 0..<(source?.arraydata[i].elements.count)! {
                    guard source?.arraydata[i].status == "1", let element = source?.arraydata[i].elements[j] else { continue }
                    if element.type == "button" {
                        let isButtonExists = !((source?.arraydata[i].elements[j].content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ?? false)
                        if(isButtonExists){
                            cell.btn.isHidden = false
                        }
                        else{
                            cell.btn.isHidden = true
                        }
                        cell.btn.setTitle(source?.arraydata[i].elements[j].content.uppercased(), for: .normal)
                        cell.btn.setBackgroundColor(color: UIColor(hexString: element.background_color), forState: .normal)
                        if element.background_color == ""{
                            let imageView = UIImageView()
                            imageView.downloadSdImage(url: element.background_image
                            )
                            cell.btn.setBackgroundImage(imageView.image, for: .normal)
                            if defaultsLanguage ?? "en" == "en"{
                                cell.btn.addTextSpacing(spacing: 1.5, color:  element.foreground_color)
                            }
                        }
                        
                        if defaultsLanguage == "en" {
                            cell.btn.addTextSpacing(spacing: 1.5, color: element.foreground_color)
                        } else {
                            cell.btn.setTitleColor(UIColor(hexString: element.foreground_color), for: .normal)
                        }
                        
                    }
                    if element.type == "heading" {
                        cell.lblHead.text = element.content
                        cell.lblHead.textColor = UIColor(hexString: element.foreground_color )
                    }
                    if element.type == "subheading"{
                        cell.lblSubHead.text = element.content
                        cell.lblSubHead.textColor = UIColor(hexString: element.foreground_color)
                    }
                }
                
                if arrayData.type == "video" && arrayData.status == "1"{
                    let url = URL(string: source?.arraydata[i].url ?? "") ?? URL(string: "")!
                    if url.absoluteString == "video_url" {
                        
                    } else {
                        player = AVPlayer(url:url)
                        let playerLayer = AVPlayerLayer(player: player)
                        
                        playerLayer.frame = cell.viewSlider!.frame
                        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        playerLayer.zPosition = -1
                        
                        player?.seek(to:kCMTimeZero)
                        player?.play()
                    }
                } else {
                    
                }
            }
            cell.btnGo.addTarget(self, action: #selector(onClickGo), for: .touchUpInside)
            cell.btnGo.tag = indexPath.section
            
            cell.btn.setRadius(2.0)
            cell.btn.tag = indexPath.section
            cell.btn.addTarget(self, action: #selector(onClickbtnSlider(_:)), for: .touchUpInside)
            cell.btn2.addTarget(self, action: #selector(onClickbtnSlider(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            if defaultsLanguage ?? "en" == "en"{
                cell.lblSignedInDesc.addTextSpacing(spacing: 0.5)
                cell.btnWomen.addTextSpacing(spacing: 1.5, color: "FFFFFF")
                cell.btnMen.addTextSpacing(spacing: 1.5, color: "FFFFFF")
                cell.btnKids.addTextSpacing(spacing: 1.5, color: "FFFFFF")
                cell.lblSignedInlbl2.addTextSpacing(spacing: 0.5)
                cell.lblRegisterDesc.addTextSpacing(spacing: 0.5)
                cell.btnGo.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
}

extension LatestHomeViewController: AnimationViewDatasource {
    func numberOfViews(in animationView: AnimationView) -> Int {
        return 3
    }
    
    func animationView(_ animationView: AnimationView, viewForRowAt index: Int) -> UIView {
        var v: UIView
        var gender = indexCat[index] ?? SelectedCat
        //For Initial load *** Modified By: Nitikesh ***
          if previousSelectCat == "" && indexCat[index] != SelectedCat {
              gender = SelectedCat
          }
        let category = gender
        
        if let val = animationView.dequeueReusableView() {
            v = val
        } else {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            v = imgView
        }
        guard let imgView = v as? UIImageView else { return v }
        imgView.image = nil
        var _cachedData = ApiManager.sliderCache[category]?._sourceLanding?.dataList[0].arraydata
        if _cachedData == nil {
            _cachedData = self.landingData?._sourceLanding?.dataList[0].arraydata
        }
        guard let data = _cachedData else { return v }
        var url: URL?
        if data.count > 1 {
            url = URL(string: data[1].url)
        } else {
            url = URL(string: data[0].url)
        }
        imgView.sd_setImage(with: url)
        if let val = url {
            if val.absoluteString.hasSuffix("gif") {
                loadGif(imgView: imgView, url: val)
            } else {
                imgView.sd_setImage(with: val)
            }
            
        }
        return v
    }
    
    private func loadGif(imgView: UIImageView, url: URL) {
        let gifKey = "\(url.absoluteString)"
        if let imgData = UserDefaults.standard.value(forKey: gifKey) as? Data,
            let image = try? UIImage(imageData: imgData) {
            imgView.setGifImage(image!)
        } else if let gifData = try? Data(contentsOf: url), let image = try? UIImage(imageData: gifData) {
            UserDefaults.standard.setValue(gifData, forKey: gifKey)
            imgView.setGifImage(image!)
        } else {
            let loader = UIActivityIndicatorView(activityIndicatorStyle: .white)
            imgView.setGifFromURL(url, customLoader: loader)
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return 0 }
        if source.box_type == "slider_view" {
            let tableHeight = tableView.frame.height
            var h: CGFloat
            if signInViewHidden {
                h = tableHeight
            } else if !signInViewHidden && isUserLoggedIn() == true {
                h = tableHeight + 170
            } else {
                h = tableHeight + 186
            }
            return h
        } else if source.box_type == "box_view" {
//            var h: CGFloat = view.frame.height
            if indexPath.section == 1 {
                var h: CGFloat = tableView.frame.height
//                h = h * 0.8
//                return h
                
//                view.layer.borderWidth = 1
//                view.layer.borderColor = UIColor.red.cgColor
//                return (view.frame.width - 40) / 0.57 + 60 //this is matches with invision proportions width and height of image

                h = h * 0.74 + 50
                return h
            } else {
//                view.layer.borderWidth = 1
//                view.layer.borderColor = UIColor.purple.cgColor

                return (view.frame.width - 40) / 0.76 + 50 //this is matches with invision proportions width and height of image
//                h = h * 0.76 + 50
//                return h
            }
        } else if source.box_type == "product_view" {
            if indexPath.row == 0 {
                return 109
            }

            return 500
        } else if source.box_type == "additionalproduct_view" && indexPath.row == 0 {
            return 122
        }
        return UITableViewAutomaticDimension
    }
}


func isUserLoggedIn() -> Bool {
    guard let _ = UserDefaults.standard.value(forKey: "userToken") else { return false }
    return true
}
