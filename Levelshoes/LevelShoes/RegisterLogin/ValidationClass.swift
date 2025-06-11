
//
//  ValidationClass.swift
//  YastaaProvider
//
//  Created by Mayank Bajpai on 01/05/18.
//  Copyright © 2018 Manoj_Mobiloitte. All rights reserved.
//

import UIKit



class ValidationClass: NSObject {
    
    // MARK: ----- constant messages -----
    
    // --- email validation message ---
    static let vcErrorEmail                           =  "Please enter email id."
    static let vcErrorEmailArabic                           =  "Please enter email id in english."
    static let vcErrorValidEmail                      =  "Please enter valid email id."
    // --- username validation message ---
    static let vcErrorUsername                        =  "Please enter username."
    static let vcErrorValidUsername                   =  "Please enter valid username."
    // --- name validation message ---
    static let vcErrorname                            =  "Please enter name."
    static let vcErrorSalutation                          =  "Please select salutation."
    static let vcErrorValidname                       =  "Please enter valid name."
    // write Somethng
    static let vcErrorWriteSometing                            =  "Please Write something."
    
    
    // --- fullname validation message ---
    static let vcErrorFullname                        =  "Please enter full name."
    static let vcErrorValidFullname                   =  "Please enter valid full name."
    // --- name validation message ---
    static let vcErrorSurname                         =  "Please enter last name."
    static let vcErrorValidSurname                    =  "Please enter last name."
    // --- firstname validation message ---
    static let vcErrorFirstname                       =  "Please enter first name."
    static let vcErrorValidFirstname                  =  "Please enter valid first name."
    // --- lastname validation message ---
    static let vcErrorLastname                        =  "Please enter last name."
    static let vcErrorValidLastname                   =  "Please enter valid last name."
    // --- phone number validation message ---
    static let vcErrorPhoneNumber                     =  "Please enter mobile number."
    static let vcErrorValidPhoneNumber                =  "Please enter valid mobile number."
    static let contactMayNOtBeGreaterThan                   = "The Contact No May Not Be Greater Than 10 Characters"
    // --- password validation message ---
    static let vcErrorPassword                        =  "Please enter password."
    static let vcErrorValidPassword                   =  "Password must contains at least 8 characters."
    static let vcErrorValidSpecialPassword            =  "Password must contains at least 1 special characters."
    static let vcErrorValidUpperPassword              =  "Password must contains at least 1 Upper Case characters."
    static let vcErrorValidNumberPassword             =  "Password must contains at least 1 number."
    static let vcErrorAllinOne                        = "Minimum of different classes of characters in password is 3. Classes of characters: Lower Case, Upper Case, Digits, Special Characters."
    static let vcErrorConfirmPassword                 =  "Please enter confirm password."
    static let vcErrorValidConfirmPassword            =  "Confirm password must contains at least 6 characters."
    static let vcErrorMismatchPasswrdAndConPassword   =  "Confirm password and password must be same."//"Password and confirm password does not match."
    // --- email / username message ---
    static let vcErrorEmailOrUsername                 =  "Please enter email/username."
    // --- firstname validation message ---
    static let vcErrorGivenname                       =  "Please enter given name."
    static let vcErrorValidGivenname                  =  "Please enter valid given name."
    // --- lastname validation message ---
    static let vcErrorFamilyname                      =  "Please enter family name."
     static let vcErrorCity
        =  "Please select city."
    static let vcErrorValidFAmilyname                 =  "Please enter valid family name."
    //city
     static let vcErrorValidCityname                 =  "City Name Can't be Blank"
    // --- password validation message ---
    
