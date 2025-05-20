//
//  DataModel.swift
//  ThumbPin
//
//  Created by NCT109 on 17/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginData: NSObject {
    
    private let keys = ["user_id","user_type","user_email","user_name","user_location","user_image","is_user_type_set","is_first_time","notification_count","message_count","disp_text","status","message"]
    
    @objc var user_id: String = ""
    @objc var user_type: String = ""
    @objc var user_email: String = ""
    @objc var user_name: String = ""
    @objc var user_location: String = ""
    @objc var user_image: String = ""
    @objc var is_user_type_set: String = ""
    @objc var is_first_time: String = ""
    @objc var notification_count: String = ""
    @objc var message_count: Int = 0
    @objc var disp_text: String = ""
    @objc var status: Bool = false
    @objc var message: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        user_id = dic["user_id"] as? String ?? ""
        user_type = dic["user_type"] as? String ?? ""
        user_email = dic["user_email"] as? String ?? ""
        user_name = dic["user_name"] as? String ?? ""
        user_location = dic["user_location"] as? String ?? ""
        user_image = dic["user_image"] as? String ?? ""
        is_user_type_set = dic["is_user_type_set"] as? String ?? ""
        is_first_time = dic["is_first_time"] as? String ?? ""
        notification_count = dic["notification_count"] as? String ?? ""
        message_count = dic["message_count"] as? Int ?? 0
        disp_text = dic["disp_text"] as? String ?? ""
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
    }
    
    init(userData dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
        //self.isProvider = ( (dic["user_type"] as? String ?? "") == "p" ? true : false )
    }
    
    //This variable use for Convert Any Class type object into Dictionary type (Class properties become a Key in Dictionry and same for values also)
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
}
class ServiceList: NSObject {
    
    @objc var service_name: String = ""
    @objc var service_id: String = ""
    @objc var isChecked: Bool = false
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        service_name = dic["service_name"] as? String ?? ""
        service_id = dic["service_id"] as? String ?? ""
        isChecked = dic["isChecked"] as? Bool ?? false
    }
}
class TopCategory: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var notification_count: Int = 0
    @objc var message_count: Int = 0
    @objc var disp_text: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrCategoryList = [CategoryListData]()
    @objc var topCollectionPagin = PaginDetailsData()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        notification_count = dic["notification_count"] as? Int ?? 0
        message_count = dic["message_count"] as? Int ?? 0
        disp_text = dic["disp_text"] as? String ?? ""
        arrCategoryList = (json["cate_list"].arrayObject ?? [Any]()).map({CategoryListData(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class CategoryListData: NSObject {
        
        @objc var category_id: String = ""
        @objc var category_name: String = ""
        @objc var category_image: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            category_id = dic["category_id"] as? String ?? ""
            category_name = dic["category_name"] as? String ?? ""
            category_image = dic["category_image"] as? String ?? ""
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class UserProfile: NSObject {
    
    @objc var status: Bool = false
    @objc var type: String = ""
    @objc var message: String = ""
    @objc var notification_count: Int = 0
    @objc var message_count: Int = 0
    @objc var disp_text: String = ""
    @objc var profileData = ProfileData()
    @objc var abn_num_verified: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        type = dic["type"] as? String ?? ""
        message = dic["message"] as? String ?? ""
        notification_count = dic["notification_count"] as? Int ?? 0
        message_count = dic["message_count"] as? Int ?? 0
        disp_text = dic["disp_text"] as? String ?? ""
        profileData = ProfileData(dic:json["data"].dictionaryObject!)
        abn_num_verified = dic["abn_num_verified"] as? String ?? ""
    }
    class ProfileData: NSObject {
        @objc var user_id: String = ""
        @objc var languages: String = ""
        @objc var user_email: String = ""
        @objc var user_contact: String = ""
        @objc var user_type: String = ""
        @objc var user_name: String = ""
        @objc var user_location: String = ""
        @objc var user_image: String = ""
        @objc var user_desc: String = ""
        @objc var latitude: String = ""
        @objc var longitude: String = ""
        @objc var pincode: String = ""
        @objc var user_rating: String = ""
        @objc var uesr_no_review: String = ""
        @objc var user_total_quote: String = ""
        @objc var user_total_quote_completed: String = ""
        @objc var arrPortFolio = [PortFolio]()
         @objc var abn_num_verified: String = ""
        @objc var receive_msg: String = ""
        @objc var abn_num: String = ""
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
            abn_num = dic["abn_num"] as? String ?? ""
            user_id = dic["user_id"] as? String ?? ""
            languages = dic["languages"] as? String ?? ""
            user_email = dic["user_email"] as? String ?? ""
            user_contact = dic["user_contact"] as? String ?? ""
            user_type = dic["user_type"] as? String ?? ""
            user_name = dic["user_name"] as? String ?? ""
            user_location = dic["user_location"] as? String ?? ""
            user_image = dic["user_image"] as? String ?? ""
            user_desc = dic["user_desc"] as? String ?? ""
            latitude = dic["latitude"] as? String ?? ""
            longitude = dic["longitude"] as? String ?? ""
            pincode = dic["pincode"] as? String ?? ""
            user_rating = dic["user_rating"] as? String ?? ""
            uesr_no_review = dic["uesr_no_review"] as? String ?? ""
            user_total_quote = dic["user_total_quote"] as? String ?? ""
            user_total_quote_completed = dic["user_total_quote_completed"] as? String ?? ""
            arrPortFolio = (json["portfolio"].arrayObject ?? [Any]()).map({PortFolio(dic: $0 as! [String:Any])})
            abn_num_verified = dic["abn_num_verified"] as? String ?? ""
             receive_msg = dic["receive_msg"] as? String ?? ""
        }
        
        class PortFolio: NSObject {
            
            @objc var portfolio_id: String = ""
            @objc var portfolio_image: String = ""
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                portfolio_id = dic["portfolio_id"] as? String ?? ""
                portfolio_image = dic["portfolio_image"] as? String ?? ""
            }
        }
    }
}
class MyRequest: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrMyRequest = [MyRequestData]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrMyRequest = (json["projects"].arrayObject ?? [Any]()).map({MyRequestData(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class MyRequestData: NSObject {
        
        @objc var service_id: String = ""
        @objc var service_name: String = ""
        @objc var project_desc: String = ""
        @objc var project_date: String = ""
        @objc var service_status: String = ""
        @objc var service_status_code: Int = 0
        @objc var is_updatable: String = ""
        @objc var disp_text: String = ""
        @objc var arrProviderList = [ProviderList]()
        @objc var categoryList = [CategoryList]()
        @objc var subCategoryList = [SubCategoryList]()
        @objc var materialName = [MaterialName]()
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
            service_id = dic["service_id"] as? String ?? ""
            service_name = dic["service_name"] as? String ?? ""
            project_desc = dic["project_desc"] as? String ?? ""
            project_date = dic["project_date"] as? String ?? ""
            service_status = dic["service_status"] as? String ?? ""
            service_status_code = dic["service_status_code"] as? Int ?? 0
            is_updatable = dic["is_updatable"] as? String ?? ""
            disp_text = dic["disp_text"] as? String ?? ""
            arrProviderList = (json["provider_list"].arrayObject ?? [Any]()).map({ProviderList(dic: $0 as! [String:Any])})
            categoryList = (json["category"].arrayObject ?? [Any]()).map({CategoryList(dic: $0 as! [String:Any])})
            subCategoryList = (json["subcategory"].arrayObject ?? [Any]()).map({SubCategoryList(dic: $0 as! [String:Any])})
            materialName = (json["material"].arrayObject ?? [Any]()).map({MaterialName(dic: $0 as! [String:Any])})
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
    class ProviderList: NSObject {
        
        @objc var provider_id: String = ""
        @objc var provider_image: String = ""
        @objc var service_id: String = ""
        @objc var quotes_id: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            provider_id = dic["provider_id"] as? String ?? ""
            provider_image = dic["provider_image"] as? String ?? ""
            service_id = dic["service_id"] as? String ?? ""
            quotes_id = dic["quotes_id"] as? String ?? ""
        }
    }
    
    class CategoryList: NSObject {
        
        @objc var category_name: String = ""
        
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            category_name = dic["category_name"] as? String ?? ""
            
        }
    }
    
    class SubCategoryList: NSObject {
        
        @objc var subcategory_name: String = ""
        
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            subcategory_name = dic["subcategory_name"] as? String ?? ""
            
        }
    }
    
    class MaterialName: NSObject {
        
        @objc var material_name: String = ""
        @objc var material_unit_name: String = ""
        @objc var quantity: String = ""
        
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            material_name = dic["material_name"] as? String ?? ""
            material_unit_name = dic["material_unit_name"] as? String ?? ""
            quantity = dic["quantity"] as? String ?? ""
            
        }
    }
}
class UpdateQuestionList: NSObject {

