//
//  LatestHomeViewController+ImageCell.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 09.07.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

extension LatestHomeViewController {
    func getImageCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return UITableViewCell() }
        let language = UserDefaults.standard.value(forKey: string.language) as? String

        let cell:ImageCell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.scrollView = tableView
        var buttonTitle = ""
        for i in 0..<source.arraydata.count {
            let arrayData = source.arraydata[i]
            for j in 0..<arrayData.elements.count {
                let element = arrayData.elements[j]
                if element.type == "button" {
                    let isButtonExists = !((element.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) )
                    if(isButtonExists){
                        cell.btn.isHidden = false
                    }
                    else{
                        cell.btn.isHidden = true
                    }
                    buttonTitle = element.content.uppercased()
                    cell.btn.setTitle(buttonTitle, for: .normal)
                    cell.btn.setBackgroundColor(color: UIColor(hexString: element.background_color), forState: .normal)
                    if element.background_color == "" {
                        let imageView = UIImageView()
                        imageView.downloadSdImage(url: element.background_image)
                        cell.btn.setBackgroundImage(imageView.image, for: .normal)
                    }
                    if language == "en" {
                        cell.btn.addTextSpacing(spacing: 1.5, color: element.foreground_color)
                    } else {
                        cell.btn.setTitleColor(UIColor(hexString: element.foreground_color), for: .normal)
                    }
                }
//                var flag = ""
//                if language == "en" {
//                    flag = "NEW IN"
//                } else{
//                    flag = "الجديد في"
//                }
                
                if element.type == "heading" {
                    cell.conTopimgview.constant = 20
                    let head = element.content
                    cell.lblHead.text = head
                    cell.lblHead.textColor = UIColor(hexString: element.foreground_color)
                }
                if element.type == "sub-heading" {
                    if element.content == "" {
                        cell.lblSubHead.isHidden = true
                    }
                    cell.lblSubHead.text = element.content
                    cell.lblSubHead.textColor = UIColor(hexString: element.foreground_color)
                }
                cell.imgMain.downloadSdImage(url: arrayData.url)
            }
        }
        

        cell.btn.setRadius(4.0)
        cell.btn.tag = indexPath.section
        cell.btn.addTarget(self, action: #selector(onClickbtnBox(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.parentVC = self
        if language != "en"{
            cell.lblHead.font =  UIFont(name: "Cairo-Light", size: 45)
            cell.lblSubHead.font =  UIFont(name: "Cairo-Regular", size: 16)
            cell.btn.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
        }
        return cell
    }
}
