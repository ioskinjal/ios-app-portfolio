//
//  CreateEventsVC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CreateEventsVC: BaseViewController {
    
    //MARK: Variables
    var eventImg: UIImage?; var eventImgName: String?
    var currentEventTypeVC:UIViewController?
    var eventData = CreateEvent()
    var isEditMode = false
    
    //MARK: Properties
    static var storyboardInstance:CreateEventsVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: CreateEventsVC.identifier) as! CreateEventsVC
    }
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var lblSubTittle: LabelSemiBold!
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            self.btnAdd.isHidden = true
        }
    }
    @IBOutlet weak var rootContainerView: UIView!
    
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            self.bottomView.shadow(Offset:  CGSize(width: 0, height: -5), redius: 5, opacity: 0.1, color: UIColor.gray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadView(vc: AddEventDetailVC.storyboardInstance)
        //loadView(vc: AddEventLocation.storyboardInstance)
        if isEditMode{
            lblTittle.text = "Edit Flyer"
        }
    }
    
    @IBAction func onClickAdd(_ sender: UIButton) {
        if let currentEvent = currentEventTypeVC as? SelectOrganizerVC{
            currentEvent.openAddOrgVC()
        }else if let currentEvent = currentEventTypeVC as? SelectTicketVC{
            currentEvent.openAddTicketVC()
        }
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        //FIXME: Atert for confirmation of cancel whole precess
        if isEditMode {
            popViewController(animated: true)
        }
        else if eventData.event_title.isEmpty{
            popToHomeViewController(animated: true)
        }else{
            UIApplication.alert(title: "Save this Event?", message: "", actions: ["Cancel","Discard","Save As Draft"], style: [.cancel,.default,.default], type: .actionSheet) { (flag) in
                if flag == 1{ //Discard
                    //pop to home
                    self.popToHomeViewController(animated: true)
                }else if flag == 2{ //Save
                    //Draft API call
                    //FIXME: First name mendetory for draft API call
                    self.saveAsDraft()
                }
            }
        }
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        backFlow()
        DispatchQueue.updateUI_WithDelay {
            sender.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        checkValidation()
        DispatchQueue.updateUI_WithDelay {
            sender.isUserInteractionEnabled = true
        }
    }
    
}

//MARK: Custom functions
extension CreateEventsVC{
    func loadView(vc: UIViewController, isRightToLeft:Bool = true) {
        currentEventTypeVC = vc
        ViewEmbedder.embed(
            withViewController: currentEventTypeVC!,
            parent: self,
            container: self.rootContainerView){ vc in
                // do things when embed complete
                self.rootContainerView.swipeAnimation(direction: ( isRightToLeft ? .rightToLeft : .leftToRight ))
                self.addButtonVisibility()
        }
    }
    
    func addButtonVisibility() {
        switch currentEventTypeVC {
        case is AddEventDetailVC:
            btnBack.isHidden = true
            btnAdd.isHidden = true
        case is SelectOrganizerVC:
            btnBack.isHidden = false
            btnAdd.isHidden = false
        case is SelectTicketVC:
            btnBack.isHidden = false
            btnAdd.isHidden = false
        default:
            btnBack.isHidden = false
            btnAdd.isHidden = true
            break
        }
    }
    
    func backFlow() {
        addButtonVisibility()
        switch currentEventTypeVC {
        case is AddEventDetailVC:
            //No back button
            break
        case is AddEventDateVC:
            loadView(vc: AddEventDetailVC.storyboardInstance, isRightToLeft: false)
            lblSubTittle.text = "Flyers Details".localized
        case is AddEventLocation:
            loadView(vc: AddEventDateVC.storyboardInstance, isRightToLeft: false)
            lblSubTittle.text = "Date & Time".localized
        case is SelectOrganizerVC:
            loadView(vc: AddEventLocation.storyboardInstance, isRightToLeft: false)
            lblSubTittle.text = "Location".localized
        case is SelectTicketVC:
            loadView(vc: SelectOrganizerVC.storyboardInstance, isRightToLeft: false)
            lblSubTittle.text = "Select Organizer".localized
        default:
            break
        }
    }
    