    @objc var arrQuestions = [Questions]()
    @objc var serviceDetaila = ServiceDetail()
    @objc var arrProvider = [Providers]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        arrQuestions = (json["questions"].arrayObject ?? [Any]()).map({Questions(dic: $0 as! [String:Any])})
        serviceDetaila = ServiceDetail(dic:json["serviceDetail"].dictionaryObject!)
        arrProvider = (json["providers"].arrayObject ?? [Any]()).map({Providers(dic: $0 as! [String:Any])})
    }
    
    class Questions: NSObject {
        
        @objc var id: String = ""
        @objc var question: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            id = dic["id"] as? String ?? ""
            question = dic["question"] as? String ?? ""
        }
    }
    class Providers: NSObject {
        
        @objc var image: String = ""
        @objc var quoteId: String = ""
        @objc var userName: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            image = dic["image"] as? String ?? ""
            quoteId = dic["quoteId"] as? String ?? ""
            userName = dic["userName"] as? String ?? ""
        }
    }
    class ServiceDetail: NSObject {
        
        @objc var subCatId: String = ""
        @objc var subCatName: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            subCatId = dic["subCatId"] as? String ?? ""
            subCatName = dic["subCatName"] as? String ?? ""
        }
    }
}
class BrowseCategory: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrCategory = [CategoryData]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrCategory = (json["category"].arrayObject ?? [Any]()).map({CategoryData(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class CategoryData: NSObject {
        
        @objc var category_name: String = ""
        @objc var category_id: String = ""
        @objc var total_no_of_sub_category: Int = 0
        @objc var isChecked: Bool = false
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
            category_name = dic["category_name"] as? String ?? ""
            category_id = dic["category_id"] as? String ?? ""
            total_no_of_sub_category = dic["total_no_of_sub_category"] as? Int ?? 0
            isChecked = dic["isChecked"] as? Bool ?? false
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class SubCategory: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrSubCategory = [SubCategoryData]()
   
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrSubCategory = (json["data"].arrayObject ?? [Any]()).map({SubCategoryData(dic: $0 as! [String:Any])})
       // pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
       
    }
    
    class SubCategoryData: NSObject {
        
        @objc var category_name: String = ""
        @objc var category_id: String = ""
        @objc var total_no_of_sub_category: Int = 0
        @objc var subCategory = SubCategory()
        @objc var isChecked: Bool = false
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
            category_name = dic["category_name"] as? String ?? ""
            category_id = dic["category_id"] as? String ?? ""
            total_no_of_sub_category = dic["total_no_of_sub_category"] as? Int ?? 0
            subCategory = SubCategory(dic:json["sub_category"].dictionaryObject!)
            isChecked = dic["isChecked"] as? Bool ?? false
        }
        
        class SubCategory: NSObject {
            
            @objc var sub_category_name: String = ""
            @objc var sub_category_id: String = ""
            @objc var sub_category_image: String = ""
            @objc var isParent: String = ""
            @objc var isChecked: Bool = false
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                sub_category_name = dic["sub_category_name"] as? String ?? ""
                sub_category_id = dic["sub_category_id"] as? String ?? ""
                sub_category_image = dic["sub_category_image"] as? String ?? ""
                isParent = dic["isParent"] as? String ?? ""
                isChecked = dic["isChecked"] as? Bool ?? false
            }
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class QuestionList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var total_no_provider: Int = 0
    @objc var form_id: String = ""
    @objc var arrFormData = [FormsData]()
    var subCategoryName:String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        total_no_provider = dic["total_no_provider"] as? Int ?? 0
        form_id = dic["form_id"] as? String ?? ""
        arrFormData = (json["forms_data"].arrayObject ?? [Any]()).map({FormsData(dic: $0 as! [String:Any])})
         subCategoryName = dic["subCategoryName"] as? String ?? ""
    }
}
class FormsData: NSObject {
    
    @objc var form_element_id: String = ""
    @objc var form_element_type: String = ""
    @objc var form_element_type_id: String = ""
    @objc var label: String = ""
    @objc var has_child: String = ""
    @objc var isCustom: String = ""
    @objc var arrElementList = [ElementList]()
    var isChecked:Bool = false
    
    override init() {
        super.init()
    }
    
   
    init(dic:[String:Any]) {
        let json = JSON(dic)
        form_element_id = dic["form_element_id"] as? String ?? ""
        form_element_type = dic["form_element_type"] as? String ?? ""
        form_element_type_id = dic["form_element_type_id"] as? String ?? ""
        label = dic["label"] as? String ?? ""
        has_child = dic["has_child"] as? String ?? ""
        isCustom = dic["isCustom"] as? String ?? "n"
        arrElementList = (json["element_list"].arrayObject ?? [Any]()).map({ElementList(dic: $0 as! [String:Any])})
        isChecked = dic["isChecked"] as? Bool ?? false
    }
    
    class ElementList: NSObject {
        
        @objc var element_label: String = ""
        @objc var element_value: String = ""
        @objc var element_img: String = ""
        @objc var isChecked: Bool = false
        
        
        init(dic:[String:Any]) {
            element_label = dic["element_label"] as? String ?? ""
            element_value = dic["element_value"] as? String ?? ""
            element_img = dic["element_img"] as? String ?? ""
            isChecked = dic["isChecked"] as? Bool ?? false
        }
    }
}
class AskQuestionList: NSObject {
    
    @objc var arrFormData = [FormsData]()
    @objc var totalNoQuestion: Int = 0
    @objc var currentQuestion: Int = 0
    @objc var formId: String = ""
    @objc var serviceId: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any],_ totalNoQuestion: Int,_ currentQuestion: Int,_ formId: String) {
        let json = JSON(dic)
        arrFormData = (json["forms_data"].arrayObject ?? [Any]()).map({FormsData(dic: $0 as! [String:Any])})
        self.totalNoQuestion = totalNoQuestion
        self.currentQuestion = currentQuestion
        self.formId = formId
    }
}
class AnsQuestionList: NSObject {
    
