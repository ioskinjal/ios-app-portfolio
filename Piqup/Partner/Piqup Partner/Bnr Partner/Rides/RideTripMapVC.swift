//
//  RideTripMapVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import GoogleMaps

class RideTripMapVC: BaseVC,GMSMapViewDelegate {
    
    @IBOutlet weak var tripMapView: GMSMapView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navTitle:UILabel!
    
    var pickUpLocation = AddressLocation()
    var dropOffLocation = AddressLocation()
    
    var pickUpMarker = GMSMarker()
    var dropMarker = GMSMarker()
    
    
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
        mapSetup()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navTitle.text = appConts.const.tRIP_MAP
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapSetup(){
        
        let pickupCoordinate = CLLocationCoordinate2D(latitude:Double(pickUpLocation.latitude)!, longitude: Double(pickUpLocation.longitude)!)
        pickUpMarker.position = pickupCoordinate
        pickUpMarker.appearAnimation = .pop
        pickUpMarker.icon = #imageLiteral(resourceName: "pickup_marker")
        pickUpMarker.title = pickUpLocation.location
        pickUpMarker.map = tripMapView
        
        let dropCoordinate = CLLocationCoordinate2D(latitude:Double(dropOffLocation.latitude)!, longitude: Double(dropOffLocation.longitude)!)
        dropMarker.position = dropCoordinate
        dropMarker.appearAnimation = .pop
        dropMarker.icon = #imageLiteral(resourceName: "dropOff_marker")
        dropMarker.title = dropOffLocation.location
        dropMarker.map = tripMapView
        
        
        let bounds = GMSCoordinateBounds.init(coordinate: self.pickUpMarker.position, coordinate: self.dropMarker.position)
        let cameraPosition = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets.init(top: 230, left: 40, bottom: 50, right: 40))
        self.tripMapView.animate(with: cameraPosition)
        
    }
    
    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
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
