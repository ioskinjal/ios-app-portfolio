//
//  SearchMapVC.swift
//  XPhorm
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class SearchMapVC: BaseViewController {

    
    
    static var storyboardInstance:SearchMapVC? {
        return StoryBoard.home.instantiateViewController(withIdentifier: SearchMapVC.identifier) as? SearchMapVC
    }
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self
        }
    }
    
    var searchList = [SearchResultCls.SearchList]()
    var param = [String:Any]()
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "MapView".localized, action: #selector(onClickBack(_:)))
        
//        for i in searchList{
//            var coordinate = CLLocationCoordinate2D()
//            coordinate.longitude = Double(i.longitude) ?? 0.0
//            coordinate.latitude = Double(i.latitude) ?? 0.0
//            let annonation = SearchLocation(title: i.location, coordinate: coordinate)
//             mapView.addAnnotation(annonation)
//        }
//
        var annotationView:MKPinAnnotationView!
        var pointAnnoation:MKAnnotation!
//        for item in searchList{
//
//
//
//            var coordinate = CLLocationCoordinate2D()
//            coordinate.longitude = Double(item.longitude) ?? 0.0
//            coordinate.latitude = Double(item.latitude) ?? 0.0
//                pointAnnoation = SearchLocation(title: item.location, coordinate: coordinate)
//            //3
//       // annotationView.image = #imageLiteral(resourceName: <#T##String#>)
//           annotationView = MKPinAnnotationView(annotation: pointAnnoation, reuseIdentifier: "pin")
//            self.mapView.addAnnotation(annotationView.annotation!)
//        }
        
        for location in searchList {
            let annotation = MKPointAnnotation()
            annotation.title = location.location
            var coordinate = CLLocationCoordinate2D()
            coordinate.longitude = Double(location.longitude) ?? 0.0
            coordinate.latitude = Double(location.latitude) ?? 0.0
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func onClickApplyNow(_ sender: SignInButton) {
        let popVC = SearchResultVC.storyboardInstance!
        param["locationLng"] = longitude
        param["locationLat"] = latitude
        popVC.param = param
        self.navigationController?.pushViewController(popVC, animated: true)
        
    }
    
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SearchMapVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print(annotationTitle)
            latitude =  view.annotation?.coordinate.latitude
            longitude = view.annotation?.coordinate.longitude
        }
    }
}