    @objc var arrKeyData = [String]()
    @objc var arrKeyAnsData = [String]()
    @objc var service_title: String = ""
    @objc var budget: String = ""
    @objc var service_date: String = ""
    @objc var req_desc: String = ""
    @objc var arrAns = [AnsListarr]()
    
    override init() {
        super.init()
    }
    
    func removeAtIndex(index: Int) {
        print(arrAns)
        print(index)
        arrAns.remove(at: index)
        arrKeyData.remove(at: index)
        arrKeyAnsData.remove(at: index)
    }
    
}
class AnsListarr: NSObject {
    @objc var form_element_type: String = ""
    @objc var form_element_id: String = ""
    @objc var element_value: String = ""
    @objc var strKeyData: String = ""
    @objc var strKeyAnsData: String = ""
    @objc var isTemplateValue: String = ""
    
    override init() {
        super.init()
    }
    
    init(form_element_type: String,form_element_id: String,element_value: String,strKeyData: String,strKeyAnsData: String,isTemplateValue: String) {
        self.form_element_type = form_element_type
        self.form_element_id = form_element_id
        self.element_value = element_value
        self.strKeyData = strKeyData
        self.strKeyAnsData = strKeyAnsData
        self.isTemplateValue = isTemplateValue
    }
}
class RequestDetails: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var numQuote: String = ""
    @objc var serviceDetails = ServiceDetails()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        numQuote = dic["numQuote"] as? String ?? ""
        serviceDetails = ServiceDetails(dic:json["serviceDetail"].dictionaryObject!)
    }
    
    class ServiceDetails: NSObject {
        
        @objc var service_title: String = ""
        @objc var serviceid: String = ""
        @objc var requestid: Int = 0
        @objc var service_category: String = ""
        @objc var service_subcategory: String = ""
        @objc var service_address: String = ""
        @objc var service_date: String = ""
        @objc var service_time: String = ""
        @objc var service_hour: String = ""
        @objc var service_detail: String = ""
        @objc var service_budget: String = ""
        @objc var userid: String = ""
        @objc var name: String = ""
        @objc var email: String = ""
        @objc var serviceImage: String = ""
        @objc var userimage: String = ""
        @objc var user_quote_id: String = ""
        @objc var flag_status: String = ""
        @objc var showMessageOption: String = ""
        @objc var service_status: String = ""
        @objc var pdf_file: String = ""
        @objc var arrExtraFields = [ExtraFields]()
        @objc var arrProviderList = [ProviderList]()
        @objc var material = [MaterialListName]()
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
            material = (json["material"].arrayObject ?? [Any]()).map({MaterialListName(dic: $0 as! [String:Any])})
            pdf_file = dic["pdf_file"] as? String ?? ""
            service_title = dic["service_title"] as? String ?? ""
            serviceid = dic["serviceid"] as? String ?? ""
            requestid = dic["requestid"] as? Int ?? 0
            service_category = dic["service_category"] as? String ?? ""
            service_subcategory = dic["service_subcategory"] as? String ?? ""
            service_address = dic["service_address"] as? String ?? ""
            service_date = dic["service_date"] as? String ?? ""
            service_time = dic["service_time"] as? String ?? ""
            service_hour = dic["service_hour"] as? String ?? ""
            service_detail = dic["service_detail"] as? String ?? ""
            service_budget = dic["service_budget"] as? String ?? ""
            userid = dic["userid"] as? String ?? ""
            name = dic["name"] as? String ?? ""
            email = dic["email"] as? String ?? ""
            serviceImage = dic["serviceImage"] as? String ?? ""
            userimage = dic["userimage"] as? String ?? ""
            user_quote_id = dic["user_quote_id"] as? String ?? ""
            flag_status = dic["flag_status"] as? String ?? ""
            showMessageOption = dic["showMessageOption"] as? String ?? ""
            service_status = dic["service_status"] as? String ?? ""
            arrExtraFields = (json["extra_fields"].arrayObject ?? [Any]()).map({ExtraFields(dic: $0 as! [String:Any])})
            arrProviderList = (json["provider_list"].arrayObject ?? [Any]()).map({ProviderList(dic: $0 as! [String:Any])})
        }
        
        class MaterialListName: NSObject {
            @objc var material_id: String = ""
            @objc var material_name: String = ""
            @objc var material_unit_name: String = ""
            @objc var price: String = ""
             @objc var quantity: String = ""
            
            init(dic:[String:Any]) {
                 material_id = dic["material_id"] as? String ?? ""
                material_name = dic["material_name"] as? String ?? ""
                material_unit_name = dic["material_unit_name"] as? String ?? ""
                quantity = dic["quantity"] as? String ?? ""
                 price = dic["price"] as? String ?? ""
            }
            
        }
        class ExtraFields: NSObject {
            
            @objc var values: String = ""
            @objc var label: String = ""
            @objc var fieldName: String = ""
            @objc var element_type_id: String = ""
            @objc var arrValueList = [ValueList]()
            @objc var arrValueCheckBox = [ValueListCheckBox]()
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                let json = JSON(dic)
                values = dic["values"] as? String ?? ""
                label = dic["label"] as? String ?? ""
                fieldName = dic["fieldName"] as? String ?? ""
                element_type_id = dic["element_type_id"] as? String ?? ""
                if element_type_id == "6" {
                    arrValueList = (json["values_list"].arrayObject ?? [Any]()).map({ValueList(dic: $0 as! [String:Any])})
                }
                else if element_type_id == "5" {
                    arrValueCheckBox = (json["values_list"].arrayObject ?? [Any]()).map({ValueListCheckBox(dic: $0 as! [String:Any])})
                }
                
            }
        }
        class ValueList: NSObject {
            
            @objc var element_value: String = ""
            @objc var element_image: String = ""
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                element_value = dic["element_value"] as? String ?? ""
                element_image = dic["element_image"] as? String ?? ""
            }
        }
        class ValueListCheckBox: NSObject {
            
            @objc var element_value: String = ""
            @objc var isCheck: String = ""
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                element_value = dic["element_value"] as? String ?? ""
                isCheck = dic["isCheck"] as? String ?? ""
            }
        }
        class ProviderList: NSObject {
            
            @objc var image: String = ""
            @objc var name: String = ""
            @objc var provider_id: String = ""
            @objc var quotes_id: String = ""
            @objc var review: String = ""
            @objc var totalReview: String = ""
            @objc var delivery_days: String = ""
             @objc var material = [MaterialListName]()
            
            override init() {
                super.init()
            }
            
            init(dic:[String:Any]) {
                 let json = JSON(dic)
                material = (json["material"].arrayObject ?? [Any]()).map({MaterialListName(dic: $0 as! [String:Any])})
                image = dic["image"] as? String ?? ""
                name = dic["name"] as? String ?? ""
                provider_id = dic["provider_id"] as? String ?? ""
                quotes_id = dic["quotes_id"] as? String ?? ""
                review = dic["review"] as? String ?? ""
                totalReview = dic["totalReview"] as? String ?? ""
                delivery_days = dic["delivery_days"] as? String ?? ""
            }
            
            class MaterialListName: NSObject {
                @objc var material_name: String = ""
                @objc var price: String = ""
              
                
                init(dic:[String:Any]) {
                    material_name = dic["material_name"] as? String ?? ""
                    price = dic["price"] as? String ?? ""
                   
                }
                
            }
        }
    }
}
class NotificationList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrNotificationList = [NotificationList]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrNotificationList = (json["notification_list"].arrayObject ?? [Any]()).map({NotificationList(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class NotificationList: NSObject {
        
        @objc var id: String = ""
        @objc var notification: String = ""
        @objc var createdDate: String = ""
        @objc var type: String = ""
        @objc var providerId: String = ""
        @objc var customerId: String = ""
        @objc var serviceId: String = ""
        @objc var quoteId: String = ""
        @objc var senderId: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            id = dic["id"] as? String ?? ""
            notification = dic["notification"] as? String ?? ""
            createdDate = dic["createdDate"] as? String ?? ""
            type = dic["type"] as? String ?? ""
            providerId = dic["providerId"] as? String ?? ""
            customerId = dic["customerId"] as? String ?? ""
            serviceId = dic["serviceId"] as? String ?? ""
            quoteId = dic["quoteId"] as? String ?? ""
             senderId = dic["senderId"] as? String ?? ""
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class EmailNotification: NSObject {
    
    @objc var id: String = ""
    @objc var userId: String = ""
    @objc var FirstFiveQuotes: String = ""
    @objc var NewQuoteAdded: String = ""
    @objc var ServiceReqExpire: String = ""
    @objc var NewServiceRequest: String = ""
    @objc var QuoteViewed: String = ""
    @objc var QuoteRejected: String = ""
    @objc var ServiceRequestExpired: String = ""
    @objc var HiredForService: String = ""
    @objc var ReviewAndRatingReceived: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        id = dic["id"] as? String ?? ""
        userId = dic["userId"] as? String ?? ""
        FirstFiveQuotes = dic["FirstFiveQuotes"] as? String ?? ""
        NewQuoteAdded = dic["NewQuoteAdded"] as? String ?? ""
        ServiceReqExpire = dic["ServiceReqExpire"] as? String ?? ""
        NewServiceRequest = dic["NewServiceRequest"] as? String ?? ""
        QuoteViewed = dic["QuoteViewed"] as? String ?? ""
        QuoteRejected = dic["QuoteRejected"] as? String ?? ""
        HiredForService = dic["HiredForService"] as? String ?? ""
        ReviewAndRatingReceived = dic["ReviewAndRatingReceived"] as? String ?? ""
        ServiceRequestExpired = dic["ServiceRequestExpired"] as? String ?? ""
    }
}
class LanguageList: NSObject {
    
    @objc var lId: String = ""
    @objc var languageName: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        lId = dic["lId"] as? String ?? ""
        languageName = dic["languageName"] as? String ?? ""
    }
}
class CmsPages: NSObject {
    
    @objc var page_id: String = ""
    @objc var pageTitle: String = ""
    @objc var page_or_url: String = ""
    @objc var page_url: String = ""
    @objc var pageDesc: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        page_id = dic["page_id"] as? String ?? ""
        pageTitle = dic["pageTitle"] as? String ?? ""
        page_or_url = dic["page_or_url"] as? String ?? ""
        page_url = dic["page_url"] as? String ?? ""
        pageDesc = dic["pageDesc"] as? String ?? ""
    }
}
class BusinessProfile: NSObject {
    
    @objc var business_location: String = ""
    @objc var business_name: String = ""
    @objc var business_desc: String = ""
    @objc var business_w_travel: String = ""
    @objc var w_travel: String = ""
    @objc var business_paypal_email: String = ""
    @objc var bus_addressLat: String = ""
    @objc var bus_addressLng: String = ""
    @objc var est_date: String = ""
    @objc var bus_cat_id: String = ""
    @objc var category: String = ""
    @objc var sub_category: String = ""
    @objc var pincode: String = ""
    @objc var arrSubCategoryList = [SubCategoryList]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        business_location = dic["business_location"] as? String ?? ""
        business_name = dic["business_name"] as? String ?? ""
        business_desc = dic["business_desc"] as? String ?? ""
        business_w_travel = dic["business_w_travel"] as? String ?? ""
        w_travel = dic["w_travel"] as? String ?? ""
        business_paypal_email = dic["business_paypal_email"] as? String ?? ""
        bus_addressLat = dic["bus_addressLat"] as? String ?? ""
        bus_addressLng = dic["bus_addressLng"] as? String ?? ""
        est_date = dic["est_date"] as? String ?? ""
        bus_cat_id = dic["bus_cat_id"] as? String ?? ""
        category = dic["category"] as? String ?? ""
        sub_category = dic["sub_category"] as? String ?? ""
        category = dic["category"] as? String ?? ""
        pincode = dic["pincode"] as? String ?? ""
        arrSubCategoryList = (json["sub_category_list"].arrayObject ?? [Any]()).map({SubCategoryList(dic: $0 as! [String:Any])})
    }
    
    class SubCategoryList: NSObject {
        
        @objc var id: String = ""
        @objc var sub_category_name: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            id = dic["id"] as? String ?? ""
            sub_category_name = dic["sub_category_name"] as? String ?? ""
        }
    }
}
class ReviewsList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrReviews = [Reviews]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrReviews = (json["reviews"].arrayObject ?? [Any]()).map({Reviews(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class Reviews: NSObject {
        
        @objc var reviewId: String = ""
        @objc var user_name: String = ""
        @objc var user_rating: Int = 0
        @objc var review_desc: String = ""
        @objc var reviewer_id: String = ""
        @objc var review_date_time: String = ""
        @objc var isFlag: String = ""
        @objc var user_image: String = ""
        @objc var communication_rating: String = ""
        @objc var delivery_on_time_rating: String = ""
        @objc var material_service_quantity_rating: String = ""
        @objc var service_title: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            reviewId = dic["reviewId"] as? String ?? ""
            user_name = dic["user_name"] as? String ?? ""
            user_rating = dic["user_rating"] as? Int ?? 0
            review_desc = dic["review_desc"] as? String ?? ""
            reviewer_id = dic["reviewer_id"] as? String ?? ""
            review_date_time = dic["review_date_time"] as? String ?? ""
            isFlag = dic["isFlag"] as? String ?? ""
            user_image = dic["user_image"] as? String ?? ""
            communication_rating = dic["communication_rating"] as? String ?? ""
            delivery_on_time_rating = dic["delivery_on_time_rating"] as? String ?? ""
            material_service_quantity_rating = dic["material_service_quantity_rating"] as? String ?? ""
            service_title = dic["service_title"] as? String ?? ""
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class CategoryListProfile: NSObject {
    
    @objc var category_name: String = ""
    @objc var id: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        category_name = dic["category_name"] as? String ?? ""
        id = dic["id"] as? String ?? ""
    }
}
class ServiceNotifications: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrServiceNotification = [ServiceNotificationList]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrServiceNotification = (json["service"].arrayObject ?? [Any]()).map({ServiceNotificationList(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class ServiceNotificationList: NSObject {
        
        @objc var notification_id: String = ""
        @objc var customer_id: String = ""
        @objc var service_id: String = ""
        @objc var service_name: String = ""
        @objc var customer_name: String = ""
        @objc var customer_image: String = ""
        @objc var service_location: String = ""
        @objc var service_category: String = ""
        @objc var service_sub_category: String = ""
        @objc var service_posted_time: String = ""
        @objc var isHired: String = ""
        @objc var service_budget: String = ""
        @objc var service_status: String = ""
        @objc var quote_status: String = ""
        @objc var material = [MaterialListName]()
         @objc var pdf_file: String = ""
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
             let json = JSON(dic)
            material = (json["material"].arrayObject ?? [Any]()).map({MaterialListName(dic: $0 as! [String:Any])})
            pdf_file = dic["pdf_file"] as? String ?? ""
            notification_id = dic["notification_id"] as? String ?? ""
            customer_id = dic["customer_id"] as? String ?? ""
            service_id = dic["service_id"] as? String ?? ""
            service_name = dic["service_name"] as? String ?? ""
            customer_name = dic["customer_name"] as? String ?? ""
            customer_image = dic["customer_image"] as? String ?? ""
            service_location = dic["service_location"] as? String ?? ""
            service_category = dic["service_category"] as? String ?? ""
            service_sub_category = dic["service_sub_category"] as? String ?? ""
            service_posted_time = dic["service_posted_time"] as? String ?? ""
            isHired = dic["isHired"] as? String ?? ""
            service_budget = dic["service_budget"] as? String ?? ""
            service_status = dic["service_status"] as? String ?? ""
            quote_status = dic["quote_status"] as? String ?? ""
        }
        
        class MaterialListName: NSObject {
            @objc var material_name: String = ""
            @objc var material_unit_name: String = ""
            @objc var quantity: String = ""
            
             init(dic:[String:Any]) {
                material_name = dic["material_name"] as? String ?? ""
                material_unit_name = dic["material_unit_name"] as? String ?? ""
                quantity = dic["quantity"] as? String ?? ""
            }
            
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class QuotePlacedList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var pagination = PaginDetailsData()
    @objc var arrQuotePlaced = [QuitaPlaced]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        arrQuotePlaced = (json["service"].arrayObject ?? [Any]()).map({QuitaPlaced(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
    }
    
    class QuitaPlaced: NSObject {
        
        @objc var customer_id: String = ""
        @objc var quotes_id: String = ""
        @objc var service_id: String = ""
        @objc var service_name: String = ""
        @objc var customer_name: String = ""
        @objc var customer_image: String = ""
        @objc var service_location: String = ""
        @objc var service_category: String = ""
        @objc var service_sub_category: String = ""
        @objc var service_posted_time: String = ""
        @objc var isHired: String = ""
        @objc var service_budget: String = ""
        @objc var service_status: String = ""
        @objc var delivery_days: String = ""
        @objc var material = [MaterialListName]()
        @objc var amount: String = ""
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            let json = JSON(dic)
             material = (json["material"].arrayObject ?? [Any]()).map({MaterialListName(dic: $0 as! [String:Any])})
            amount = dic["amount"] as? String ?? ""
            delivery_days = dic["delivery_days"] as? String ?? ""
            customer_id = dic["customer_id"] as? String ?? ""
            quotes_id = dic["quotes_id"] as? String ?? ""
            service_id = dic["service_id"] as? String ?? ""
            service_name = dic["service_name"] as? String ?? ""
            customer_name = dic["customer_name"] as? String ?? ""
            customer_image = dic["customer_image"] as? String ?? ""
            service_location = dic["service_location"] as? String ?? ""
            service_category = dic["service_category"] as? String ?? ""
            service_sub_category = dic["service_sub_category"] as? String ?? ""
            service_posted_time = dic["service_posted_time"] as? String ?? ""
            isHired = dic["isHired"] as? String ?? ""
            service_budget = dic["service_budget"] as? String ?? ""
            service_status = dic["service_status"] as? String ?? ""
        }
        class MaterialListName: NSObject {
            @objc var material_name: String = ""
            @objc var price: String = ""
           
            init(dic:[String:Any]) {
                material_name = dic["material_name"] as? String ?? ""
                price = dic["price"] as? String ?? ""
            }
            
        }
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class MemeberShipPlanRecord: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var paypal_email: String = ""
    @objc var purchased_membership_plan = PurchaseMemberShipPlan()
   
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        paypal_email = dic["paypal_email"] as? String ?? ""
       
        purchased_membership_plan = PurchaseMemberShipPlan(dic:json["purchased_membership_plan"].dictionaryObject!)
    }
    class PurchaseMemberShipPlan: NSObject {
        
        @objc var display_text: String = ""
        @objc var available_balance: String = ""
        @objc var total_credit_used: String = ""
        @objc var request_for_redeem: String = ""
        @objc var messaging: String = ""
        @objc var duration: String = ""
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            display_text = dic["display_text"] as? String ?? ""
            available_balance = dic["available_balance"] as? String ?? ""
            total_credit_used = dic["total_credit_used"] as? String ?? ""
            request_for_redeem = dic["request_for_redeem"] as? String ?? ""
            duration = dic["duration"] as? String ?? ""
            messaging = dic["messaging"] as? String ?? ""
        }
    }
}
class UpgradePlanList: NSObject {
    
    @objc var id: String = ""
    @objc var plan_name: String = ""
    @objc var total_credits: String = ""
    @objc var price: String = ""
    @objc var is_free: String = ""
    @objc var isCurrent: String = ""
    @objc var button_text: String = ""
    @objc var messaging: String = ""
    @objc var duration: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        id = dic["id"] as? String ?? ""
        plan_name = dic["plan_name"] as? String ?? ""
        total_credits = dic["total_credits"] as? String ?? ""
        price = dic["price"] as? String ?? ""
        is_free = dic["is_free"] as? String ?? ""
        isCurrent = dic["isCurrent"] as? String ?? ""
        button_text = dic["button_text"] as? String ?? ""
        duration = dic["duration"] as? String ?? ""
        messaging = dic["messaging"] as? String ?? ""
    }
}
class GetPaypalURL: NSObject {
    
    @objc var failed: String = ""
    @objc var paypal_url: String = ""
    @objc var success: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        failed = dic["failed"] as? String ?? ""
        paypal_url = dic["paypal_url"] as? String ?? ""
        success = dic["success"] as? String ?? ""
    }
}
class GetPrePaypalURL: NSObject {
    
    @objc var fail: String = ""
    @objc var paypal_url: String = ""
    @objc var success: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        fail = dic["fail"] as? String ?? ""
        paypal_url = dic["paypal_url"] as? String ?? ""
        success = dic["success"] as? String ?? ""
    }
}
class CreditDetails: NSObject {
    
    @objc var required_credit: String = ""
    @objc var user_credit: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        required_credit = dic["required_credit"] as? String ?? ""
        user_credit = dic["user_credit"] as? String ?? ""
    }
}
class AllMessageList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var max_upload_size: Int = 0
    @objc var pagination = PaginDetailsData()
    @objc var arrMessages = [Messages]()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        max_upload_size = dic["max_upload_size"] as? Int ?? 0
        arrMessages = (json["result"].arrayObject ?? [Any]()).map({Messages(dic: $0 as! [String:Any])})
        pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject ?? [String: Any]())
    }
    class PaginDetailsData: NSObject {
        
        @objc var current_page: Int = 0
        @objc var total_pages: Int = 0
        @objc var total: Int = 0
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            current_page = dic["current_page"] as? Int ?? 0
            total_pages = dic["total_pages"] as? Int ?? 0
            total = dic["total"] as? Int ?? 0
        }
    }
}
class Messages: NSObject {
    
