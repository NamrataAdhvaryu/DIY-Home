//
//  LoginModel.swift
//  DIYHome
//
//  Created by Namrata Akash on 19/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import Foundation

class loginModel
{
    var email:String?
    var password:String?
    var user_name:String?

    init(email:String,user_password:String)
    {
       self.email  = email;
       self.password  = user_password;
    }
    

    //To get userid just after registration process, to save data in user profile
    init(user_name:String,email:String)
    {
        self.user_name = user_name;
        self.email = email;
    }
    
    
    //To get ForgotPassword
    init(email:String)
     {
         self.email  = email;
     }
}
