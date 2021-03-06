//
//  AppDelegate.swift
//  DIYHome
//
//  Created by Namrata Akash on 08/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
var a = 10

let boolLiveApp = true;
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.shared.enable = true;
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 150.0;
        IQKeyboardManager.shared.toolbarTintColor = .blue;//APP_THEME_COLOR_DARK_PINK;
        return true
    }
    
    
    //MARK: - UISceneSession Lifecycle
    
    @available(iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    //MARK: - Google SignIn
    func GoogleSignInIntegration()
    {
        // Initialize sign-in (Google)
        GIDSignIn.sharedInstance().clientID = ConstantObj.GOOGLE_CLIENT_ID;
        GIDSignIn.sharedInstance().delegate = self;
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        if let error = error
        {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue
            {
                    print("The user has not signed in before or they have since signed out.")
            }
            else
            {
                print("\(error.localizedDescription)")
            }
            return
        }
          // Perform any operations on signed in user here.
          let userId = user.userID                  // For client-side use only!
          let idToken = user.authentication.idToken // Safe to send to the server
          let fullName = user.profile.name
          let givenName = user.profile.givenName
          let familyName = user.profile.familyName
          let email = user.profile.email
          // ...
        
        print("userId:\(userId!)");
        print("fullName:\(fullName!)");
        print("givenName:\(givenName!)");
        print("familyName:\(familyName!)");
        print("email:\(email!)");
        print("idToken:\(idToken!)");
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!)
    {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
}


/*
IOS 12 Support: 
https://www.donnywals.com/add-ios-12-support-to-a-new-xcode-11-project/
*/