    @objc var message_id: String = ""
    @objc var sender_id: String = ""
    @objc var receiver_id: String = ""
    @objc var msg: String = ""
    @objc var url: String = ""
    @objc var mtype: String = ""
    @objc var time: String = ""
    @objc var isSender: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        message_id = dic["message_id"] as? String ?? ""
        sender_id = dic["sender_id"] as? String ?? ""
        receiver_id = dic["receiver_id"] as? String ?? ""
        msg = dic["msg"] as? String ?? ""
        url = dic["url"] as? String ?? ""
        mtype = dic["mtype"] as? String ?? ""
        time = dic["time"] as? String ?? ""
        isSender = dic["isSender"] as? String ?? ""
    }
}
class ProviderDetailsChat: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var is_review: String = ""
    @objc var providerDetails = ProviderDetails()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        is_review = dic["is_review"] as? String ?? ""
        providerDetails = ProviderDetails(dic:json["provider_details"].dictionaryObject ?? [String: Any]())
    }
    class ProviderDetails: NSObject {
        
        @objc var provider_name: String = ""
        @objc var provider_ratings: String = ""
        @objc var provider_review: String = ""
        @objc var provider_location: String = ""
        @objc var service_title: String = ""
        @objc var service_detail: String = ""
        @objc var provider_language: String = ""
        @objc var service_budget: String = ""
        @objc var isHired: String = ""
        @objc var service_status: String = ""
        @objc var avg_star_rating: String = ""
        @objc var request_id: Int = 0
        
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            provider_name = dic["provider_name"] as? String ?? ""
            provider_ratings = dic["provider_ratings"] as? String ?? ""
            provider_review = dic["provider_review"] as? String ?? ""
            provider_location = dic["provider_location"] as? String ?? ""
            service_title = dic["service_title"] as? String ?? ""
            service_detail = dic["service_detail"] as? String ?? ""
            provider_language = dic["provider_language"] as? String ?? ""
            service_budget = dic["service_budget"] as? String ?? ""
            isHired = dic["isHired"] as? String ?? ""
            service_status = dic["service_status"] as? String ?? ""
            avg_star_rating = dic["avg_star_rating"] as? String ?? ""
            request_id = dic["request_id"] as? Int ?? 0
        }
    }
}
class CustomerDetails: NSObject {
    
