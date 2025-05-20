//
//  FareEstimateVC.swift
//  BooknRide
//
//  Created by KASP on 16/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

// This protocol method is used to close FareEstimate screen
protocol FareEstimateDelegate {
    func dimissFareEstimateClicked()
}

class FareEstimateVC: UIViewController {
    
    var delegate: FareEstimateDelegate?
    var fare:FareEstimate = FareEstimate()
    
    
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropOffAddress: UILabel!
    
    @IBOutlet weak var lblMinFareKm: UILabel!
    
    @IBOutlet weak var lblMinFare: UILabel!
  
    
    @IBOutlet weak var lblPer3KmCharges: UILabel!
    @IBOutlet weak var lblTimeCharges: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalCharges: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var lblTimeChargerPerMin: UILabel!
    
  
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var lblExtraDistanceCharge: UILabel!
    @IBOutlet weak var lblExtraDistance: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var lblFareEstimation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPickUp.text = appConts.const.pICK_UP
        lblDropOff.text = appConts.const.dROP_OFF
        lblFareEstimation.text = appConts.const.fARE_ESTIMATE
        
        lblCarType.text = fare.carTypeName
        
        lblPickupAddress.text = fare.pickUpLocation
        lblDropOffAddress.text = fare.dropOffLocation
        
        lblMinFareKm.text = NSString(format: "\(appConts.const.mINFARE) (%dKm)" as NSString,(fare.fareDistance)) as String
        lblMinFare.text = NSString(format: "$%d",(fare.fareDistanceCharges)) as String
        lblPer3KmCharges.text = NSString(format:"Note: Per KM Charges after (%dKm) is $%d",fare.fareDistance,fare.fareAdditionalCharges) as String
        lblExtraDistance.text = String(format:"%dKm",fare.estimateExtraKm)
        
        lblExtraDistanceCharge.text = String(format:"$%d",fare.fareDistanceCharges)
        lblTotalDistance.text = String(format:"%.1fKm",fare.totalDistance)
        lblTimeCharges.text = NSString(format: "$%d",(fare.fareTimeCharges)) as String
        
       lblTimeChargerPerMin.text = appConts.const.tIME_CHARGE
        lblTotal.text = appConts.const.lBL_TOTAL
        
        do{
            var total:Int = fare.fareDistanceCharges + fare.fareAdditionalCharges
            total = total + Int(Double(fare.timeChargesPerMin))
        
        lblTotalCharges.text = ParamConstants.Currency.currentValue + " " + String(total)
        }
        catch{
            print(error)
            lblTotalCharges.text = ""
        }
        
        closeBtn.setTitle(appConts.const.cLOSE, for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        
        self.delegate?.dimissFareEstimateClicked()
        
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
