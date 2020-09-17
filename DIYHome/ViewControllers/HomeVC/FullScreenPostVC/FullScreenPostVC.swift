//
//  FullScreenPostVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 02/07/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FaveButton
//import ImageCarouselView

//import TAPageControl

class FullScreenPostVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FaveButtonDelegate, userProfiledelegate, userPostdelegate, UIScrollViewDelegate//, TAPageControlDelegate
{
    
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblViewObj: UITableView!
    @IBOutlet weak var scrollViewObj: UIScrollView!
    
    var dictForPostData = [String:Any]();
    var dictForUserData = [String:Any]();
    var aIntProfileIDRef = Int();
    var aIntPostId = Int();
    
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        GetDataToDisplay();
    }

    
    //MARK: - Other Methods
    func SetCustomUI()
    {
         //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.text = "Post";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        btnBack.CreateRoundButton(aCornerRadius:30);
    }
    
    func GetDataToDisplay()
    {
        print("dictForPostData:\(dictForPostData)");

        aIntProfileIDRef = Int(dictForPostData["posted_user_id"] as! String)!
        print("aIntProfileIDRef:\(aIntProfileIDRef)");

        aIntPostId = Int(dictForPostData["post_id"] as! String)!
        print("aIntPostId:\(aIntPostId)");
        
        CallWSToGetProfileData(aIntProfileId: aIntProfileIDRef);
        SetCustomUI();
    }
    
    
    //MARK: - Button Click Methods
     @IBAction func BtnBackClick(_ sender: Any)
     {
         self.navigationController?.popViewController(animated: true);
     }
    
    @IBAction func BtnShowUserProfileClick()
    {
        if(aIntProfileIDRef == CommonCodeObj.GetCurrentUserID())
        {
            //NOTE: If current user click here, than go to My Profile tab
            self.navigationController?.popToRootViewController(animated: false);
        }
        else
        {
            //NOTE: Show Other user's profile screen
            let aViewProfileVCObj =  self.storyboard?.instantiateViewController(withIdentifier:"ViewProfileVCIdentifier") as! ViewProfileVC;
            aViewProfileVCObj.aIntProfileIdRef = aIntProfileIDRef;
            self.navigationController?.pushViewController(aViewProfileVCObj, animated: true);
        }
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool)
    {
        if(faveButton.tag == 52)//Share
        {
            OpenActivityBoxToShareThisPost();
        }
        else //(51)=Like
        {
            if(selected)
            {
                CallWSToUpdateLikeStatusForPost(aStrLikeStatus: "1");
            }
            else
            {
                CallWSToUpdateLikeStatusForPost(aStrLikeStatus: "0");
            }
        }
    }
    
    //MARK: - UITableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as! PostTitleCell;
            var aStrUserName = "";
            if(dictForUserData.count > 0)
            {
                aStrUserName = dictForUserData["user_name"] as! String;
            }
            
            //Display User Pic
            aCellObj.btnProfilePic.CreateRoundButton(aCornerRadius:30);
            aCellObj.btnProfilePic.addTarget(self, action: #selector(BtnShowUserProfileClick), for: .touchUpInside);

            //Print User Name
            aCellObj.btnUserName.titleLabel?.text = aStrUserName;
            aCellObj.btnUserName.addTarget(self, action: #selector(BtnShowUserProfileClick), for: .touchUpInside);
            
            //Print Date Value
            let aStrDate = dictForPostData["date_time"] as! String;
            let aStrCurDate = CommonCodeObj.GetCurrentDateTime();
            let aStrPrintVal = CommonCodeObj.GetPrintedValueBaseOnDate(aStrStartDate: aStrDate, aStrEndDate: aStrCurDate);
            aCellObj.lblDateTime?.text = aStrPrintVal ;
            
            //Print Title Value
            let aStrPostTitle = (dictForPostData["title"] as! String);
            aCellObj.lblPostTitle?.text = aStrPostTitle;
            return aCellObj;
        }
        else if(indexPath.row == 1)
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "ImageVideoCell", for: indexPath) as! ImageVideoCell;
            
            //Display Post Image
            let aStrImgNameList = dictForPostData["image_list"] as! String;
            let aStrImgName = CommonCodeObj.GetFirstSingleImgFromArray(aStrImgNames: aStrImgNameList);
            aCellObj.imgViewPost.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrImgName));
            
            return aCellObj;
        }
        else if(indexPath.row == 2)
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "LikeCommentCell", for: indexPath) as! LikeCommentCell;
            let aStrLikeStatus = (dictForPostData["likePost"] as! String);
            if(aStrLikeStatus == "1")
            {
                aCellObj.btnLike.isSelected = true;
            }
            else
            {
                aCellObj.btnLike.isSelected = false;
            }
            return aCellObj;
        }
        else
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell;
            
            let aStrPostDiscription = (dictForPostData["post_description"] as! String);
            aCellObj.txtViewDiscription?.text = aStrPostDiscription;
            return aCellObj;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            return 111;
        }
        else if(indexPath.row == 1)
        {
            return 280;
        }
        else if(indexPath.row == 2)
        {
            return 60;
        }
        else//3
        {
            return 400;
        }
    }
   