    @objc var customer_name: String = ""
    @objc var customer_location: String = ""
    @objc var service_title: String = ""
    @objc var service_detail: String = ""
    @objc var budget: String = ""
     @objc var material = [MaterialListName]()
    @objc var delivery_days: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        material = (json["material"].arrayObject ?? [Any]()).map({MaterialListName(dic: $0 as! [String:Any])})
        customer_name = dic["customer_name"] as? String ?? ""
        customer_location = dic["customer_location"] as? String ?? ""
        service_title = dic["service_title"] as? String ?? ""
        service_detail = dic["service_detail"] as? String ?? ""
        budget = dic["budget"] as? String ?? ""
        delivery_days = dic["delivery_days"] as? String ?? ""
    }
    
    class MaterialListName: NSObject {
        @objc var material_name: String = ""
        @objc var material_unit_name: String = ""
        @objc var quantity: String = ""
        
        init(dic:[String:Any]) {
            material_name = dic["material_name"] as? String ?? ""
            material_unit_name = dic["material_unit_name"] as? String ?? ""
            quantity = dic["quantity"] as? String ?? ""
        }
        
    }
}
class SendMsgReturnData: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var messageId: String = ""
    @objc var messageTime: String = ""
    @objc var retuMessages = Messages()
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        messageId = dic["messageId"] as? String ?? ""
        messageTime = dic["messageTime"] as? String ?? ""
        retuMessages = Messages(dic:json["return_data"].dictionaryObject ?? [String: Any]())
    }
}
class GetAllReview: NSObject {
    
