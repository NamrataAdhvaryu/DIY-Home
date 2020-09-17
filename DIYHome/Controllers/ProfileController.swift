//
//  ProfileController.swift
//  DIYHome
//
//  Created by Namrata Akash on 20/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

@objc protocol userProfiledelegate
{
    @objc optional func insertUserProfile_returnResp(aArrJsonResponse:[Any]);
    @objc optional func updateUserProfile_returnResp(aArrJsonResponse:[Any]);
    @objc optional func getUserProfileData_returnResp(aArrJsonResponse:[Any]);
}


class ProfileController: NSObject
{
    var delegate :userProfiledelegate?;
    
    func insertUserProfile(aModelObj :ProfileModel)
    {
        let aUrlObj  = URL(string: "http://localhost/DIYHome/insertUserProfile.php");
        let aStrBodyObj = "&profile_id=\(aModelObj.profile_id!)&user_name=\(aModelObj.user_name!)&email=\(aModelObj.email!)";
        
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                   print("Delegate method called..");
               self.delegate?.insertUserProfile_returnResp!(aArrJsonResponse: result);
             });
        } 
        else
        {
            print("LOG = Something went wrong...");
        }
    }
    
    func updateUserProfile(aModelObj :ProfileModel)
    {
        let aUrlObj  = URL(string: "http://localhost/DIYHome/updateUserProfile.php");
        let aStrBodyObj = "&profile_id=\(aModelObj.profile_id!)&user_name=\(aModelObj.user_name!)&display_name=\(aModelObj.display_name!)&gender=\(aModelObj.gender!)&dob=\(aModelObj.dob!)&email=\(aModelObj.email!)&mobile_no=\(aModelObj.mobile_no!)&area=\(aModelObj.area!)&city=\(aModelObj.city!)&country=\(aModelObj.country!)&about_us=\(aModelObj.about_us!)&website_details=\(aModelObj.website_details!)&application_details=\(aModelObj.application_details!)&user_profile_img=\(aModelObj.user_profile_img!)&user_cover_img=\(aModelObj.user_cover_img!)";
        
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                   print("Delegate method called..");
               self.delegate?.updateUserProfile_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
    
    func getUserProfileData(aModelObj :ProfileModel)
    {
        let aUrlObj  = URL(string: "http://localhost/DIYHome/getProfile.php?profile_id=\( aModelObj.profile_id!)");
       print(aUrlObj!);
       if(aUrlObj != nil)
       {
           CommonWSCall().WSCallForRequest(aURLRef: aUrlObj!, completion: { (result) -> () in
             print("Delegate method called..");
              self.delegate?.getUserProfileData_returnResp!(aArrJsonResponse: result);
            });
       }
       else
       {
           print("LOG = Something went wrong...");
       }
    }
}
