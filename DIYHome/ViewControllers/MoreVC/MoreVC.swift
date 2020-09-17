//
//  MoreVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 18/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FCAlertView
import MessageUI
import StoreKit // Rateus
import GoogleSignIn

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate, MFMailComposeViewControllerDelegate
{
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    var arrForTitle = [Any]();

    //MARK: View Controller
    override func viewDidLoad()
    {
       super.viewDidLoad()

        arrForTitle = ["Change Password",
                       "About Us",
                       "Contact Us",
                       "Rate Us",
                       "Tell Your Friend",
                       "Sign Out"];
        
       SetCustomUI();
    }
       

    //MARK: - Other Methods
    func SetCustomUI()
    {
         //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.text = "More";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
    }

    func GoToChangePasswordVC()
    {
       CommonCodeObj.PushVC(aCurrentVCObj:self, aStrNextVCIdentifier:"ChangePasswordVCIdentifier");
    }
    
    
    //MARK: - Button Methods
     @IBAction func BtnChangePWClick(_ sender: Any)
     {
         GoToChangePasswordVC();
     }

   
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForTitle.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let aCellObj = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell;
        
        aCellObj.lblTitle.text = arrForTitle[indexPath.row] as? String;
        aCellObj.lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_PRIMARY_TITLE;
        aCellObj.lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;
        if #available(iOS 13.0, *)
        {
            if(indexPath.row == 0)//Change Password
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "lock");
            }
            else if(indexPath.row == 1)//About Us
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "person");
            }
            else if(indexPath.row == 2)//Contact Us
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "phone");
            }
            else if(indexPath.row == 3)//Rate Us
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "star");
            }
            else if(indexPath.row == 4)//Tell Your Friend
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "person.3");
            }
            else//Sign Out
            {
                aCellObj.imgViewIcon.image = UIImage(systemName: "power");
            }
        }
        else
        {
            // Fallback on earlier versions
        };
        
        //aCellObj.setSelected(false, animated: true);
        return aCellObj;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)//Change Password
        {
            CommonCodeObj.PushVC(aCurrentVCObj: self, aStrNextVCIdentifier: "ChangePasswordVCIdentifier");
        }
        else if(indexPath.row == 1)//About Us
        {
            CommonCodeObj.PushVC(aCurrentVCObj: self, aStrNextVCIdentifier: "AboutUsVCIdentifier");
        }
        else if(indexPath.row == 2)//Contact Us
        {
            OpenEmailBoxForContactUs();
        }
        else if(indexPath.row == 3)//Rate Us
        {
            //Add Rate US
            RateUs();
        }
        else if(indexPath.row == 4)//Tell Your Friend
        {
            OpenActivityBoxForTellURFriend();
         }
        else//Sign Out
        {
            let aArrButtons = ["No","Yes"];
            self.ShowAlertView(strTitle:"Sign Out", strMsg:"Are you sure, You want to sign out ?", aIntTag:101, buttons:aArrButtons);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
    //MARK: - AlertView Methods
    func ShowAlertView(strTitle: String, strMsg: String, aIntTag:Int, buttons:[Any])
    {
        let alert = FCAlertView();
        alert.delegate = self;
        alert.tag = aIntTag;
        alert.hideDoneButton = true;
        if(aIntTag == 101)//SignOut
        {
            alert.makeAlertTypeCaution();
        }
        else
        {
            alert.makeAlertTypeSuccess();
        }
        
        alert.showAlert(inView: self, withTitle:strTitle, withSubtitle:strMsg, withCustomImage: nil, withDoneButtonTitle: nil, andButtons:buttons)
    }
    
   
    func fcAlertView(_ alertView: FCAlertView!, clickedButtonIndex index: Int, buttonTitle title: String!)
    {
        if(alertView.tag == 101)//SignOut
        {
            if(title == "Yes")//Yes
            {
                CommonCodeObj.RemovePlistFile(aStrPlistName: ConstantObj.USER_LOGIN_PLIST);
                CommonCodeObj.RemovePlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST);
                CommonCodeObj.PushVCWithoutAnimation(aCurrentVCObj: self, aStrNextVCIdentifier: "LoginVCIdentifier");
                //CommonCodeObj.PushVC(aCurrentVCObj: self, aStrNextVCIdentifier: "LoginVCIdentifier");
            }
            else//No
            {
                alertView.dismiss();
            }
        }
        else
        {
            print("100");
        }
    }
        
    
    //MARK: - ActivityController / Share
    func OpenActivityBoxForTellURFriend()
     {
         //Open Activity control to share app link via whatsapp, fb, etc...
    
         let aStrMessage = "\(ConstantObj.SHARE_MSG_PART_1)\(ConstantObj.APP_NAME). \(ConstantObj.SHARE_MSG_PART_2)\(ConstantObj.APP_STORE_LINK)";
         //let aStrMessage = "Hey,\n\n I'm using an awsome application called DIY Home,\n\n Please check and install from here: https://www.google.com";
         print(aStrMessage);
         
         let aArrActivityItems = [aStrMessage];
         let aActivityVCObj = UIActivityViewController(activityItems: aArrActivityItems, applicationActivities: nil);
         aActivityVCObj.excludedActivityTypes = [.postToVimeo, .postToTencentWeibo];
         present(aActivityVCObj, animated: true);
     }
    
    
    //MARK: - Email Composer
    func OpenEmailBoxForContactUs()
       {
           let aStrEmailTitle = "Contact Us | \(ConstantObj.APP_NAME)";
           let aStrMessageBody = "";
           let aStrToRecipents = ["contactdiyhome@gmail.com"];
           
           let aMailComposerVCObj: MFMailComposeViewController = MFMailComposeViewController();
           aMailComposerVCObj.mailComposeDelegate = self;
           aMailComposerVCObj.setSubject(aStrEmailTitle);
           aMailComposerVCObj.setMessageBody(aStrMessageBody, isHTML: false);
           aMailComposerVCObj.setToRecipients(aStrToRecipents);

           self.present(aMailComposerVCObj, animated: true, completion: nil);
       }
       
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result
        {
        case .cancelled:
                print("Mail cancelled");
        case .saved:
                print("Mail saved");
        case .sent:
                print("Mail sent");
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))");
            default:
                break
        }
        controller.dismiss(animated: true);
    }

    //MARK: - Rate Us

    func RateUs()
    {

        if #available(iOS 10.3, *)
        {

            SKStoreReviewController.requestReview()

        }
        else
        {

            let appID = ConstantObj.YOUR_APP_STORE_ID;
            let urlStr = "https://itunes.apple.com/app/id\(appID)"; // (Option 1) Open App Page
            //let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review"; // (Option 2) Open App Review Page

            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }

            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
            }
        }
    }
    
    //MARK: - Google Sign Out
   
        @IBAction func didTapSignOut(_ sender: AnyObject)
        {
          GIDSignIn.sharedInstance().signOut()
        }
    
}