    static let vcErrorNewPassword                        =  "Please enter new password."
    static let vcErrorNewValidPassword                   =  "New password must contains at least 6 characters."
    // --- Oldpassword validation message ---
    static let vcErrorPasswordOld                        =  "Please enter old password."
    static let vcErrorValidPasswordOld                   =  "Old Password must contains at least 6 characters."
    //about
    static let vcErrorAboutMe                           = "Please enter description."
    static let vcErrorEditAboutMe                           = "Please enter about description."
    static let vcErrorEnterDetail                            = "pls_enter_deatil"
    static let vcErrorEnterValidDetail                            = "pls_enter_valid_detail"
    static let vcErrorSelectSubcategoury                =  "Please select subcategory for"
    static let vcErrorValidAboutMe                         = "Please enter valid about me"
    static let vcErrorEnterLocation                       = "Please enter location"
    static let vcErrorEnterAddressLine1                     = "Please enter Address Line 1"
     static let vcErrorEnterCompanyName                    = "Please enter Company Name"
    static let vcErrorEnterShoppingNotes                     = "Please enter Shopping Notes"
     static let vcErrorEnterAddressLine2                     = "Please enter Address Line 2"
    static let vcErrorEnterValidLocation                       = "Please enter valid location"
    static let vcErrorYears                              = "Please enter how long you have been coaching?"
    static let vcErrorvalidYears                              = "Please enter valid years"
    static let experienceTime                                  = "The experience time may not be greater than 100"
    static let vcErrorInPersonRate                       = "Please enter in person rate"
    static let vcErrorInpersonRateLimit                       = "Inperson rate be grater than equal to 50"
    static let vcErrorOnlineRateLimit = "online rate be grater than equal to 20"
    static let vcErrorValidInPersonRate                       = "Please enter valid in person rate"
    static let vcErrorOnlinePersonRate                   = "Please enter online person rate"
    static let vcErrorvalidOnlinePersonRate                   = "Please enter valid online person rate"
    static let vcErrorCertificate                       = "Please enter cerificate"
    static let vcErrorValidCerficate                    =  "Please enter valid cartificate"
    static let vcErrorDate                              = "Please select DOB"
    static let vcErrorLessDate                       = "Date should be less than from today's date"
    static let vcErrorHealthAndFitnessDetail                            = "Why health and fitness important to me?"
    static let vcErrorHealthAndFitnessDetailEdit                            = "Please Enter Why health and fitness important to me?"
    static let vcErrorHowDidyouhear                            = "How did you hear about us?"
    static let vcCodeBlank                            = "Dear Customer Please enter code"
    
}

// MARK: ---- extension to define individual verfication methods
extension ValidationClass {
    
    // MARK: ----- email validation -----
    class func verifyEmail(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
//        if text.isPersian{
//            if text.count == 0{
//                verifyObj.message = vcErrorEmailArabic
//            }
//                //            else if !text.isArabicEmail{
//                //            verifyObj.message = vcErrorValidEmail
//                //            }
//            else if !text.isArabicValidEmail(){
//                verifyObj.message = vcErrorValidEmail
//
//            }
//            else{
//                verifyObj.isVerified = true
//            }
//        }else{
            if text.count == 0 {
                verifyObj.message = vcErrorEmail
            } else if !text.isEmail {
                verifyObj.message = vcErrorValidEmail
            } else {
                verifyObj.isVerified = true
            }
//
//    }
        return verifyObj
    }
    
