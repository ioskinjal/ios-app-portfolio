//
//  RideRequest4VC.swift
//  Carry
//
//  Created by NCrypted on 20/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RideRequest4VC: BaseVC {

    @IBOutlet weak var carCollectionView: UICollectionView!{
        didSet{
            carCollectionView.delegate = self
            carCollectionView.dataSource = self
            carCollectionView.register(CarTypeCellCollectionViewCell.nib, forCellWithReuseIdentifier: CarTypeCellCollectionViewCell.identifier)
        }
    }
      let brandPickerView = UIPickerView()
    @IBOutlet weak var txtBrand: UITextField!{
        didSet{
            brandPickerView.delegate = self
            txtBrand.inputView = brandPickerView
            txtBrand.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
     let subCarPickerView = UIPickerView()
    @IBOutlet weak var txtSubType: UITextField!{
        didSet{
            subCarPickerView.delegate = self
            txtSubType.inputView = subCarPickerView
            txtSubType.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
   
    var selectedIndex:Int = -1
   
     var carTypes:NSMutableArray = []
    var subCarsType:NSMutableArray = []
    var brandList : NSMutableArray = []
    var carIndexPath = IndexPath(item: -1, section: 1)
    var selectedCar = Car()
    var finalSelectedCar = Car()
    var selectedSubCar = SubCar()
    var selectedBrandId = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCars()
        callgetBrands()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Get Cars for user
    func loadCars(){
        
        startIndicator(title: "")
        
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getCarType, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                print("Items \(dataAns)")
                
                let cars = Car.initWithResponse(array: (dataAns as! [Any]))
                
                self.carTypes = (cars as NSArray).mutableCopy() as! NSMutableArray
                //self.menuItems.addObjects(from: cars)
                //self.menuItems.addObjects(from: cars)
                if self.carTypes.count != 0{
                    self.carCollectionView.reloadData()
                }
                
            }
            else{
                DispatchQueue.main.async {
                    
                    self.carIndexPath = IndexPath(item: -1, section: 1)
                    self.carCollectionView.reloadData()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    func callgetSubcarType(){
        startIndicator(title: "")
        
        
        let alert = Alert()
        
        let param = ["carTypeId":finalSelectedCar.typeId]
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getSubCarType, parameters:param, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                print("Items \(dataAns)")
                
                let cars = SubCar.initWithResponse(array: (dataAns as! [Any]))
                
                self.subCarsType = (cars as NSArray).mutableCopy() as! NSMutableArray
                //self.menuItems.addObjects(from: cars)
                //self.menuItems.addObjects(from: cars)
                if self.subCarsType.count != 0{
                    self.stopIndicator()
                    if self.subCarsType.count != 0{
                        self.subCarPickerView.reloadAllComponents()
                    }
                }
                
            }
            else{
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    func callgetBrands(){
        startIndicator(title: "")
        
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Car.getbrands, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                self.brandList.addObjects(from: jsonDict?.value(forKey: "dataAns") as! [Any])
                
                
                //self.menuItems.addObjects(from: cars)
                //self.menuItems.addObjects(from: cars)
                if self.brandList.count != 0{
                    self.brandPickerView.reloadAllComponents()
                }
                
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }

    @IBAction func onClickRequestNow(_ sender: UIButton) {
        if selectedCar.typeId == "" {
            self.alert(title: "", message: "please select car type")
        }else if selectedSubCar.typeId == "" {
            self.alert(title: "", message: "please select sub car type")
        }else if selectedBrandId == "" {
            self.alert(title: "", message: "please select brand")
        }else{
        dictParam["carTypeId"] = finalSelectedCar.typeId
        dictParam["subCarTypeId"] = selectedSubCar.typeId
        dictParam["vehicleBrand"] = selectedBrandId
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let requestRideVC2 = storyBoard.instantiateViewController(withIdentifier: "RideNowVC") as! RideNowVC
        self.navigationController?.pushViewController(requestRideVC2, animated: true)
        }
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

extension RideRequest4VC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return carTypes.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarTypeCellCollectionViewCell.identifier, for: indexPath) as? CarTypeCellCollectionViewCell else {
            fatalError("Cell can't be dequeue")
        }

        if selectedIndex == indexPath.row{
            cell.lblName.textColor = UIColor(red: 209, green: 47, blue: 54)
        }else{
            cell.lblName.textColor = UIColor.black
        }
        selectedCar = carTypes.object(at: indexPath.row) as! Car
        let imageUrl = URLConstants.Domains.CarUrl+"\(selectedCar.typeId)/"+selectedCar.typeImage
        let cache = UIImageView.af_sharedImageDownloader.imageCache;
        
        let url = NSURL(string: imageUrl)!
        
        
        // Retrieve image from memory or disk.
        let req = URLRequest(url: url as URL)
        if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
            // Image is set the second time imageForRequest is called.
            cell.imgView.image = cacheImage
           // selectedCell.carActivityIndicator.stopAnimating()
            //print("image in cache!");
        } else {
           // selectedCell.carActivityIndicator.startAnimating()
            cell.imgView.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
                if response.data != nil {
                    
                    let downloadedImage = UIImage.init(data: response.data!)
                    if downloadedImage != nil{
                        cell.imgView.image = downloadedImage;
                        
                    }
                    else{
                        cell.imgView.image = #imageLiteral(resourceName: "rides_icon")
                        
                    }
                    
                    cell.imgView.contentMode = .scaleAspectFit
                    cell.clipsToBounds = true
                    self.stopIndicator()
                    //selectedCell.carActivityIndicator.stopAnimating()
                }
                else{
                    // Default image if no data found
                    
                }
            })
            
            // Image is always nil the first time imageForRequest is called per app launch.
            // (even if the image has been cached to disk from a previous launch).
            // print("image somehow not in cache?");
        }
        cell.lblName.text = selectedCar.typeName
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        finalSelectedCar = carTypes.object(at: indexPath.row) as! Car
        carCollectionView.reloadData()
        callgetSubcarType()
     }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 145)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension RideRequest4VC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == subCarPickerView{
        return subCarsType.count
        }else{
            return brandList.count
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == subCarPickerView{
           selectedSubCar = subCarsType.object(at: row) as! SubCar
            txtSubType.text = selectedSubCar.subTypeName
        }else{
            let dict:NSDictionary = brandList[row] as! NSDictionary
            selectedBrandId = String(format: "%d", dict.value(forKey: "brandId")as! Int)
            txtBrand.text = (dict.value(forKey: "brandName")as? String)!
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        var name = String()
       
        if pickerView == subCarPickerView{
        selectedSubCar = subCarsType.object(at: row) as! SubCar
        name = selectedSubCar.subTypeName
        }else{
           let dict:NSDictionary = brandList[row] as! NSDictionary
          name = (dict.value(forKey: "brandName")as? String)!
        }
        
        let str = name
        label.text = str
        
        return label
    }
    
}


