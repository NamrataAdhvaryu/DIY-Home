//
//  ViewProfileVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 15/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ViewProfileVC: UIViewController, userProfiledelegate, userPostdelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

     //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgViewCoverPic: UIImageView!
    @IBOutlet weak var viewProfileBox: UIView!
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var btnEditFollow: UIButton!
    @IBOutlet weak var btnViewAllContent: UIButton!
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
    var dictForResponse = [String: String]();
    var arrForFilteredPost = [Any]();
    var dictForPostedData = [String:Any]();
    var aIntProfileIdRef = Int();
    var aBoolCurrentUser = Bool();
    
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if(aIntProfileIdRef == 0)
        {
            aIntProfileIdRef = CommonCodeObj.GetCurrentUserID();
        }
        
        if(CommonCodeObj.IsProfileIDAndCurrentUserIDAreSame(aIntProfileId: aIntProfileIdRef))
        {
            //This is Current User
            aBoolCurrentUser = true;
            if (CommonCodeObj.CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName: ConstantObj.USER_PROFILE_PLIST))
            {
                dictForResponse = CommonCodeObj.ReadDataFromPlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST);
                print(dictForResponse);//["status": "Success"]
                SetDataFromResponse();
            }
            else
            {
                CallWSToGetProfileData(aIntProfileID: CommonCodeObj.GetCurrentUserID());
            }
        }
        else
        {
            //This is Other User
            aBoolCurrentUser = false;
            CallWSToGetProfileData(aIntProfileID: aIntProfileIdRef);
        }
        SetCustomUI();
        CallWSToGetPostedData();
    }

    
    //MARK: - Other Methods
    func SetCustomUI()
    {
        if(aBoolCurrentUser)
        {
            lblNavBarTitle.text = "My Profile";
            btnEditFollow.setTitle("Edit Profile", for: .normal);
            btnBack.isHidden = true;
        }
        else
        {
            lblNavBarTitle.text = "User Profile";
            btnEditFollow.setTitle("Follow Me", for: .normal);
            btnBack.isHidden = false;
            btnBack.CreateRoundButton(aCornerRadius:30);
        }
        
        //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        viewProfileBox.SetShadowEffectOnView(cornerRadius: 20, borderWidth: 0.5);

        lblUserName.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        lblLocation.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        lblAboutUs.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;

        btnEditFollow.backgroundColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        btnEditFollow.layer.cornerRadius = btnEditFollow.frame.size.height / 2;
        btnEditFollow.setTitleColor(.white, for: .normal);

        imgViewProfilePic.layer.borderColor = UIColor.white.cgColor;
        imgViewProfilePic.layer.borderWidth = 2;

        btnViewAllContent.backgroundColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        btnViewAllContent.layer.cornerRadius = btnEditFollow.frame.size.height / 2;
        btnViewAllContent .setTitleColor(.white, for: .normal);
    }

    func SetDataFromResponse()
    {
        if(dictForResponse.keys.count > 0)
        {
            //Set Personal Details
            lblUserName.text = dictForResponse["user_name"]!;
            lblLocation.text = dictForResponse["city"]!;
            lblAboutUs.text = dictForResponse["about_us"]!;
            //if(lblAboutUs.text?.count == 0)
            if(CommonCodeObj.StringIsNotEmpty(aStrVal: lblAboutUs.text!) || lblAboutUs.text == "")
            {
                lblAboutUs.text = "Hey friends, \nMy name is \(lblUserName.text!) and \nI love \(ConstantObj.APP_NAME) application.";
            }
            
            
            //Set Profile Pic
            let aStrProfileImgName = dictForResponse["user_profile_img"]!;
            if(CommonCodeObj.StringIsNotEmpty(aStrVal: aStrProfileImgName) && aStrProfileImgName != " ")
            {
                imgViewProfilePic.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrProfileImgName));
            }
            
            
            //Set Cover Pic
            let aStrCoverImgName = dictForResponse["user_cover_img"]!;
            if(CommonCodeObj.StringIsNotEmpty(aStrVal: aStrCoverImgName) && aStrCoverImgName != " ")
            {
                imgViewCoverPic.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrCoverImgName));
            }
        }
    }
    
    
    //MARK: - Button click
    
    @IBAction func BtnBackClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func BtnEditProfileClick(_ sender: Any)
    {
        CommonCodeObj.PushVC(aCurrentVCObj:self, aStrNextVCIdentifier:"EditProfileVCIdentifier");
    }
    
    @IBAction func BtnViewAllContentClick(_ sender: Any)
    {
    }
    
    @objc func BtnViewAllUserPostClick()
    {
        CommonCodeObj.PushVC(aCurrentVCObj: self, aStrNextVCIdentifier: "ViewAllContentVCIdentifier");
    }
    
    
    //MARK: - Webservice Request Call
    
    func CallWSToGetProfileData(aIntProfileID:Int)
    {
        let aContrlObj = ProfileController();
        aContrlObj.delegate = self;
        let aModelObj  = ProfileModel(profile_id:aIntProfileID);
        aContrlObj.getUserProfileData(aModelObj: aModelObj);
    }

    func CallWSToGetPostedData()
    {
        let aContrlObj = PostController();
        aContrlObj.delegate = self;
        aContrlObj.getUserPostData();
    }
    
    
    //MARK: - Webservice Response
    
    func getUserProfileData_returnResp(aArrJsonResponse: [Any])
    {
        print("getUserProfileData_returnResp:\(aArrJsonResponse)");

        if aArrJsonResponse.count == 1
        {
            print("LOG =  Successfullly get user profile data...");

            //Save User Data in Plist file for future use
            dictForResponse = aArrJsonResponse[0] as! [String : String];
            print(dictForResponse);
            
            //  Create updtaed plist file
            CommonCodeObj.CreatePlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST, aDictObj: dictForResponse);
            SetDataFromResponse();
        }
        else
        {
            print("LOG = Something went wrong..");
        }
    }

    func getUserPostData_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
        if aArrJsonResponse.count > 0
        {
           print("LOG = Successfully got post data...");
           print("All Post data aArrJsonResponse: \(aArrJsonResponse)");
           
           //NOTE: Here we remove(filter) other user's all posts. You can see all current user's posts here.
           let aStrCurrentUserID = String(CommonCodeObj.GetCurrentUserID());
           let aPredicateToFilterUser = NSPredicate(format: "posted_user_id = '\(aStrCurrentUserID)'");
           arrForFilteredPost = (aArrJsonResponse as NSArray).filtered(using: aPredicateToFilterUser);
           print("filtered arrForFilteredPost: \(arrForFilteredPost)");
           
           collectionViewObj.reloadData();
        }
        else
        {
            print("LOG = No Post found..");
        }
    }

     
    // MARK: - CollectionView Delegate Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(arrForFilteredPost.count > 5)
        {
            return 6;
        }
        else
        {
            return arrForFilteredPost.count;
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if(indexPath.row > 4 || arrForFilteredPost.count == indexPath.row)
        {
            let aCellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell;

            //Set Button
            aCellObj.btnViewAll.CreateRoundButton(aCornerRadius:40);
            aCellObj.btnViewAll.layer.opacity = 0.6;
            aCellObj.btnViewAll.addTarget(self, action: #selector(BtnViewAllUserPostClick), for: .touchUpInside)

            return aCellObj;
        }
        else
        {
            let aCellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContentCell;

            dictForPostedData = arrForFilteredPost[indexPath.row] as! [String : Any];

            //Set Images
            let aStrImgNameList = dictForPostedData["image_list"] as! String;
            let aStrImgName = CommonCodeObj.GetFirstSingleImgFromArray(aStrImgNames: aStrImgNameList);
            
            aCellObj.imgViewContent.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrImgName));

            //Set Title
            aCellObj.lblContentName?.text = dictForPostedData["title"] as? String;
            aCellObj.lblContentName.font = ConstantObj.FONT_TEXTFIELD_TITLE;
            aCellObj.lblContentName.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;

            //Set View's UI
            aCellObj.viewMainCell.SetShadowEffectOnView(cornerRadius: 10, borderWidth: 0.5);

            return aCellObj;
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 150 , height: 180);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let aFullScreenPostVCObj =  self.storyboard?.instantiateViewController(withIdentifier:"FullScreenPostVCIdentifier") as! FullScreenPostVC;
        aFullScreenPostVCObj.dictForPostData = arrForFilteredPost[indexPath.row] as! [String : Any];
        self.navigationController?.pushViewController(aFullScreenPostVCObj, animated: true);
    }
}