//MARK: - ActivityController / Share
   func OpenActivityBoxToShareThisPost()
    {
        //Open Activity control to share app link via whatsapp, fb, etc...
        //let items: [Any] = ["This app is my favorite", URL(string: "https://www.apple.com")!]
        
        let aStrPostTitle = (dictForPostData["title"] as! String);
        print(aStrPostTitle);
        let aStrImgNameList = dictForPostData["image_list"] as! String;
        let aStrImgName = CommonCodeObj.GetFirstSingleImgFromArray(aStrImgNames: aStrImgNameList);
        let aImgRef = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrImgName));
        
        let aArrImgItems = [aImgRef];
        let aArrActivityItems = [aStrPostTitle, aArrImgItems] as [Any];
        let aActivityVCObj = UIActivityViewController(activityItems: aArrActivityItems, applicationActivities: nil);
        aActivityVCObj.excludedActivityTypes = [.postToVimeo, .postToTencentWeibo];
        present(aActivityVCObj, animated: true);
    }

    //MARK: - Webservice Request Call
    func CallWSToGetProfileData(aIntProfileId: Int)
    {
           let aContrlObj = ProfileController();
           aContrlObj.delegate = self;
           let aModelObj = ProfileModel(profile_id:aIntProfileId);
           aContrlObj.getUserProfileData(aModelObj:aModelObj);
    }
    
    func CallWSToUpdateLikeStatusForPost(aStrLikeStatus: String)
    {
        let aContrlObj = PostController();
        aContrlObj.delegate = self;
        let aModelObj  = PostModel(likePost: aStrLikeStatus, post_id: aIntPostId);
        aContrlObj.updateLikeStatusForPost(aModelObj: aModelObj);
    }
    
    
    //MARK: - Webservice Response
    func getUserProfileData_returnResp(aArrJsonResponse: [Any])
    {
       print(aArrJsonResponse);

       if aArrJsonResponse.count == 1
       {
           print("LOG =  Successfullly get user profile data...");

           dictForUserData = aArrJsonResponse[0] as! [String : String];
           print("getUserProfileData_returnResp dictForUserData:\(dictForUserData)");
           tblViewObj.reloadData();
       }
       else
       {
           print("LOG = Something went wrong..");
       }
   }
    
    func updateLikeStatusForPost_returnResp(aArrJsonResponse: [Any])
    {
        print("updateLikeStatusForPost_returnResp aArrJsonResponse:\(aArrJsonResponse)");
        let aDictTemp  = aArrJsonResponse[0] as? [String:String];
        let aStrStatus  = aDictTemp!["status"];
        
        if aStrStatus  == "Success"
        {
             print("LOG = Sucessfully updated like status for post...");
        }
        else
        {
            print("LOG = Failed to update like status for post...");
        }
    }
}
