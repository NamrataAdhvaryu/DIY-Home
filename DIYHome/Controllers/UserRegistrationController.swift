//
//  UserRegistrationController.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

@objc protocol userRegistrationdelegate
{
    @objc optional func userReg_returnResp(aArrJsonResponse:[Any]);
    @objc optional func changePassword_returnResp(aArrJsonResponse:[Any]);
}

//Login And User Registration
class UserRegistrationController: NSObject
{
    var delegate :userRegistrationdelegate?;
    
    func userRegistration(aRegModelObj :UserRegistrationModel)
    {
        let aUrlObj  = URL(string:"http://192.168.64.2/DIYHome/userRegistration.php");
        let aStrBodyObj = "user_name=\(aRegModelObj.user_name!)&email=\(aRegModelObj.email!)&password=\(aRegModelObj.password!)";
        
        if(aUrlObj != nil)//|| aStrBodyObj != nil )
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                 print("Delegate method called..");
               self.delegate?.userReg_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
    
    func changePassword(aRegModelObj :UserRegistrationModel)
    {
        let aUrlObj  = URL(string: "http://192.168.64.2/DIYHome/changePassword.php");
        let aStrBodyObj = "&id=\(aRegModelObj.id!)&password=\(aRegModelObj.password!)";
        
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                   print("Delegate method called..");
               self.delegate?.changePassword_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
}
