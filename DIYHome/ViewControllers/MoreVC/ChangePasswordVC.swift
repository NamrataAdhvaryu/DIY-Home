//
//  ChangePasswordVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 10/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FCAlertView

class ChangePasswordVC: UIViewController, userRegistrationdelegate, FCAlertViewDelegate
{
    
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var txtFieldOldPW: UITextField!
    @IBOutlet weak var txtFieldNewPW: UITextField!
    @IBOutlet weak var txtFieldNewConfirmPW: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    var dictPrevLoginDetailsRef = [String:String]();
    var aDictForPrevLoginDetails = [String:String]();
    
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetCustomUI();
    }
    
    
    //MARK: - Other Methods
     func SetCustomUI()
     {
         //Common
         self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
         lblNavBarTitle.text = "Change Password";
         lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
         btnBack.CreateRoundButton(aCornerRadius:30);
         
         txtFieldOldPW.SetBottomBorderForTextField(aFloatBottomY: 1.0);
         txtFieldNewPW.SetBottomBorderForTextField(aFloatBottomY: 1.0);
         txtFieldNewConfirmPW.SetBottomBorderForTextField(aFloatBottomY: 1.0);
         btnSend.CreateRoundButton(aCornerRadius:30);
     }
    
    @IBAction func BtnBackClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func BtnSendClick(_ sender: Any)
    {
        var aStrPrevPassword = "";
        if (CommonCodeObj.CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName: ConstantObj.USER_LOGIN_PLIST))
        {
            dictPrevLoginDetailsRef = CommonCodeObj.ReadDataFromPlistFile(aStrPlistName: ConstantObj.USER_LOGIN_PLIST);
            print("dictPrevLoginDetailsRef:\(dictPrevLoginDetailsRef)");
            
            aStrPrevPassword = dictPrevLoginDetailsRef["password"]!;
       }
        
        if(txtFieldOldPW.text == aStrPrevPassword)
        {
            CallWSChangePassword();
        }
        else
        {
            //Old Pw nt match
               self.ShowAlertView(strTitle:"Alert", strMsg:"Please enter correct old password.", strDoneBtnTitle:"Ok", aIntTag:102);
        }
    }
    
    //MARK: - Webservice Request Call

   func CallWSChangePassword()
   {
       let aRegContrlObj = UserRegistrationController();
       aRegContrlObj.delegate = self;
        let aModelObj  = UserRegistrationModel(id: CommonCodeObj.GetCurrentUserID(), password: txtFieldNewPW.text!);
       aRegContrlObj.changePassword(aRegModelObj: aModelObj);
   }
       
    
    //MARK: - Webservice Response
      

    func changePassword_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
        let aDictTemp  = aArrJsonResponse[0] as? [String:Any];
        let aStrStatus  = aDictTemp!["status"] as? String;

        if aStrStatus  == "Success"
        {
            DispatchQueue.main.async
            {
                self.ShowAlertView(strTitle:"Success", strMsg:"Password updated sucessfully ...", strDoneBtnTitle:"Ok", aIntTag:101);

                //Remove Plist file bcz it have old password
                CommonCodeObj.RemovePlistFile(aStrPlistName: ConstantObj.USER_LOGIN_PLIST);

                //Update New dictionary for
                let aStrPrevId = self.dictPrevLoginDetailsRef["id"]!;
                let aStrPrevUserName = self.dictPrevLoginDetailsRef["user_name"]!;
                let aStrPrevEmail = self.dictPrevLoginDetailsRef["email"]!;
                let aStrPrevPassword = self.txtFieldNewPW.text;

                self.aDictForPrevLoginDetails["id"] = aStrPrevId;
                self.aDictForPrevLoginDetails["user_name"] = aStrPrevUserName;
                self.aDictForPrevLoginDetails["email"] = aStrPrevEmail;
                self.aDictForPrevLoginDetails["password"] = aStrPrevPassword;
                print(self.aDictForPrevLoginDetails)

                //Create new plist file to save new updated password
                CommonCodeObj.CreatePlistFile(aStrPlistName:ConstantObj.USER_LOGIN_PLIST, aDictObj:self.aDictForPrevLoginDetails);
            }
            print("LOG = Password Updated Sucessfully..");
        }
        else
        {
            self.ShowAlertView(strTitle:"Alert", strMsg:"Something went wrong..", strDoneBtnTitle:"Ok", aIntTag:100);
            print("LOG = Failed ...");
        }
    }
    
    
    //MARK: - AlertView Methods
    func ShowAlertView(strTitle: String, strMsg: String, strDoneBtnTitle: String, aIntTag:Int)
    {
        let alert = FCAlertView();
        alert.delegate = self;
        alert.tag = aIntTag;
        if(aIntTag == 100 || aIntTag == 102)
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
            self.navigationController?.popViewController(animated: true);
        }
        else//Error
        {
            
        }
    }
}
