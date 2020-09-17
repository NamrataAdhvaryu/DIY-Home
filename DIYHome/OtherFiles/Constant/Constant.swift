//
//  Constant.swift
//  DIYHome
//
//  Created by Namrata Akash on 16/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import Foundation
import UIKit

class Constant
{

    //MARK: - COLOR
    let COLOR_APP_THEME_MAIN_BG             = UIColor(hexString: "#FFABC4")//LIGHT PINK OR #F48FB1
    let COLOR_APP_THEME_PRIMARY             = UIColor(hexString: "#BF5F82")//DARK PINK
    let COLOR_APP_THEME_SECONDARY           = UIColor(hexString: "#FCE4EC")//LIGHT WHITE TYPE
    //let COLOR_APP_THEME_SECONDARY_1       = UIColor(hexString: "#FFC1E3")//EXTRA LIGHT PINK
    
    let COLOR_APP_THEME_TEXT_MAIN_TITLE     = UIColor(hexString: "#4E0D0F")//EXTRA DARK PINK
    let COLOR_APP_THEME_TEXT_NORMAL_TITLE   = UIColor(hexString: "#BF5F82")//DARK PINK
    let COLOR_APP_THEME_TEXT_PRIMARY_TITLE  = UIColor(hexString: "#905068")//LESS DARK PINK
    //let COLOR_APP_THEME_TEXT_LESS_TITLE   = UIColor(hexString: "#FCE4EC")//LIGHT WHITE TYPE
    
    let COLOR_APP_THEME_BUTTON_BG           = UIColor(hexString: "#BF5F82")//DARK PINK
    let COLOR_APP_THEME_BUTTON_TEXT         = UIColor(hexString: "#F9F9F9")//WHITE TYPE
    //let COLOR_APP_THEME_BUTTON_BG         = UIColor(hexString: "#FFC1E3")//#905068
    
    
    //let color                       = UIColor(hexString: "#3f3f3f")
    //let APP_THEME_COLOR_DARK_PINK   = UIColor(red: 144.0/255.0, green: 80.0/255.0, blue: 104.0/255.0, alpha: 1.0);
    //let APP_THEME_COLOR_MID_PINK    = UIColor(red: 191.0/255.0, green: 95.0/255.0, blue: 130.0/255.0, alpha: 1.0);//BF5F82
    //let APP_THEME_COLOR_LIGHT_PINK  = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 196.0/255.0, alpha: 1.0);//FFABC4

    
    //MARK: - URL
    //http://192.168.64.2
    let BASE_URL                 = "http://localhost/DIYHome/"
    
    
    //MARK: - Apple Account (Rate us)
    let YOUR_APP_STORE_ID =  545174222; //Change this one to your ID
    let GOOGLE_CLIENT_ID = "559875336762-a8f67kvksp9cjij8lgcp0qjmkt1ntr9q.apps.googleusercontent.com";
    //https://console.developers.google.com/apis/dashboard?project=diyhome-1595915000097&authuser=0&pli=1
    //https://developers.google.com/identity/sign-in/ios/start-integrating
    
    
    //MARK: - FONT
    let FONT_TEXTFIELD_TITLE     = UIFont(name:"HelveticaNeue-Light", size:17);
    let FONT_TBL_HEADER_TITLE    = UIFont(name:"HelveticaNeue-Light", size:26);
    
    
    //MARK: - TEXT
    let APP_NAME                 =  "DIY Home"
    let APP_STORE_LINK           =  "https://www.google.com"
    let SHARE_MSG_PART_1         =  "Hey,\n\nI'm using an awsome app called "
    let SHARE_MSG_PART_2         =  "\n\nPlease check and install from here:\n"
    
    
    //MARK: - Plist File Name
    let USER_LOGIN_PLIST         = "UserLogin"
    let USER_PROFILE_PLIST       = "UserProfile"
    
    
    //MARK: -  SKPSMTPMessage ID/PW
    let EMAIL_ID = "login@gmail.com"
    let EMAIL_PW = "PASSWORD"
    
}
