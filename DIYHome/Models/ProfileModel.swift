//
//  ProfileModel.swift
//  DIYHome
//
//  Created by Namrata Akash on 20/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ProfileModel: NSObject
{
    var profile_id :Int?;
    var user_name:String?
    var display_name:String?
    var gender:String?
    var dob:String?
    var email:String?
    var mobile_no:String?
    var area:String?
    var city:String?
    var country:String?
    var about_us:String?
    var website_details:String?
    var application_details:String?
    var user_profile_img:String?
    var user_cover_img:String?
    
    
    //Insert User Profile
    init(profile_id:Int,user_name:String,email:String)
    {
           self.profile_id = profile_id;
           self.user_name = user_name;
           self.email = email;
    }
    
    //Update User Profile
    init(profile_id:Int,user_name:String,display_name:String,gender:String,dob:String,email:String,mobile_no:String,area:String,city:String,country:String,about_us:String,website_details:String,application_details:String,user_profile_img:String,user_cover_img:String)
    {
        self.profile_id = profile_id;
        self.user_name = user_name;
        self.display_name = display_name;
        self.gender = gender;
        self.dob = dob;
        self.email = email;
        self.mobile_no = mobile_no;
        self.area = area;
        self.city = city;
        self.country = country;
        self.about_us = about_us;
        self.website_details = website_details;
        self.application_details = application_details;
        self.user_profile_img = user_profile_img;
        self.user_cover_img = user_cover_img;
    }
    
    init(profile_id:Int)
    {
         self.profile_id  = profile_id;
    }
}
