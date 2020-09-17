//
//  LoginController.swift
//  DIYHome
//
//  Created by Namrata Akash on 19/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

@objc protocol userLogindelegate
{
    @objc optional func userLogin_returnResp(aArrJsonResponse:[Any]);
    @objc optional func getUserID_returnResp(aArrJsonResponse:[Any]);
    @objc optional func getForgotPW_returnResp(aArrJsonResponse:[Any]);
}

class LoginController: NSObject
{
    var delegate :userLogindelegate?;
    
    func userLogin(aLoginModelObj :loginModel)
    {
        let aUrlObj = URL(string:"http://localhost/DIYHome/userLogin.php?email=\(String(describing: aLoginModelObj.email!))&password=\(aLoginModelObj.password!)");
        print(aUrlObj!);
        
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForRequest(aURLRef: aUrlObj!, completion: { (result) -> () in
                print("Delegate method called..");
                self.delegate?.userLogin_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
    
    func getUserID(aLoginModelObj :loginModel)
    {
           let aUrlObj = URL(string:"http://localhost/DIYHome/getUserID.php?user_name=\(String(describing: aLoginModelObj.user_name!))&email=\(aLoginModelObj.email!)");
           print(aUrlObj!);
           
           if(aUrlObj != nil)
           {
               CommonWSCall().WSCallForRequest(aURLRef: aUrlObj!, completion: { (result) -> () in
                   print("Delegate method called..");
                   self.delegate?.getUserID_returnResp!(aArrJsonResponse: result);
                });
           }
           else
           {
               print("LOG = Something went wrong...");
           }
    }
 
    func getForgotPW(aLoginModelObj :loginModel)
    {
           let aUrlObj = URL(string:"http://192.168.64.2/DIYHome/getForgotPassword.php?email=\(String(describing: aLoginModelObj.email!))");
           print(aUrlObj!);
           
           if(aUrlObj != nil)
           {
               CommonWSCall().WSCallForRequest(aURLRef: aUrlObj!, completion: { (result) -> () in
                   print("Delegate method called..");
                   self.delegate?.getForgotPW_returnResp!(aArrJsonResponse: result);
                });
           }
           else
           {
               print("LOG = Something went wrong...");
           }
    }
}