    @objc var image: String = ""
    @objc var name: String = ""
    @objc var provider_id: String = ""
    @objc var service_id: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        _ = JSON(dic)
        image = dic["image"] as? String ?? ""
        name = dic["name"] as? String ?? ""
        provider_id = dic["provider_id"] as? String ?? ""
        service_id = dic["service_id"] as? String ?? ""
    }
}
class UserProfileOffline: NSObject {
    
    @objc var notification_count: Int = 0
    @objc var message_count: Int = 0
    @objc var site_notification_count: Int = 0
    @objc var disp_text: String = ""
    
    @objc var user_id: String = ""
    @objc var languages: String = ""
    @objc var user_email: String = ""
    @objc var user_contact: String = ""
    @objc var user_type: String = ""
    @objc var user_name: String = ""
    @objc var user_location: String = ""
    @objc var user_image: String = ""
    @objc var user_desc: String = ""
    @objc var latitude: String = ""
    @objc var longitude: String = ""
    @objc var pincode: String = ""
    @objc var user_rating: String = ""
    @objc var uesr_no_review: String = ""
    @objc var user_total_quote: String = ""
    @objc var user_total_quote_completed: String = ""
    @objc var arrPortFolio = [PortFolio]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        notification_count = dic["notification_count"] as? Int ?? 0
        message_count = dic["message_count"] as? Int ?? 0
        site_notification_count = dic["site_notification_count"] as? Int ?? 0
        disp_text = dic["disp_text"] as? String ?? ""
        user_id = dic["user_id"] as? String ?? ""
        languages = dic["languages"] as? String ?? ""
        user_email = dic["user_email"] as? String ?? ""
        user_contact = dic["user_contact"] as? String ?? ""
        user_type = dic["user_type"] as? String ?? ""
        user_name = dic["user_name"] as? String ?? ""
        user_location = dic["user_location"] as? String ?? ""
        user_image = dic["user_image"] as? String ?? ""
        user_desc = dic["user_desc"] as? String ?? ""
        latitude = dic["latitude"] as? String ?? ""
        longitude = dic["longitude"] as? String ?? ""
        pincode = dic["pincode"] as? String ?? ""
        user_rating = dic["user_rating"] as? String ?? ""
        uesr_no_review = dic["uesr_no_review"] as? String ?? ""
        user_total_quote = dic["user_total_quote"] as? String ?? ""
        user_total_quote_completed = dic["user_total_quote_completed"] as? String ?? ""
        arrPortFolio = (json["portfolio"].arrayObject ?? [Any]()).map({PortFolio(dic: $0 as! [String:Any])})
    }
    class PortFolio: NSObject {
        
        @objc var portfolio_id: String = ""
        @objc var portfolio_image: String = ""
        
        override init() {
            super.init()
        }
        
        init(dic:[String:Any]) {
            portfolio_id = dic["portfolio_id"] as? String ?? ""
            portfolio_image = dic["portfolio_image"] as? String ?? ""
        }
    }
}
class FlagStatus: NSObject {
    
