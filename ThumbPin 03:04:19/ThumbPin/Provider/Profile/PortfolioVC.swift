//
//  PortfolioVC.swift
//  ThumbPin
//
//  Created by NCT109 on 03/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import Photos

class PortfolioVC: UIViewController {

    @IBOutlet weak var collViewPortFolio: UICollectionView!{
        didSet{
            collViewPortFolio.delegate = self
            collViewPortFolio.dataSource = self
            collViewPortFolio.register(PortfolioCollCell.nib, forCellWithReuseIdentifier: PortfolioCollCell.identifier)
            
        }
    }
    
    var imagePicker = UIImagePickerController()
    var seletedDleteIndex : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // NotificationCenter.default.post(name: .setContainerHeight, object:
        //    ["containerHeight":180] as [String:Any])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(arrPortFolio)
        if isConnectedToInternet {
    
        }else {
            print("No! internet is available.")
            let dict = retrieveFromJsonFile()
            let dictuser = dict["user_data"] as? [String:Any] ?? [String:Any]()
            arrPortFolio = ResponseKey.fatchData(res: dictuser, valueOf: .portfolio).ary.map({UserProfile.ProfileData.PortFolio(dic: $0 as! [String:Any])})
            self.collViewPortFolio.reloadData()
        }
        collViewPortFolio.reloadData()
       // callApiGetReview()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationCenter.default.post(name: .setContainerHeight, object: ["containerHeight":220], userInfo: nil)
        
    }
    func callApiAddPortFolio(_ image: UIImage,_ imageName:String) {
        let dictParam = [
            "action": Action.addPortfolio,
            "lId": UserData.shared.getLanguage,
            "user_id": UserData.shared.getUser()!.user_id,
        ] as [String : Any]
        ApiCaller.shared.addPortFolio(vc: self, param: dictParam, withPostImage: image, withPostImageName: imageName, withParamName: "image[]", failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.callApiGetProfile()
        }
    }
    func callApiGetProfile() {
        let dictParam = [
            "action": Action.getProfile,
            "lId": UserData.shared.getLanguage,
            "user_type": UserData.shared.getUser()!.user_type,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.getProfile(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.collViewPortFolio.backgroundView = bgImage
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            let userProfile = UserProfile(dic: dict)
            arrPortFolio = userProfile.profileData.arrPortFolio
            self.collViewPortFolio.reloadData()
        }
    }
    func callApiDeletePortFolio(_ portfolioId: String) {
        let dictParam = [
            "action": Action.deletePortfolio,
            "lId": UserData.shared.getLanguage,
            "portfolioId": portfolioId,
            "user_id": UserData.shared.getUser()!.user_id,
            ] as [String : Any]
        ApiCaller.shared.deletePortFolio(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            AppHelper.showAlertMsg(StringConstants.alert, message: dict["message"] as? String ?? "")
            arrPortFolio.remove(at: self.seletedDleteIndex)
            self.collViewPortFolio.reloadData()
        }
    }
    func shoWMessage(_ message: String) {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: message, preferredStyle: .alert)
        //  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "YES"), style: .default, handler: { _ in
            self.callApiDeletePortFolio(arrPortFolio[self.seletedDleteIndex].portfolio_id)
        }))
        alert.addAction(UIAlertAction(title: localizedString(key: "NO"), style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Open Camera
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            appDelegate?.isCallGetProfileApi = "1"
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            appDelegate?.isCallGetProfileApi = "1"
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            AppHelper.showAlertMsg(StringConstants.alert, message: "Camera is not available")
        }
    }
    func selectPhotoGallery() {
        let alert = UIAlertController(title: StringConstants.alert, message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @objc func pressButtonAddImage(_ sender: UIButton) {
        selectPhotoGallery()
    }
    @objc func pressButtoDelete(_ sender: UIButton) {
        seletedDleteIndex = sender.tag
        shoWMessage(localizedString(key: "Are you sure you want to delete portfolio?"))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PortfolioVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserData.shared.getUser()!.user_type == "2" {
            return arrPortFolio.count + 1
        }else {
            return arrPortFolio.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCollCell.identifier, for: indexPath) as? PortfolioCollCell else {
            fatalError("Cell can't be dequeue")
        }
        if UserData.shared.getUser()!.user_type == "1" {
            cell.imgvwPortFolio.isHidden = false
            cell.btnDelete.isHidden = true
            cell.btnAddimage.isHidden = true
            cell.stackViewAddimage.isHidden = true
            if let strUrl = arrPortFolio[indexPath.row].portfolio_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                cell.imgvwPortFolio.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
                cell.imgvwPortFolio.sd_setShowActivityIndicatorView(true)
                cell.imgvwPortFolio.sd_setIndicatorStyle(.gray)
            }
        }else {
            if indexPath.row == 0 {
                cell.stackViewAddimage.isHidden = false
                cell.imgvwPortFolio.isHidden = true
                cell.btnDelete.isHidden = true
                cell.labelAddImage.text = localizedString(key: "Add Image")
                cell.btnAddimage.isHidden = false
                cell.btnAddimage.tag = indexPath.row
                cell.btnAddimage.addTarget(self, action: #selector(self.pressButtonAddImage(_:)), for: .touchUpInside)
            }else {
                cell.imgvwPortFolio.isHidden = false
                cell.btnDelete.isHidden = false
                cell.btnAddimage.isHidden = true
                cell.stackViewAddimage.isHidden = true
                if let strUrl = arrPortFolio[indexPath.row-1].portfolio_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    cell.imgvwPortFolio.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
                    cell.imgvwPortFolio.sd_setShowActivityIndicatorView(true)
                    cell.imgvwPortFolio.sd_setIndicatorStyle(.gray)
                }
                cell.btnDelete.tag = indexPath.row - 1
                cell.btnDelete.addTarget(self, action: #selector(self.pressButtoDelete(_:)), for: .touchUpInside)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
  /*  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = arrPortFolio.count - 1
        let page = topCategory.pagination.current_page
        let numPages = topCategory.pagination.total_pages
        let totalRecords = topCategory.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiTopCategoryList()
        }
        
    } */
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}
extension PortfolioVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
          //  if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
               // let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                //let asset = result.firstObject
           
                let imageName =  picker.getPickedFileName(info: info) ?? "image.jpeg"
                print(imageName)
                callApiAddPortFolio(pickedImage, imageName)
           // }
        }
        dismiss(animated: true, completion:nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
