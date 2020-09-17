//
//  LoginVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 09/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FCAlertView
import BEMCheckBox

import GoogleSignIn

class LoginVC: UIViewController, FCAlertViewDelegate, userLogindelegate, userRegistrationdelegate, BEMCheckBoxDelegate, userProfiledelegate
{
    //MARK: - Outlets
    @IBOutlet weak var imgViewBtnUnderLine: UIImageView!
    @IBOutlet weak var btnLoginTab: UIButton!
    @IBOutlet weak var btnRegisterTab: UIButton!
    @IBOutlet weak var viewMainTab: UIView!
    
    //Login
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    //Register
    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet weak var txtFieldRegUserName: UITextField!
    @IBOutlet weak var txtFieldRegEmail: UITextField!
    @IBOutlet weak var txtFieldRegPW: UITextField!
    @IBOutlet weak var txtFieldRegConfirmPW: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var aBoolRememberMe = false;
    @IBOutlet weak var signInButton: GIDSignInButton!
   
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
        btnLoginTab.isUserInteractionEnabled = false;
        SetCustomUI();
        
        if CommonCodeObj.CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName: ConstantObj.USER_LOGIN_PLIST)
        {
              CommonCodeObj.PushVCWithoutAnimation(aCurrentVCObj:self, aStrNextVCIdentifier:"TabBarIdentifier");
        }
        
        if(!boolLiveApp)
        {
            txtFieldEmail.text = "k@a.com";
            txtFieldPassword.text = "12345";
        }
        //GoogleSignIn();
    }
    
    
    //MARK: - Google SignIn
    func GoogleSignIn()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    
    //MARK: - Button Click
    @IBAction func BtnLoginTabClick(_ sender: Any)
    {
        GotoLoginTab();
    }
    
    @IBAction func BtnLoginClick(_ sender: Any)
    {
        CallWSLogin();
    }
    
    func didTap(_ checkBox: BEMCheckBox)
    {
        if(checkBox.on)
        {
            print("on");
            aBoolRememberMe = true;
        }
    }
    
    @IBAction func BtnForgotPasswordClick(_ sender: Any)
    {
        CommonCodeObj.PushVC(aCurrentVCObj:self, aStrNextVCIdentifier:"ForgotPasswordVCIdentifier");
    }
    
    @IBAction func BtnRegisterTabClick(_ sender: Any)
    {
        btnLoginTab.isUserInteractionEnabled = true;
        btnRegisterTab.isUserInteractionEnabled = false;
        
        UIView.animate(withDuration: 0.5,
                          delay: 0.1,
                        options: .curveEaseOut,
                        animations: { [weak self] in
                            
                            self?.viewLogin.frame = CGRect(x: -380, y: self?.viewLogin.frame.origin.y ?? 0, width: 350, height: self?.viewLogin.frame.size.height ?? 0);
                            
                            self?.viewRegister.frame = CGRect(x: 45, y: self?.viewRegister.frame.origin.y ?? 0, width: 350, height: self?.viewRegister.frame.size.height ?? 0);
                
                            self?.imgViewBtnUnderLine.frame = CGRect(x: 135, y: self?.imgViewBtnUnderLine.frame.origin.y ?? 0, width: 62, height: self?.imgViewBtnUnderLine.frame.size.height ?? 0);
                            
            }, completion: nil);
    }
    
    @IBAction func BtnRegisterClick(_ sender: Any)
    {
        CallWSRegistration();
    }
  
    
    //MARK: - Other Methods
    func SetCustomUI()
    {
        //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        btnLoginTab.setTitleColor(ConstantObj.COLOR_APP_THEME_BUTTON_BG, for: .normal);
        btnRegisterTab.setTitleColor(ConstantObj.COLOR_APP_THEME_BUTTON_BG, for: .normal);
        imgViewBtnUnderLine.backgroundColor = ConstantObj.COLOR_APP_THEME_BUTTON_BG;
        
        //Login
        txtFieldPassword.SetBottomBorderForTextField(aFloatBottomY: 1.0);
        txtFieldEmail.SetBottomBorderForTextField(aFloatBottomY: 1.0);
        btnLogin.CreateRoundButton(aCornerRadius:30);
        self.viewLogin.frame = CGRect(x: 45, y: self.viewLogin.frame.origin.y, width: 350, height: self.viewLogin.frame.size.height);
       
       //Register
       txtFieldRegUserName.SetBottomBorderForTextField(aFloatBottomY: 1.0);
       txtFieldRegEmail.SetBottomBorderForTextField(aFloatBottomY: 1.0);
       txtFieldRegPW.SetBottomBorderForTextField(aFloatBottomY: 1.0);
       txtFieldRegConfirmPW.SetBottomBorderForTextField(aFloatBottomY: 1.0);
       btnRegister.CreateRoundButton(aCornerRadius:30);
    }
    
    func GoToHomeScreen()
    {
        CommonCodeObj.PushVC(aCurrentVCObj:self, aStrNextVCIdentifier:"TabBarIdentifier");
    }
    
    func GotoLoginTab()
    {
        btnLoginTab.isUserInteractionEnabled = false;
        btnRegisterTab.isUserInteractionEnabled = true;
        
        UIView.animate(withDuration: 0.5,
                   delay: 0.1,
                 options: .curveEaseOut,
                 animations: { [weak self] in
                     
                    self?.viewLogin.frame = CGRect(x: 45, y: self?.viewLogin.frame.origin.y ?? 0, width: 350, height: self?.viewLogin.frame.size.height ?? 0);
                    self?.viewRegister.frame = CGRect(x: 414, y: self?.viewRegister.frame.origin.y ?? 0, width: 350, height: self?.viewRegister.frame.size.height ?? 0);
                    
                    self?.imgViewBtnUnderLine.frame = CGRect(x: 58, y: self?.imgViewBtnUnderLine.frame.origin.y ?? 0, width: 44, height: self?.imgViewBtnUnderLine.frame.size.height ?? 0);
                    
        }, completion: nil);
    }
    
    
    //MARK: - Webservice Request Call
 
    func CallWSRegistration()
    {
        let aRegContrlObj = UserRegistrationController();
        aRegContrlObj.delegate = self;
        let aModelObj  = UserRegistrationModel(user_name: txtFieldRegUserName.text!, email: txtFieldRegEmail.text!, user_password: txtFieldRegPW.text!);
        aRegContrlObj.userRegistration(aRegModelObj: aModelObj);
    }
    
    func CallWSToGetRegisteredUserID()
    {
           let aLoginContrlObj = LoginController();
           aLoginContrlObj.delegate = self;
           let aModelObj = loginModel(user_name: txtFieldRegUserName.text!, email: txtFieldRegEmail.text!);
           aLoginContrlObj.getUserID(aLoginModelObj: aModelObj);
    }
    
    func CallWSToUpdateUserProfileData(aDictRef:[String:Any])
    {
        let aIntProfileId = Int(aDictRef["id"] as! String)!
        let aContrlObj = ProfileController();
        aContrlObj.delegate = self;
        
        let aModelObj  = ProfileModel(profile_id: aIntProfileId,
           user_name: txtFieldRegUserName.text!,
           email: txtFieldRegEmail.text!);
           aContrlObj.insertUserProfile(aModelObj: aModelObj);
    }
    
    func CallWSLogin()
     {
         let aLoginContrlObj = LoginController();
         aLoginContrlObj.delegate = self;
         let aModelObj  = loginModel(email: txtFieldEmail.text!, user_password: txtFieldPassword.text!);
         aLoginContrlObj.userLogin(aLoginModelObj: aModelObj);
     }
    
    
    //MARK: - Webservice Response
    
    //Delegate method for user registration
    func userReg_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
        let aDictTemp  = aArrJsonResponse[0] as? [String:Any];
        let aStrStatus  = aDictTemp!["status"] as? String;
            
        if aStrStatus  == "Success"
        {
             DispatchQueue.main.async
             {
                 self.ShowAlertView(strTitle:"Success", strMsg:"Record Inserted Sucessfully ...", strDoneBtnTitle:"Ok", aIntTag:102);
                self.CallWSToGetRegisteredUserID()
             }
             print("LOG = Record Inserted Sucessfully ...");

        }
        else
        {
           self.ShowAlertView(strTitle:"Alert", strMsg:"Something went wrong..", strDoneBtnTitle:"Ok", aIntTag:100);
            print("LOG = Failed ...");
        }
    }

    func getUserID_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
  
        if aArrJsonResponse.count == 1
        {
            DispatchQueue.main.async
            {
                let aDictTemp = aArrJsonResponse[0] as? [String:Any];
                self.CallWSToUpdateUserProfileData(aDictRef: aDictTemp!);
            }
            print("LOG = Got data sucessfully ...");
        }
        else
        {
            print("LOG = Failed ...");
        }
    }
    
   //Delegate method for to save user data in user profile
   func insertUserProfile_returnResp(aArrJsonResponse: [Any])
   {
       print("aArrJsonResponse:\(aArrJsonResponse)");
       let aDictTemp  = aArrJsonResponse[0] as? [String:String];
       let aStrStatus  = aDictTemp!["status"];
       
       if aStrStatus == "Success"
       {
            print("LOG = Record Inserted Sucessfully ...");
       }
       else
       {
           print("LOG = Failed ...");
       }
     }
       
    //Delegate method for user login
      func userLogin_returnResp(aArrJsonResponse: [Any])
      {
          print(aArrJsonResponse);
          if aArrJsonResponse.count == 1
          {
              print("LOG = Login successfullly...");
              
              DispatchQueue.main.async
              {
                self.GoToHomeScreen();
              }
           
            //Save User Data in Plist file for future use
            let aDictTempObj = aArrJsonResponse[0];
            print(aDictTempObj);
            CommonCodeObj.CreatePlistFile(aStrPlistName:ConstantObj.USER_LOGIN_PLIST, aDictObj: aDictTempObj as! [String : String]);
          }
          else
          {
              self.ShowAlertView(strTitle:"Alert", strMsg:"Something went wrong..", strDoneBtnTitle:"Ok", aIntTag:100);
              print("LOG = Something went wrong..");
          }
      }
   
    
    //MARK: - AlertView Methods
    func ShowAlertView(strTitle: String, strMsg: String, strDoneBtnTitle: String, aIntTag:Int)
    {
        let alert = FCAlertView();
        alert.delegate = self;
        alert.tag = aIntTag;
        if(aIntTag == 100)
        {
            alert.makeAlertTypeWarning();
        }
        else
        {
            alert.makeAlertTypeSuccess();
        }
        alert.showAlert(inView: self, withTitle:strTitle, withSubtitle:strMsg, withCustomImage: nil, withDoneButtonTitle: strDoneBtnTitle, andButtons:nil)
    }
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView)
    {
        if(alertView.tag == 101)//Login
        {
            self.GoToHomeScreen();
        }
        else if(alertView.tag == 102)//Register
        {
            self.GotoLoginTab();
        }
        else//Error
        {
            
        }
    }
}