    @objc var flagStatus: String = ""
    @objc var message: String = ""
    @objc var status: Bool = false
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        flagStatus = dic["flagStatus"] as? String ?? ""
        message = dic["message"] as? String ?? ""
        status = dic["status"] as? Bool ?? false
    }
}
class AppData: NSObject {
    
    @objc var app_version: String = ""
    @objc var forced_update: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        app_version = dic["app_version"] as? String ?? ""
        forced_update = dic["forced_update"] as? String ?? ""
    }
}

class SearchProviderClass: NSObject {
    
    @objc var arrProvider = [ProviderSearchList]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        arrProvider = (json["data"].arrayObject ?? [Any]()).map({ProviderSearchList(dic: $0 as! [String:Any])})
        // pagination = PaginDetailsData(dic:json["pagination"].dictionaryObject!)
        
    }
class ProviderSearchList: NSObject {
    
    @objc var category_name: String = ""
    @objc var receive_msg: String = ""
    @objc var subcategory_name: String = ""
    @objc var supplier_id: String = ""
    @objc var supplier_img: String = ""
    @objc var supplier_name: String = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        category_name = dic["category_name"] as? String ?? ""
        receive_msg = dic["receive_msg"] as? String ?? ""
        subcategory_name = dic["subcategory_name"] as? String ?? ""
        supplier_id = dic["supplier_id"] as? String ?? ""
        supplier_img = dic["supplier_img"] as? String ?? ""
        supplier_name = dic["supplier_name"] as? String ?? ""
    }
}
}