    class func verifyEmail_UserName(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.count == 0 {
            verifyObj.message = "Please enter email/username."
        } else if text.count < 0 {
            verifyObj.message = "Username must contain at least 2 character."
        } else if text.contains("@") && !text.isEmail {
            verifyObj.message = vcErrorValidEmail
        } else if !text.contains("@") && !text.isValidUserName() {
            verifyObj.message = "Please enter valid username."
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- gender validation -----
    class func verifyGender(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.count == 0 {
            verifyObj.message = "Please select gender."
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- username validation -----
    class func verifyUsername(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorUsername
        } else if !text.isValidUserName() {
            verifyObj.message = vcErrorValidUsername
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- name validation -----
    class func verifyWriteSomething(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorWriteSometing
        }  else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    //verifyname
    class func verifyname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian{
            if text.length == 0{
                verifyObj.message = vcErrorname
            }else if text.length < 1 {
                verifyObj.message = vcErrorValidname
            }
            else{
                verifyObj.isVerified = true
            }
        }
        else{
            if text.length == 0 {
                verifyObj.message = vcErrorname
            } else if text.length < 1 {
                verifyObj.message = vcErrorValidname
            } else {
                verifyObj.isVerified = true
            }
        }
        
        return verifyObj
    }
    
    
    // MARK: ----- surname validation -----
    class func verifysurname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian{
            if text.length == 0{
                verifyObj.message = vcErrorname
            }else if text.length < 1 {
                verifyObj.message = vcErrorValidSurname
                
            }else{
                verifyObj.isVerified = true
            }
        }
        else{
            
            if text.length == 0 {
                verifyObj.message = vcErrorSurname
            } else if text.length < 1  {
                verifyObj.message = vcErrorValidSurname
            } else {
                verifyObj.isVerified = true
            }
        }
        return verifyObj
    }
    
    // MARK: ----- fullname validation -----
    class func verifyFullname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorname
        } else if text.length < 1  {
            verifyObj.message = vcErrorValidname
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- firstname validation -----
    class func verifyFirstname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian{
            if text.length == 0{
                verifyObj.message = vcErrorname
            }else if text.length < 1 {
                verifyObj.message = vcErrorValidFirstname
            }
            else{
                verifyObj.isVerified = true
            }
        }
        else{
            if text.length == 0 {
                verifyObj.message = vcErrorname
            } else if text.length < 1 {
                verifyObj.message = vcErrorValidname
            } else {
                verifyObj.isVerified = true
            }
        }
        
        return verifyObj

    }
    
    class func verifySalutation(text : String) -> (String, Bool) {
           var verifyObj = (message : "", isVerified : false)
           if text.isPersian{
               if text.length == 0{
                   verifyObj.message = vcErrorSalutation
               }
               else{
                   verifyObj.isVerified = true
               }
           }
           else{
               if text.length == 0 {
                   verifyObj.message = vcErrorSalutation
               }  else {
                   verifyObj.isVerified = true
               }
           }
           return verifyObj
       }
    
    //MARK: ----- about me validation
    class func verifyAboutMe(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorAboutMe //containsAlphabetsOnly()
        } else if text.length < 2 || !text.containsAlphaNumericOnly() {
            verifyObj.message = vcErrorValidAboutMe
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- about me Edit profile validation
    class func verifyEditAboutMe(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorEditAboutMe //containsAlphabetsOnly()
        } else if text.length < 2 || !text.containsAlphaNumericOnly() {
            verifyObj.message = vcErrorValidAboutMe
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- health & fitness  validation
    class func verifyHealthAndFitness(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorHealthAndFitnessDetail// containsAlphabetsOnly
        } else if text.length < 2 || !text.containsAlphaNumericOnly() {
            verifyObj.message = vcErrorEnterValidDetail
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- health & fitness  edit profile validation
    class func verifyHealthAndFitnessEdit(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorHealthAndFitnessDetailEdit// containsAlphabetsOnly
        } else if text.length < 2 || !text.containsAlphaNumericOnly() {
            verifyObj.message = vcErrorEnterValidDetail
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- health & fitness  validation
    class func verifyHowDidYouHear(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorHowDidyouhear
        } else if text.length < 2 || !text.containsAlphaNumericOnly() {
            verifyObj.message = vcErrorEnterValidDetail
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- about me validation
    class func verifyLocation(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorEnterLocation
        } else if text.length < 2  {
            verifyObj.message = vcErrorEnterValidLocation
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
  
    class func verifyAdd1(text : String) -> (String, Bool) {
          var verifyObj = (message : "", isVerified : false)
          if text.length == 0 {
              verifyObj.message = vcErrorEnterAddressLine1
          } else {
              verifyObj.isVerified = true
          }
          return verifyObj
      }
    
    class func verifyCompanyName(text : String) -> (String, Bool) {
            var verifyObj = (message : "", isVerified : false)
            if text.length == 0 {
                verifyObj.message = vcErrorEnterCompanyName
            } else {
                verifyObj.isVerified = true
            }
            return verifyObj
        }
    
    class func verifyShoppingNotes(text : String) -> (String, Bool) {
             var verifyObj = (message : "", isVerified : false)
             if text.length == 0 {
                 verifyObj.message = vcErrorEnterShoppingNotes
             } else {
                 verifyObj.isVerified = true
             }
             return verifyObj
         }
    
    class func verifyAdd2(text : String) -> (String, Bool) {
             var verifyObj = (message : "", isVerified : false)
             if text.length == 0 {
                 verifyObj.message = vcErrorEnterAddressLine2
             } else {
                 verifyObj.isVerified = true
             }
             return verifyObj
         }
    //MARK: ----- inPerson validation
    class func verifyInperson(text : String) -> (String, Bool) {
        
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorInPersonRate
        }  else if Int("\(text)")! < 50{
            verifyObj.message = vcErrorInpersonRateLimit
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    class func verifyInpersonEdit(text : String) -> (String, Bool) {
        
        let floatValue = Float(text)
        let rate = Int(floatValue!)
        
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorInPersonRate
        }  else if rate < 50 {
            verifyObj.message = vcErrorInpersonRateLimit
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- online validation
    
    class func verifyOnline(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorOnlinePersonRate
        } else if Int("\(text)")! < 20 {
            verifyObj.message = vcErrorOnlineRateLimit
        }
        else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    class func verifyOnlineEdit(text : String) -> (String, Bool) {
        let floatValue = Float(text)
        let rate = Int(floatValue!)
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorOnlinePersonRate
        } else if rate < 20 {
            verifyObj.message = vcErrorOnlineRateLimit
        }
        else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- online validation
    
    class func verifyListCertificate(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorCertificate
        }
            // else if text.length < 2 || !text.containsAlphaNumericOnly() {
            //            verifyObj.message = vcErrorValidCerficate
            //        }
        else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    
    //MARK: ----- years validation
    
    class func verifyYears(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorYears
        }
            //            else if text.length < 2 || !text.containsNumberOnly() {
            //            verifyObj.message = vcErrorvalidYears
            //        }
        else if Int(text)! > 100 {
            verifyObj.message = experienceTime
        }
            
        else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    //MARK: ----- listCartificate validation
    
    
    
    
    // MARK: ----- restro club name validation -----
    class func verifyRestro_ClubName(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = "Please enter Restaurant/Club name."
        } else if text.length < 2 || !text.isValidName() {
            verifyObj.message = "Please enter valid Restaurant/Club name."
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- password and confirm password -----
    class func verifyNewPasswordAndConfirmNewPassword(password : String, confirmPassword : String) -> (String, Bool, Int) {
        var verifyObj = (message : "", isVerified : false, index: 0)
        
        if password.length == 0 {
            verifyObj.message = "Please enter new password."
            verifyObj.index = 0
            
        } else if password.length < 8 {
            verifyObj.message = "New password must contains at least 6 characters."
            verifyObj.index = 0
            
        } else if confirmPassword.length == 0 {
            verifyObj.message = "Please enter confirm new Password."
            verifyObj.index = 1
            
        } else if confirmPassword != password {
            verifyObj.message = "New password and confirm password must be same."
            verifyObj.index = 1
            
        } else {
            verifyObj.isVerified = true
        }
        
        return verifyObj
    }
    
    // MARK: ----- password -----
    class func verifyNewPassword(password : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        
        if password.length == 0 {
            verifyObj.message = vcErrorNewPassword
            
        } else if password.length < 6 {
            verifyObj.message = vcErrorNewValidPassword
            
        } else {
            verifyObj.isVerified = true
        }
        
        return verifyObj
    }
    
    // MARK: ----- password -----
    class func verifyPasswordOld(password : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        
        if password.length == 0 {
            verifyObj.message = vcErrorPasswordOld
            
        } else if password.length < 6 {
            verifyObj.message = vcErrorValidPasswordOld
            
        } else {
            verifyObj.isVerified = true
        }
        
        return verifyObj
    }
    
    // MARK: ----- firstname validation -----
    class func verifyRestro_ClubAddress(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = "Please choose Restaurant/Club address."
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- given name validation -----
    class func verifyGivenname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorGivenname
        } else if text.length < 2 || !text.containsAlphabetsOnly() {
            verifyObj.message = vcErrorValidGivenname
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- family name validation -----
    class func verifyFamilyname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorFamilyname
        } else if text.length < 2 || !text.containsAlphabetsOnly() {
            verifyObj.message = vcErrorValidFAmilyname
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    class func verifyCity(text : String) -> (String, Bool) {
           var verifyObj = (message : "", isVerified : false)
           if text.length == 0 {
               verifyObj.message = vcErrorValidCityname
           }  else {
               verifyObj.isVerified = true
           }
           return verifyObj
       }
    
    // MARK: ----- lastname validation -----
    class func verifyLastname(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian{
            if text.length == 0{
                verifyObj.message = vcErrorname
            }else if text.length < 1 {
                verifyObj.message = vcErrorValidLastname
            }
            else{
                verifyObj.isVerified = true
            }
        }
        else{
            if text.length == 0 {
                verifyObj.message = vcErrorname
            } else if text.length < 1 {
                verifyObj.message = vcErrorValidname
            } else {
                verifyObj.isVerified = true
            }
        }
        
        return verifyObj

    }
    
    // MARK: ----- email / username validation -----
    class func verifyEmailOrUsername(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.length == 0 {
            verifyObj.message = vcErrorEmailOrUsername
            
        } else if text.contains("@") && !text.trimWhiteSpace.isEmail {
            verifyObj.message = vcErrorValidEmail
            
        } else if !text.contains("@") && text.length < 2  {
            verifyObj.message = vcErrorValidUsername
            
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    // MARK: ----- mobile number -----
    class func verifyPhoneNumber(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian{
            if text.length  == 0{
                verifyObj.message = vcErrorPhoneNumber
            }else if text.isArabicContainsAllZeros(){
                verifyObj.message = vcErrorValidPhoneNumber
            }else if !text.isArabicContainsNumberOnly(){
                verifyObj.message = vcErrorValidPhoneNumber
            } else if !text.isArabicValidMobileNumber(){
                verifyObj.message = vcErrorValidPhoneNumber
            }else{
                verifyObj.isVerified = true
            }
        }
        else{
            if text.length < 8 || text.length > 14{
                verifyObj.message = vcErrorPhoneNumber
                
                //        } else if text.length < 10 { //< 8 { if country code option is also on screen
                //            verifyObj.message = vcErrorValidPhoneNumber
                
            }
                //        else if text.length > 10{
                //            verifyObj.message = contactMayNOtBeGreaterThan
                //
                //        }
            else if text.isContainsAllZeros() {
                verifyObj.message = vcErrorValidPhoneNumber
                print("isContainsAllZeros",verifyObj)
                
                
            } else if !text.containsNumberOnly() {
                print("text mob number:- ",text)
                verifyObj.message = vcErrorValidPhoneNumber
                
            } else if !text.isValidMobileNumber() {
                verifyObj.message = vcErrorValidPhoneNumber
                print("text mob:- ",text)
                print(verifyObj)
            }
            
            else {
                verifyObj.isVerified = true
            }
        }
        return verifyObj
    }
    
    // MARK: ----- password -----
    class func verifyPassword(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        if text.isPersian {
            if text.length < 8{
                verifyObj.message = vcErrorValidPassword
            }else if !text.isArabicCheckTextSufficientComplexityUpperCaseNumber() {
                verifyObj.message = vcErrorAllinOne

            }else {
                verifyObj.isVerified = true
            }
        }else{
            if text.length == 0 {
                verifyObj.message = vcErrorPassword
                
            } else if text.length < 8 {
                verifyObj.message = vcErrorValidPassword
            }else if !ValidationClass.isValidPassword(text: text){
             verifyObj.message = vcErrorAllinOne
        }else {
            verifyObj.isVerified = true
        }
    }
        return verifyObj
    }
    class func isValidPassword(text : String) ->  Bool {
        var count = 0
        if text.isContainsAtleastOneSpecialCharacters(){
            count = count + 1
        }
        if text.checkTextSufficientComplexityNumber(){
            count = count + 1
        }
        if text.isContainUpperCase(){
            count = count + 1
        }
        if text.isContainLowerCase(){
            count = count + 1
        }
        if count > 2 {
            return true
        }
           return false
       
        
    }
    
    // MARK: ----- current password -----
    class func verifyCurrentPassword(text : String) -> (String, Bool) {
        var verifyObj = (message : "", isVerified : false)
        
        if text.length == 0 {
            verifyObj.message = "Please enter current password."
            
        } else if text.length < 6 {
            verifyObj.message = "Current password must contains at least 6 characters."
            
        }else if !text.isContainsAtleastOneSpecialCharacters() {
            verifyObj.message = vcErrorValidSpecialPassword
        }else {
            verifyObj.isVerified = true
        }
        
        return verifyObj
    }
    
    // MARK: ----- password and confirm password -----
    class func verifyPasswordAndConfirmPassword(password : String, confirmPassword : String) -> (String, Bool, Int) {
        var verifyObj = (message : "", isVerified : false, index: 0)
        if password.isPersian{
            if confirmPassword != password {
                verifyObj.message = vcErrorMismatchPasswrdAndConPassword
                verifyObj.index = 1
            }else{
                verifyObj.isVerified = true
            }
        }
        else{
            if password.length == 0 {
                verifyObj.message = vcErrorPassword
                verifyObj.index = 0
                
            } else if password.length < 6 {
                verifyObj.message = vcErrorValidPassword
                verifyObj.index = 0
                
            } else if confirmPassword.length == 0 {
                verifyObj.message = vcErrorConfirmPassword
                verifyObj.index = 1
                
            } else if confirmPassword != password {
                verifyObj.message = vcErrorMismatchPasswrdAndConPassword
                verifyObj.index = 1
                
            } else {
                verifyObj.isVerified = true
            }
        }
        return verifyObj
    }
    
    class func verifyDOB(dob : String, day : Int) -> (String, Bool, Int) {
        var verifyObj =  (message : "", isVerified : false, index: 0)
        
        if dob.length == 0 {
            verifyObj.message = vcErrorDate
            verifyObj.index = 0
            
        }else if day >= 0 {
            verifyObj.message = vcErrorLessDate
            verifyObj.index = 1
            
        } else {
            verifyObj.isVerified = true
        }
        return verifyObj
    }
    
    
}