    func checkValidation() {
        
        if let currentEvent = currentEventTypeVC as? AddEventDetailVC{
            if currentEvent.isValidated(){
                let data = currentEvent.setDataForEvent(eventData: &eventData)
                eventImg = data.image; eventImgName = data.iamgeName
                loadView(vc: AddEventDateVC.storyboardInstance)
                lblSubTittle.text = "Date & Time".localized
            }
            //            loadView(vc: AddEventDateVC.storyboardInstance)
        }
        else if let currentEvent = currentEventTypeVC as? AddEventDateVC{
            if currentEvent.isValidated(){
                currentEvent.setDataForEvent(eventData: &eventData)
                loadView(vc: AddEventLocation.storyboardInstance)
                lblSubTittle.text = "Location".localized
            }
            //            loadView(vc: AddEventLocation.storyboardInstance)
        }else if let currentEvent = currentEventTypeVC as? AddEventLocation{
            if currentEvent.isValidated(){
                currentEvent.setDataForEvent(eventData: &eventData)
                loadView(vc: SelectOrganizerVC.storyboardInstance)
                lblSubTittle.text = "Select Organizer".localized
            }
            //            loadView(vc: SelectOrganizerVC.storyboardInstance)
        }else if let currentEvent = currentEventTypeVC as? SelectOrganizerVC{
            if currentEvent.isValidated(){
                currentEvent.setDataForEvent(eventData: &eventData)
                if eventData.is_online == "y"{
                    //Call API
                    callCreateEvent()
                }else{
                    loadView(vc: SelectTicketVC.storyboardInstance)
                    lblSubTittle.text = "Select Ticket".localized
                }
            }
        }else if let currentEvent = currentEventTypeVC as? SelectTicketVC{
            //FIXME: If online event then by pass selection of tickets
            if currentEvent.isValidated(){
                currentEvent.setDataForEvent(eventData: &eventData)
                //Call API
                callCreateEvent()
            }
        }
    }
    
    func saveAsDraft() {
        if let currentEvent = currentEventTypeVC as? AddEventDetailVC{
            currentEvent.saveDataWithOutValidate()
            callSaveDraft()
        }
        else if let currentEvent = currentEventTypeVC as? AddEventDateVC{
            currentEvent.saveDataWithOutValidate()
            callSaveDraft()
        }else if let currentEvent = currentEventTypeVC as? AddEventLocation{
            currentEvent.saveDataWithOutValidate()
            callSaveDraft()
        }else if let currentEvent = currentEventTypeVC as? SelectOrganizerVC{
            currentEvent.saveDataWithOutValidate()
            callSaveDraft()
        }else if let currentEvent = currentEventTypeVC as? SelectTicketVC{
            currentEvent.saveDataWithOutValidate()
            callSaveDraft()
        }
    }
    
    func callSaveDraft() {
        API.shared.callImageAttachment(with: .draftedCreateEvent, viewController: self, param: eventData.dictionaryRepresent, image: eventImg, imageName: eventImgName, withParamName: "event_logo", failer: { (err) in
            print("\(err)")
        }) { (response) in
            let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
            print(dic)
            UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                self.popToHomeViewController(animated: true)
            })
        }
    }
}

//MARK: API methods
extension CreateEventsVC{
    
    func callCreateEvent() {
        if isEditMode{ //let eImg = eventImg, let eImgName = eventImgName{
            API.shared.callImageAttachment(with: .editEventSubmit, viewController: self, param: eventData.dictionaryRepresent, image: eventImg, imageName: eventImgName, withParamName: "event_logo", failer: { (err) in
                print("\(err)")
            }) { (response) in
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                print(dic)
                if let slug = dic["slug"] as? String{
                    UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                        let nextVC = EventPreview.storyboardInstance
                        nextVC.event_slug = slug
                        nextVC.isFromCreateMode = true
                        self.pushViewController(nextVC, animated: true)
                        //TODO:Notify the manage flyer screen for pdate data
                        
                    })
                }
            }
        }else{
            API.shared.callImageAttachment(with: .createEvent, viewController: self, param: eventData.dictionaryRepresent, image: eventImg, imageName: eventImgName, withParamName: "event_logo", failer: { (err) in
                print("\(err)")
            }) { (response) in
                let dic = ResponseHandler.fatchDataAsDictionary(res: response, valueOf: .data)
                print(dic)
                if let slug = dic["slug"] as? String{
                    UIApplication.alert(title: "Success", message: ResponseHandler.fatchDataAsString(res: response, valueOf: .message), completion: {
                        let nextVC = EventPreview.storyboardInstance
                        nextVC.event_slug = slug
                        nextVC.isFromCreateMode = true
                        self.pushViewController(nextVC, animated: true)
                    })
                }
            }
        }
    }
    
}


//        let param:dictionary = [
//            "userid":UserData.shared.getUser()!.userid,
//            "website":"https:://www.gogolewd.com",
//            "event_addr_1":"Ncryped tech. PVT LTD",
//            "event_addr_2":"",
//            "event_country_id":"1",
//            "event_state_id":"2175",
//            "event_city_id":"16377",
//            "event_pincode":"360002",
//            "ticket_ids":"1,2,3",
//            "organizer_ids":"12,17",
//            "event_lat":"9494.5464",
//            "event_long":"5484.548484",
//            "event_title": tfEventTittle._text,
//            "event_type_id": selectedEventTypeId!,
//            "category_id": selectedCategoryId!,
//            "sub_cat_id": selectedSubCategoryId!,
//            "event_desc": textViewMsg._text,
//            "is_online": ( btnYes.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "y" : "n" ),
//            "event_privacy": ( btnPublic.image(for: .normal) == #imageLiteral(resourceName: "radioSelected") ? "Public" : "Private" ),
//            //"event_start_datetime": "",
//            //"event_end_datetime": "",
//            "event_logo": selectedImage!,
//        ]

