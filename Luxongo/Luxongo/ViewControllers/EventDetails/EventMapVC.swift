//
//  EventMapVC.swift
//  Luxongo
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleMaps

class EventMapVC: BaseViewController {

    //MARK: Properties
    static var storyboardInstance:EventMapVC {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: EventMapVC.identifier) as! EventMapVC
    }
    
    
    @IBOutlet weak var lblLocation: LabelRegular!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMarketPin()
    }
    
    func setMarketPin() {
       if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
            let lat = Double(eventData.event_lat) ?? 0
            let long = Double(eventData.event_long) ?? 0
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat,long))
            //let imageview = UIImageView()
            
            DispatchQueue.main.async {
                
                let imageUrl:URL = URL(string: eventData.logo)!
                let imageData:NSData = NSData(contentsOf:imageUrl)!
                let image = UIImage(data: imageData as Data)
                marker.icon = self.drawImageWithProfilePic(pp: image ?? #imageLiteral(resourceName: "pinCircle"), image: #imageLiteral(resourceName: "pinCircle"))
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.map = self.mapView
                let startPosition = CLLocationCoordinate2D(latitude: Double(eventData.event_lat) ?? 0, longitude: Double(eventData.event_long) ?? 0)
                self.mapView.animate(to: GMSCameraPosition(latitude: startPosition.latitude, longitude: startPosition.longitude, zoom: 15))
                
                self.lblLocation.text = eventData.add_line_1
        }
       
        }
    }
    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
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
