//
//  UserRegistrationModel.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class UserRegistrationModel: NSObject
{
        var id:Int?;
        var user_name:String?
        var email:String?
        var password:String?

        init(user_name:String,email:String,user_password:String)
        {
            self.user_name = user_name;
            self.email  = email;
            self.password  = user_password;
        }
            
    
        init(id:Int)
        {
             self.id = id;
        }
    
    
        //Change Password
        init(id:Int, password:String)
        {
            self.id = id;
            self.password = password;
        }

}