class MaterialList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var materialData = [MaterialData]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        materialData = (json["data"].arrayObject ?? [Any]()).map({MaterialData(dic: $0 as! [String:Any])})
    }
    
    class MaterialData: NSObject{
        
        @objc var material_id: String = ""
        @objc var material_name: String = ""
       
        override init() {
            super.init()
        }
        
        
        init(dic:[String:Any]) {
            material_id = dic["material_id"] as? String ?? ""
            material_name = dic["material_name"] as? String ?? ""
            
        }
        
    }
}


class MaterialUnitList: NSObject {
    
    @objc var status: Bool = false
    @objc var message: String = ""
    @objc var materialUnitData = [MaterialUnitData]()
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        let json = JSON(dic)
        status = dic["status"] as? Bool ?? false
        message = dic["message"] as? String ?? ""
        materialUnitData = (json["data"].arrayObject ?? [Any]()).map({MaterialUnitData(dic: $0 as! [String:Any])})
    }
    
    class MaterialUnitData: NSObject{
        
        @objc var material_unit_id: String = ""
        @objc var material_unit_name: String = ""
        
        override init() {
            super.init()
        }
        
        
        init(dic:[String:Any]) {
            material_unit_id = dic["material_unit_id"] as? String ?? ""
            material_unit_name = dic["material_unit_name"] as? String ?? ""
            
        }
        
    }
}

class MessageCls{
    var notificationList: [MessageList] = [MessageList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .result) ).map({MessageList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class MessageList {
        
        
        var image: String?
        var isSender: String?
        var message_id: String?
        var name: String?
        var receiver_id: String?
        var sender_id: String?
        var time: String?
        
        required init(dictionary: [String:Any]) {
            image = dictionary["image"] as? String
            isSender = dictionary["isSender"] as? String
            message_id = dictionary["message_id"] as? String
            name = dictionary["name"] as? String
            receiver_id = dictionary["receiver_id"] as? String
            sender_id = dictionary["sender_id"] as? String
            time = dictionary["time"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.isSender, forKey: "isSender")
            dictionary.setValue(self.message_id, forKey: "message_id")
            dictionary.setValue(self.name, forKey: "name")
            dictionary.setValue(self.receiver_id, forKey: "receiver_id")
            dictionary.setValue(self.sender_id, forKey: "sender_id")
            dictionary.setValue(self.time, forKey: "time")
            return dictionary as! [String:Any]
        }
    }
    
    

    
    class Pagination {
        var total : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total = dictionary["total"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total, forKey: "total")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class ChatCls{
    var notificationList: [MessageList] = [MessageList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .result) ).map({MessageList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class MessageList {
        
        
        var image: String?
        var isSender: String?
        var message_id: String?
        var msg: String?
        var receiver_id: String?
        var sender_id: String?
        var time: String?
        var mtype: String?
        var url: String?
        
        required init(dictionary: [String:Any]) {
            image = dictionary["image"] as? String
            isSender = dictionary["isSender"] as? String
            message_id = dictionary["message_id"] as? String
            msg = dictionary["msg"] as? String
            receiver_id = dictionary["receiver_id"] as? String
            sender_id = dictionary["sender_id"] as? String
            mtype = dictionary["mtype"] as? String
            url = dictionary["url"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.isSender, forKey: "isSender")
            dictionary.setValue(self.message_id, forKey: "message_id")
            dictionary.setValue(self.msg, forKey: "msg")
            dictionary.setValue(self.receiver_id, forKey: "receiver_id")
            dictionary.setValue(self.sender_id, forKey: "sender_id")
            dictionary.setValue(self.time, forKey: "time")
            dictionary.setValue(self.url, forKey: "url")
            return dictionary as! [String:Any]
        }
    }
    
    
    
    
    class Pagination {
        var total : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total = dictionary["total"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total, forKey: "total")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
    
}
