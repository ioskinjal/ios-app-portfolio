//
//  HomeCustomerVC.swift
//  ThumbPin
//
//  Created by NCT109 on 19/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import iOSDropDown
import GooglePlaces
import SDWebImage
import GoogleMobileAds

protocol LoadRequestVC {
    func loadRequestVCMethod()
}

class HomeCustomerVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tblSubCategory: UITableView!{
    didSet{
    tblSubCategory.dataSource = self
    tblSubCategory.delegate = self
    tblSubCategory.tableFooterView = UIView()
    tblSubCategory.separatorStyle = .singleLine
    }
}
    @IBOutlet weak var viewSubCategory: UIView!
    @IBOutlet weak var txtCategory: UITextField!{
        didSet{
            txtCategory.delegate = self
        }
    }
    @IBOutlet weak var tblCategory: UITableView!{
        didSet{
            tblCategory.dataSource = self
            tblCategory.delegate = self
            tblCategory.tableFooterView = UIView()
            tblCategory.separatorStyle = .singleLine
        }
    }
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelServiceNeeded: UILabel!
    @IBOutlet weak var labelTopCategory: UILabel!
    @IBOutlet weak var labelLine: UILabel!{
        didSet {
            labelLine.createCorenerRadius()
        }
    }
    @IBOutlet weak var txtServices: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var collViewTopCategory: UICollectionView!{
        didSet{
            collViewTopCategory.delegate = self
            collViewTopCategory.dataSource = self
            collViewTopCategory.register(TopCategoryCell.nib, forCellWithReuseIdentifier: TopCategoryCell.identifier)
        }
    }
    
    static var storyboardInstance:HomeCustomerVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: HomeCustomerVC.identifier) as? HomeCustomerVC
    }
   
   // var arrSelectedServiceList = [BrowseCategory.CategoryData]()
    var topCategory = TopCategory()
    var arrTopCategory = [TopCategory.CategoryListData]()
    var pageNo = 1
    var isCallApi = "0"
    var lattitude = ""
    var longitude = ""
    var postalcode = ""
    var category_id = ""
    var subcategory_id = ""
    
   // var serviceName = ""
    var browseCategory = BrowseCategory()
     var arrCategory = [BrowseCategory.CategoryData]()
    var subCategory = SubCategory()
    var arrSubCategory = [SubCategory.SubCategoryData]()
    
    override func viewDidLoad() {
        isFromExplore = false
        super.viewDidLoad()
        txtServices.delegate = self
        txtLocation.delegate = self
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
       
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
        self.callApiTopCategoryList()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpLang()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
        if appDelegate?.isLoadMyRequestView == "1" {
            appDelegate?.isLoadMyRequestView = "0"
            self.navigationController?.pushViewController(MyRequestVC.storyboardInstance!, animated: false)
        }else {
            if isCallApi == "0" {
                 callApiGetCategory("")
                
            }else {
                isCallApi = "0"
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func callApiTopCategoryList() {
        let dictParam = [
            "action": Action.getTopCategory,
            "user_id": UserData.shared.getUser()!.user_id,
            "user_type": UserData.shared.getUser()!.user_type,
            "page": pageNo,
            "lId": UserData.shared.getLanguage
        ] as [String : Any]
        ApiCaller.shared.getServiceList(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.collViewTopCategory.backgroundView = bgImage
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.topCategory = TopCategory(dic: dict)
            if self.pageNo > 1 {
                self.arrTopCategory.append(contentsOf: self.topCategory.arrCategoryList)
            }else {
                self.arrTopCategory.removeAll()
                self.arrTopCategory = self.topCategory.arrCategoryList
            }
            if self.arrTopCategory.count != 0{
            self.collViewTopCategory.reloadData()
        }else{
            let bgImage = UIImageView();
            bgImage.image = UIImage(named: "no_data_found");
            bgImage.contentMode = .scaleAspectFit
            bgImage.clipsToBounds = true
            
            self.collViewTopCategory.backgroundView = bgImage
            }
        }
    }
    
    func callApiGetCategory(_ search: String) {
        let dictParam = [
            "action": Action.getCategory,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "user_id": UserData.shared.getUser()!.user_id,
            "keyword": search
            ] as [String : Any]
        ApiCaller.shared.browseCategory(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            self.browseCategory = BrowseCategory(dic: dict)
         //   if self.pageNo > 1 {
           //     self.arrCategory.append(contentsOf: self.browseCategory.arrCategory)
            //}else {
              //  self.arrCategory.removeAll()
                self.arrCategory = self.browseCategory.arrCategory
          //  }
            self.tblCategory.reloadData()
            
        }
    }
    
    func callApiGetSubCategory() {
        
        let dictParam = [
            "action": Action.getSubCategory,
            "lId": UserData.shared.getLanguage,
            "page": pageNo,
            "category_id": category_id,
            "user_id": UserData.shared.getUser()!.user_id,
            "keyword": ""
            ] as [String : Any]
        
       
        ApiCaller.shared.browseSubCategory(vc: self, param: dictParam) { (dict) in
            self.subCategory = SubCategory(dic: dict)
            //if self.pageNo > 1 {
            //  self.arrSubCategory.append(contentsOf: self.subCategory.arrSubCategory)
            //}else {
            //     self.arrSubCategory.removeAll()
            self.arrSubCategory = self.subCategory.arrSubCategory
            //}
            
            
            self.tblSubCategory.reloadData()
        }
        
    }
    
    
    func setUpLang() {
        labelServiceNeeded.text = localizedString(key: "What Service do you need?")
        labelLocation.text = localizedString(key: "Where do you need it?")
        btnGetStarted.setTitle("    \(localizedString(key: "Get Started"))    ", for: .normal)
        labelTopCategory.text = localizedString(key: "Top Category")
        txtServices.placeholder = localizedString(key: "Painter, Dj, Musician")
        txtLocation.placeholder = localizedString(key: "Where do you need it?")
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtLocation {
            isCallApi = "1"
            let placePickerController = GMSAutocompleteViewController()
            placePickerController.delegate = self
            present(placePickerController, animated: true, completion: nil)
        }
        else if textField == txtServices {
            txtServices.resignFirstResponder()
//            let controller = SelectServiceListVC.storyboardInstance!
//            controller.delegate = self
//            controller.arrServiceList = arrServiceList
//            self.addChildViewController(controller)
//            let screenSize: CGRect = UIScreen.main.bounds
//            view.addSubview((controller.view)!)
//            controller.didMove(toParentViewController: self)
//            controller.view.translatesAutoresizingMaskIntoConstraints = true
//            controller.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
//            UIApplication.shared.keyWindow!.bringSubview(toFront: (controller.view)!)
//            (controller.view)?.translatesAutoresizingMaskIntoConstraints = false
//            controller.didMove(toParentViewController: self)
//            NSLayoutConstraint(item: (controller.view)!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: (controller.view)!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: (controller.view)!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: (controller.view)!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
            viewSubCategory.isHidden = false
        }else{
            txtCategory.resignFirstResponder()
            viewCategory.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    
    @IBAction func onClickSubCatSubmit(_ sender: UIButton) {
        txtServices.text = ""
        subcategory_id = ""
        for i in arrSubCategory {
            if i.subCategory.isChecked{
                if txtServices.text == "" && subcategory_id == ""{
                    txtServices.text = i.subCategory.sub_category_name
                    subcategory_id = i.subCategory.sub_category_id
                }else{
                    txtServices.text = txtServices.text! + "," + i.subCategory.sub_category_name
                    subcategory_id = subcategory_id + "," + i.subCategory.sub_category_id
                }
            }
            self.viewSubCategory.isHidden = true
        }
        
    }
    @IBAction func onClickSubmit(_ sender: UIButton) {
        txtCategory.text = ""
        category_id = ""
        for i in arrCategory {
            if i.isChecked{
                if txtCategory.text == "" && category_id == ""{
                    txtCategory.text = i.category_name
                    category_id = i.category_id
                }else{
                    txtCategory.text = txtCategory.text! + "," + i.category_name
                    category_id = category_id + "," + i.category_id
            }
        }
        self.viewCategory.isHidden = true
            pageNo = 1
            self.subCategory = SubCategory()
            self.arrSubCategory = [SubCategory.SubCategoryData]()
            callApiGetSubCategory()
    }
    }
        
    @IBAction func btnMenuAction(_ sender: UIButton) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @IBAction func btnGetStartedAction(_ sender: UIButton) {
        if (txtCategory.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.categoryEmpty)
            return
        }
       else if (txtServices.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.serviceEmpty)
            return
        }
        else if (txtLocation.text?.isEmpty)! {
            AppHelper.showAlertMsg(StringConstants.alert, message: MessageConstants.locationeEmpty)
            return
        }
        let vc = ProviderListVC.storyboardInstance!
        locationDetails = LocationDetails(lattitude: lattitude, longitude: longitude, postalCode: postalcode, address: txtLocation.text!)
        vc.cat_id = category_id
        vc.subCat_id = subcategory_id
        vc.latitude = lattitude
        vc.longitude = longitude
        vc.postal_code = postalcode
        vc.subcategory_name = txtServices.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//extension HomeCustomerVC:ServiceDelegate {
//
//    func dismissServicePopupView(_ name: String,_ serviceid: String, _ servicename: String) {
//        if let nav = self.navigationController, let codeVC = nav.topViewController {
//            print(codeVC.childViewControllers)
//            if codeVC.childViewControllers.count>0{
//
//                for currentContrller in codeVC.childViewControllers {
//                    if currentContrller.isKind(of: HomeCustomerVC.self) {
//                        for currentContrller in currentContrller.childViewControllers {
//                            view.endEditing(true)
//                            txtServices.text  = name
//                            serviceId = serviceid
//                            serviceName = servicename
//                            currentContrller.willMove(toParentViewController: self)
//                            currentContrller.view.removeFromSuperview()
//                            currentContrller.removeFromParentViewController()
//                        }
//                    }
//                }
//            }
//        }
//
//    }
//}
extension HomeCustomerVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place addressComponents: \(String(describing: place.addressComponents))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        let formatedAddre = place.formattedAddress
        //  textFieldLocation.text = formatedAddre
        //  cityName = ""
        //  stateName = ""
        //  countryame = ""
        txtLocation.text = formatedAddre
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    print(field.name)
                //  street_number = field.name
                case kGMSPlaceTypeRoute:
                    print(field.name)
                //route = field.name
                case kGMSPlaceTypeNeighborhood:
                    print(field.name)
                //   neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    print(field.name)
                    //  txtCity.text = field.name
                //   cityName = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    print(field.name)
                    //  txtState.text = field.name
                //   stateName = field.name
                case kGMSPlaceTypeCountry:
                    print(field.name)
                    //  txtCountry.text = field.name
                //  countryame = field.name
                case kGMSPlaceTypePostalCode:
                    print(field.name)
                    //  txtZip.text = field.name
                    postalcode = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    print(field.name)
                    // postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        // filterCustom.latLong = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        //  fillAddress()
        lattitude = "\(place.coordinate.latitude)"
        longitude = "\(place.coordinate.longitude)"
        print(place.coordinate)
        dismiss(animated: true) {
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension HomeCustomerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTopCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategoryCell.identifier, for: indexPath) as? TopCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.labelNameCate.text = arrTopCategory[indexPath.row].category_name
        if let strUrl = arrTopCategory[indexPath.row].category_image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            cell.imgvwCategory.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(named: ""))
            cell.imgvwCategory.sd_setShowActivityIndicatorView(true)
            cell.imgvwCategory.sd_setIndicatorStyle(.gray)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SubCategoryVC.storyboardInstance!
        vc.categoryId = arrTopCategory[indexPath.row].category_id
        vc.categoryName = arrTopCategory[indexPath.row].category_name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = arrTopCategory.count - 1
        let page = topCategory.pagination.current_page
        let numPages = topCategory.pagination.total_pages
        let totalRecords = topCategory.pagination.total
        if indexPath.row == lastElement && page < numPages && indexPath.row < totalRecords - 1 {
            pageNo = page
            pageNo += 1
            callApiTopCategoryList()
        }
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
}

extension HomeCustomerVC:GADBannerViewDelegate{
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
}


extension HomeCustomerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblSubCategory{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleCategoryCell.identifier) as? MultipleCategoryCell else {
                fatalError("Cell can't be dequeue")
            }
            cell.selectionStyle = .default
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblCategory.text = arrSubCategory[indexPath.row].subCategory.sub_category_name
            
            if arrSubCategory[indexPath.row].subCategory.isChecked == true{
                cell.imgcheck.isHidden = false
            }else{
                cell.imgcheck.isHidden = true
            }
            
            return cell
        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MultipleCategoryCell.identifier) as? MultipleCategoryCell else {
            fatalError("Cell can't be dequeue")
        }
        cell.selectionStyle = .default
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        
       cell.lblCategory.text = arrCategory[indexPath.row].category_name
        
        if arrCategory[indexPath.row].isChecked == true{
            cell.imgcheck.isHidden = false
        }else{
            cell.imgcheck.isHidden = true
        }
        
        return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblSubCategory{
        return arrSubCategory.count
        }else{
            return arrCategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblSubCategory{
            if arrSubCategory[indexPath.row].subCategory.isChecked == true{
                arrSubCategory[indexPath.row].subCategory.isChecked = false
            }else{
                arrSubCategory[indexPath.row].subCategory.isChecked = true
            }
            tblSubCategory.reloadData()
        }else{
            if arrCategory[indexPath.row].isChecked == true{
                arrCategory[indexPath.row].isChecked = false
            }else{
                arrCategory[indexPath.row].isChecked = true
            }
            tblCategory.reloadData()
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if arrSelectedServiceList.count != 0{
//        arrSelectedServiceList.remove(at: indexPath.row)
//        arrServiceList[indexPath.row].isChecked = false
//        }
//        tblCategory.reloadData()
//    }
    
    
    
}
