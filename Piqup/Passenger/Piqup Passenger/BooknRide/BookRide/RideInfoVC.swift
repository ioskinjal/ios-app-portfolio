//
//  RideInfoVC.swift
//  BooknRide
//
//  Created by NCrypted on 01/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMaps
import WebKit
class RideInfoVC: BaseVC ,WKNavigationDelegate{
    
    static var storyboardInstance:RideInfoVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: RideInfoVC.identifier) as? RideInfoVC
    }
    
    @IBOutlet weak var viewPerson: UIView!{
        didSet{
            viewPerson.layer.borderColor = UIColor.lightGray.cgColor
            viewPerson.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var panicView: UIView!
    @IBOutlet weak var tripMapView: GMSMapView!
    @IBOutlet weak var lblDriverName: UILabel!
   @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblSubCarType: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
  //  @IBOutlet weak var lblTripDate: UILabel!
    //@IBOutlet weak var lblTripTime: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverContact: UILabel!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var lblSenderEmail: UILabel!
    @IBOutlet weak var lblSenderContact: UILabel!
    @IBOutlet weak var lblLogisticName: UILabel!
    @IBOutlet weak var lblLogisticEmail: UILabel!
    @IBOutlet weak var lblLogisticContact: UILabel!
    @IBOutlet weak var lblEstimateHour: UILabel!
    @IBOutlet weak var lblCharges: UILabel!
    @IBOutlet weak var lblRupee: UILabel!
    
    @IBOutlet weak var viewSenderEmail: UIView!{
        didSet{
            viewSenderEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderEmail.layer.borderWidth = 1.0
        }
    }
   
    
    @IBOutlet weak var viewLogisticsContact: UIView!{
        didSet{
            viewLogisticsContact.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var lblLogisticsEmail: UILabel!
    @IBOutlet weak var viewLogisticsEmail: UIView!
        {
        didSet{
            viewLogisticsEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsEmail.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewLogisticsName: UIView!
        {
        didSet{
            viewLogisticsName.layer.borderColor = UIColor.lightGray.cgColor
            viewLogisticsName.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewSenderContact: UIView!{
        didSet{
            viewSenderContact.layer.borderColor = UIColor.lightGray.cgColor
            viewSenderContact.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewsendername: UIView!{
        didSet{
            viewsendername.layer.borderColor = UIColor.lightGray.cgColor
            viewsendername.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var viewDriverContact: UIView!{
        didSet{
            viewDriverContact.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverContact.layer.borderWidth = 1.0
        }
    }
   
    @IBOutlet weak var viewDriverEmail: UIView!{
        didSet{
            viewDriverEmail.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverEmail.layer.borderWidth = 1.0
        }
    }
   
    @IBOutlet weak var viewDriverName: UIView!{
        didSet{
            viewDriverName.layer.borderColor = UIColor.lightGray.cgColor
            viewDriverName.layer.borderWidth = 1.0
        }
    }
    
    
    @IBOutlet weak var lblPerson: UILabel!
    //@IBOutlet weak var viewTripDate: UIView!{
       // didSet{
         ///   viewTripDate.addDashedBorder()
        //}
    //}
//@IBOutlet weak var viewTripTime: UIView!{
  ///      didSet{
     //       viewTripTime.addDashedBorder()
       // }
    //}
    
    let webView = WKWebView()
    var selecteRide:Rides?
    var rideInfo = RideInfo()
    var pdfLink:String?
    
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserRideInfo()
       // let array:NSArray = selecteRide!.createdDateTimeFormatted.components(separatedBy: ",") as NSArray
        
        //self.lblTripDate.text = array[0] as? String
       // self.lblTripTime.text = array[1] as? String
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPanicClicked(_ sender: Any) {
        
        getPanicNumber()
    }
    
    func getPanicNumber(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":self.sharedAppDelegate().currentUser?.uId as Any,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Panic.getPanicNumber, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                _ = jsonDict?.object(forKey: "message") as! String
                
                if status == true {
                    DispatchQueue.main.async {
                        
                        let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                        let dataDict = dataAns[0] as! NSDictionary
                        let panicNo:String = String(format:"%@",dataDict.object(forKey: "userPanicNo") as! CVarArg)
                        
                        if panicNo.isEmpty{
                            alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.MSG_PANIC_UPDATE    , buttonTitleStr: appConts.const.bTN_OK)
                            return
                        }
                        
                        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: String(format:"\(appConts.const.lBL_CALL) %@",panicNo), leftButtonTitle: appConts.const.cANCEL, rightButtonTitle: appConts.const.lBL_CALL, leftCompletionBlock: {
                            
                        }, rightCompletionBlock: {
                            let url = NSURL(string: "tel://\(panicNo)")
                            UIApplication.shared.openURL(url! as URL)
                            self.setPanicRide()
                        })
                        
                    }
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func setPanicRide(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "rideId":selecteRide!.rideId,
            "lId":Language.getLanguage().id
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Panic.setPaniceRide, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            //let jsonDict = json as NSDictionary?
            
            //let status = jsonDict?.object(forKey: "status") as! Bool
            //let message = jsonDict?.object(forKey: "message") as! String
            
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    func getUserRideInfo(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser!.uId,
                "rideId":selecteRide!.rideId,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Ride.getUserRideInfo, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    print("Items \(dataAns)")
                   // let pdfPath = jsonDict!["rideSummary"]! as! String
                   // self.pdfLink = URLConstants.Domains.pdfDownload + pdfPath
                    
                    self.rideInfo = RideInfo.initWithResponse(dictionary: dataAns as? [String : Any])
                    
                    DispatchQueue.main.async {
                        
                        self.display(tripdetails: self.rideInfo)
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
        }else{
            displayNetworkAlert()
        }
    }
    
    func display(tripdetails:RideInfo){
        
        // Mapping markers
        let pickUpMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(tripdetails.pickUpLat)!, Double(tripdetails.pickUpLong)!))
        
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.map = tripMapView
        
        let dropMarker:GMSMarker = GMSMarker.init(position: CLLocationCoordinate2DMake(Double(tripdetails.dropOffLat)!, Double(tripdetails.dropOffLong)!))
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.map = tripMapView
        
        let bounds = GMSCoordinateBounds.init(coordinate: pickUpMarker.position, coordinate: dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 20, left: 40, bottom: 20, right: 40))
        self.tripMapView.animate(with: cameraPosition)
        self.lblPickUpLocation.text = tripdetails.pickUpLocation
        self.lblDropLocation.text = tripdetails.dropOffLocation
        self.lblDriverName.text = tripdetails.driverName
        self.lblDriverEmail.text = tripdetails.driverEmail
        self.lblDriverContact.text = tripdetails.driverContact
        self.lblSenderName.text = tripdetails.senderName
        self.lblSenderEmail.text = tripdetails.senderEmail
        self.lblSenderContact.text = tripdetails.senderPhone
        self.lblLogisticName.text = tripdetails.logistic_category_name
        self.lblPerson.text = tripdetails.number_of_extra_person_required
        self.lblLogisticEmail.text = tripdetails.weight
        if tripdetails.height == "N/A" {
            self.lblLogisticContact.text = "N/A"
        }else{
        self.lblLogisticContact.text = tripdetails.height + "in x " + tripdetails.width + "in x " + tripdetails.breadth + "in"
        }
        let array:NSArray = tripdetails.driverArrivelTime.components(separatedBy: " ") as NSArray
        self.lblEstimateHour.text = array[0] as? String
        self.lblCharges.text = tripdetails.perMinRate
        self.lblRupee.text = tripdetails.minFareKmRate
        // Driver Information
        lblDriverName.text = tripdetails.driverName
      
        
        // Car Information
        lblCarType.text = tripdetails.carName
        lblSubCarType.text = tripdetails.typeName
        let carImageUrl:String = URLConstants.Domains.CarUrl+tripdetails.typeImage
        self.carImgView.af_setImage(withURL: URL(string: carImageUrl)!)
       
        
       
       // self.downloadDriverCar(imageUrl: URLConstants.Domains.SubCarUrl+tripdetails.subTypeImage)
        
    }
    
    
//    func downloadDriverCar(imageUrl:String){
//
//        // Download image or fetch from cache.
//        let cache = UIImageView.af_sharedImageDownloader.imageCache;
//
////        let url = NSURL(string: imageUrl)!
////
////        // Retrieve image from memory or disk.
////        let req = URLRequest(url: url as URL)
////        if let cacheImage:Image = cache?.image(for: req, withIdentifier: nil){
////            // Image is set the second time imageForRequest is called.
////            carImgView.image = cacheImage
////            //print("image in cache!");
////        } else {
////
////            carImgView.af_setImage(withURL: url as URL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false, completion: { (response) in
////                if response.data != nil {
////
////                    let downloadedImage = UIImage.init(data: response.data!)
////                    self.carImgView.image = downloadedImage;
////
////                }
////                else{
////                   self.carImgView.image = #imageLiteral(resourceName: "Vehicle1")
////
////                }
////            })
////            // Image is always nil the first time imageForRequest is called per app launch.
////            // (even if the image has been cached to disk from a previous launch).
////            //print("image somehow not in cache?");
////        }
//    }
//
    func cancelTrip(){
        
        startIndicator(title: "")
        
        let parameters: Parameters = [
            "userId":sharedAppDelegate().currentUser!.uId,
            "rideId":selecteRide!.rideId,
            "userType":"u",
            "isCompletedRide":"n",
            "lId":Language.getLanguage().id
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Cancel.cancelRide, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                //print("Items \(dataAns)")
                
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    
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
    
    func uploadiCloud(){
        if let pdfLink = pdfLink{
            if let linkPDF =  pdfLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                if let url = URL(string: linkPDF){
                    Downloader.loadFileAsync(url: url) { (str, err) in
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        if err == nil, str != nil{
                            print("Download: \(str!)")
                            
                            //https://medium.com/ios-os-x-development/icloud-drive-documents-1a46b5706fe1
                            //TODO: Save file into iCloude
                            CloudDataManager.sharedInstance.copyFileToCloud()
                            
                            let ac = UIAlertController(title: "Saved!", message: appConts.const.MSG_iCLOUD, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: appConts.const.bTN_OK, style: .default, handler: { (action) in
                                if let pdfVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowPDFViewController") as? ShowPDFViewController{
                                    pdfVC.link = pdfLink
                                    
                                    self.navigationController?.pushViewController(pdfVC , animated: true)
                                }
                            }))
                            self.present(ac, animated: true, completion: nil)
                        }
                        else{
                            let ac = UIAlertController(title: appConts.const.MSG_SAVE_ERROR    , message: err?.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: appConts.const.bTN_OK, style: .default, handler: nil))
                            self.present(ac, animated: true, completion: nil)
                            print("Error in Save Attachment")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnTrackTripClicked(_ sender: Any) {
        
        let trackVC =  TrackRideNowVC(nibName: "TrackRideNowVC", bundle: nil)
        trackVC.rideId = selecteRide?.rideId
        trackVC.currentRideInfo = rideInfo
        self.navigationController?.pushViewController(trackVC, animated: true)
    }
    
    
    @IBAction func btnCancelTripClicked(_ sender: Any) {
        cancelTrip()
    }
    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
    }
    
    
}

class Downloader {
    
    //https://stackoverflow.com/questions/28219848/how-to-download-file-in-swift
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let newDir = documentsUrl.appendingPathComponent("BooknRide").path
        if !FileManager().fileExists(atPath: newDir){
            do {
                try FileManager.default.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error : \(error.localizedDescription)")
            }
        }
        
        let destinationUrl = documentsUrl.appendingPathComponent("BooknRide/\(url.lastPathComponent)")
        if FileManager().fileExists(atPath: destinationUrl.path){
            completion(destinationUrl.path, nil)
        }
        else{
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:{
                data, response, error in
                if error == nil{
                    if let response = response as? HTTPURLResponse{
                        if response.statusCode == 200{
                            if let data = data{
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                    completion(destinationUrl.path, error)
                                }
                                else{
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else{
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else{
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}

//https://stackoverflow.com/questions/33886846/best-way-to-use-icloud-documents-storage
class CloudDataManager {
    
    static let sharedInstance = CloudDataManager() // Singleton
    
    struct DocumentsDirectory
    {
        static let localDocumentsURL = (FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!).appendingPathComponent("BooknRide")
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL!
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool
    {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    // Delete All files at URL
    
    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {
            print("file : ",file)
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    // Copy local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging
    
    func copyFileToCloud()
    {
        if isCloudEnabled()
        {
            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            // iCloude folder cerate
            //            let newDir = DocumentsDirectory.iCloudDocumentsURL?.appendingPathComponent("BooknRide1").path
            //            if !fileManager.fileExists(atPath: newDir!){
            //                do {
            //                    try fileManager.createDirectory(atPath: newDir!, withIntermediateDirectories: true, attributes: nil)
            //                } catch {
            //                    print("Icloude Error : \(error.localizedDescription)")
            //                }
            //            }
            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear all files in iCloud Doc Dir
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                do {
                    print("File  : ", file)
                    print("Extension : ", DocumentsDirectory.localDocumentsURL.appendingPathComponent(file).pathExtension)
                    
                    try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    print("Copied to iCloud")
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    // Copy iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    func copyFileToLocal() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL)
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))
                    
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }
}


extension String{
    mutating func removeSpecificCharFromString(removeString:String) {
        if self.contains(removeString){
            self = self.replacingOccurrences(of: removeString, with: "")
        }
    }
}
