//
//  EditProfileVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 15/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FCAlertView
import MDatePickerView

class EditProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, userProfiledelegate, FCAlertViewDelegate, MDatePickerViewDelegate
{
    //MARK: - MACRO
    let INT_HEADER_HEIGHT = 50;
    let INT_TABLE_FIELD_TAG = 100;
   
    //UPDATE `tbl_UserProfile` SET `user_profile_img`='profileImages/5f4ba19776053.png', `user_cover_img`='profileImages/5f22e910834f0.png' WHERE `profile_id` = 5
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblViewObj: UITableView!
    
    var arrForHeaderTitle = [Any]();
    var dictForAllFields = [String:Any]();
    var dictForResponse = [String: String]();

    var imgForProfilePic = UIImage();
    var imgForProfileCover = UIImage();
    var intForGender = 0;
    var strDOB = String();
    
    
    //MARK: - View Controller Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetCustomUI();
        strDOB = "01/01/1920";
        
        //Set Default Data
        arrForHeaderTitle = ["Profile Picture","Personal","Contacts","Location","Other","Done"];
        dictForAllFields = ["Personal": ["User Name","Display Name","Gender","DOB"],"Conatct":["Email","Contact No."],"Location":["Area","City","Country"],"Other":["About US","Website","Application"],"Done":["Save"]];

        if (CommonCodeObj.CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName: ConstantObj.USER_PROFILE_PLIST))
        {
            dictForResponse = CommonCodeObj.ReadDataFromPlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST);
            //print("dictForResponse: \(dictForResponse)");
        }
        else
        {
            CallWSToGetProfileData();
        }
        
      //Get Img Ref and Set Images
      let aStrProfileImgName = dictForResponse["user_profile_img"]!;
      if(aStrProfileImgName != "")
      {
          imgForProfilePic = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrProfileImgName))!;
      }
      
      //Set Images
       let aStrCoverImgName = dictForResponse["user_cover_img"]!;
       if(aStrCoverImgName != "")
       {
          imgForProfileCover = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrCoverImgName))!;
      }
        
        
        intForGender = Int(dictForResponse["gender"]!) ?? 0;
        print("intForGender: \(intForGender)");
        strDOB = dictForResponse["dob"]!;
    }
    
    
    //MARK: - Button Click Methods
    
    @IBAction func BtnBackClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func BtnSendClick()
    {
        CallWSToUpdateUserProfileData();
    }
    
    @objc func BtnSelectGenderClick(_ sender: Any)
    {
        //Here : 1 = Male, 2 = Female, 3 = Other
        intForGender = (sender as AnyObject).tag;
        print("intForGender click: \(intForGender)");
        tblViewObj.reloadData();
    }
    
    
    //MARK: - Other Methods
    
    func SetCustomUI()
    {
        //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.text = "Edit Profile";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        btnBack.CreateRoundButton(aCornerRadius:30);
    }
    
    
    //MARK: - ImagePicker Methods
    
    @objc func ChooseImage(_ sender: UITapGestureRecognizer? = nil)
    {
       let aImgPicker = UIImagePickerController();
       aImgPicker.sourceType = .photoLibrary;
       aImgPicker.delegate = self;
        aImgPicker.view.tag = sender?.view!.tag as! Int;//.tag = sender?.view!.tag;
        //print(aImgPicker.view.tag);
       self.present(aImgPicker, animated: true, completion: nil);
    }
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if(picker.view.tag == 11)//Cover Pic Click
        {
            imgForProfileCover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;
        }
        else//10-Profile Pic Click
        {
           imgForProfilePic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;
        }
        self.dismiss(animated: true)
        {
            self.tblViewObj.reloadData();
        }
    }
    
    
    //MARK: - UITableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrForHeaderTitle.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            return 4;
        }
        else if(section == 2)
        {
            return 2;
        }
        else if(section == 3)
        {
            return 3;
        }
        else if(section == 4)
        {
           return 3;
        }
        else//5
        {
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section == 0)
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "ProfilePicCell", for: indexPath) as! ProfilePicCell;
            
            
            //Profile PIc
            let aTapGestureForProfilePic = UITapGestureRecognizer(target: self, action: #selector(self.ChooseImage(_:)));
            aCellObj.imgViewProfilePic.addGestureRecognizer(aTapGestureForProfilePic);
            aCellObj.imgViewProfilePic.CreateRoundImageView(aFloatWidth: 120.0);
            
            if(imgForProfilePic.size.width != 0)
            {
                aCellObj.imgViewProfilePic.image = imgForProfilePic;
            }
            else
            {
                aCellObj.imgViewProfilePic.image = UIImage(named: "ProfilePic.png")!;
            }
            
            //Cover Pic
            let aTapGestureForCoverPic = UITapGestureRecognizer(target: self, action: #selector(self.ChooseImage(_:)));
            aCellObj.imgViewProfileCover.addGestureRecognizer(aTapGestureForCoverPic);
            
            if(imgForProfileCover.size.width != 0)
            {
                aCellObj.imgViewProfileCover.image = imgForProfileCover;
            }
            else
            {
                aCellObj.imgViewProfileCover.image = UIImage(named: "CoverPic.png")!;
            }
            //Tag
            aCellObj.imgViewProfilePic.tag = 10;
            aCellObj.imgViewProfileCover.tag = 11;
            return aCellObj;
            
        }
        else if(indexPath.section == 1)
        {
            var aStrDictKeyName = "Other";
            if(indexPath.section == 1)
            {
                aStrDictKeyName = "Personal";
            }
            let aArrTitle = dictForAllFields[aStrDictKeyName] as! [String];

            if(indexPath.row == 2)//Gender
            {
                let aCellObj = tableView.dequeueReusableCell(withIdentifier:"GenderCell", for: indexPath) as! GenderCell;

                //Title
                aCellObj.lblTitle.text = aArrTitle[indexPath.row];
                aCellObj.lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
                aCellObj.lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;

                //UI
                aCellObj.btnMale.CreateRoundButton(aCornerRadius:30);
                aCellObj.btnFemale.CreateRoundButton(aCornerRadius:30);
                aCellObj.btnOther.CreateRoundButton(aCornerRadius:30);
                
                //Here : 1 = Male, 2 = Female, 3 = Other
                if(intForGender == 1)//Male
                {
                    aCellObj.btnMale.CreateRoundSelectedButton(aCornerRadius:30);
                }
                else if(intForGender == 2)//Female
                {
                    aCellObj.btnFemale.CreateRoundSelectedButton(aCornerRadius:30);
                }
                else if(intForGender == 3)//Other
                {
                    aCellObj.btnOther.CreateRoundSelectedButton(aCornerRadius:30);
                }
           
                aCellObj.btnMale.addTarget(self, action: #selector(BtnSelectGenderClick(_:)), for: .touchUpInside)
                aCellObj.btnFemale.addTarget(self, action: #selector(BtnSelectGenderClick(_:)), for: .touchUpInside)
                aCellObj.btnOther.addTarget(self, action: #selector(BtnSelectGenderClick(_:)), for: .touchUpInside)
                
                //Tag
                aCellObj.btnMale.tag = 1;
                aCellObj.btnFemale.tag = 2;
                aCellObj.btnOther.tag = 3;

                return aCellObj;
            }
            else if(indexPath.row == 3)//DOB
            {
                let aCellObj = tableView.dequeueReusableCell(withIdentifier:"DOBCell", for: indexPath) as! DOBCell;
                aCellObj.lblTitle.text = aArrTitle[indexPath.row];
                aCellObj.lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
                aCellObj.lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;

                aCellObj.lblValue.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
                aCellObj.lblValue.font = ConstantObj.FONT_TEXTFIELD_TITLE;
                aCellObj.lblValue.text = strDOB;

                aCellObj.btnDOB.CreateRoundButton(aCornerRadius:30);

                //Tag
                aCellObj.lblValue.tag = (INT_TABLE_FIELD_TAG * indexPath.section) + indexPath.row;//103
                aCellObj.btnDOB.tag = (INT_TABLE_FIELD_TAG * indexPath.section) + indexPath.row;//103
                aCellObj.btnDOB.addTarget(self, action: #selector(ShowCalender), for: .touchUpInside)
                return aCellObj;
            }
            else
            {
                let aCellObj = tableView.dequeueReusableCell(withIdentifier:"TextFieldCell", for: indexPath) as! TextFieldCell;

                aCellObj.lblTitle.text = aArrTitle[indexPath.row];
                aCellObj.lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
                aCellObj.lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;

                aCellObj.txtFieldValue.font = ConstantObj.FONT_TEXTFIELD_TITLE;
                aCellObj.txtFieldValue.tag = (INT_TABLE_FIELD_TAG * indexPath.section) + indexPath.row;//100,101
                aCellObj.txtFieldValue.text = GetTextFieldVal(indexPath: indexPath);
                return aCellObj;
            }
        }
        else if(indexPath.section == 5)
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell;
            aCellObj.btnSave.CreateRoundButton(aCornerRadius:30);
            aCellObj.btnSave.tag = (INT_TABLE_FIELD_TAG * indexPath.section) + indexPath.row;//500
            aCellObj.btnSave.addTarget(self, action: #selector(BtnSendClick), for: .touchUpInside)
            return aCellObj;
        }
        else
        {
            let aCellObj = tableView.dequeueReusableCell(withIdentifier:"TextFieldCell", for: indexPath) as! TextFieldCell;
            var aStrDictKeyName = "Other";//Tag = 400,401,402
            if(indexPath.section == 2)//Tag = 200,201
            {
                aStrDictKeyName = "Conatct";
            }
            else if(indexPath.section == 3)//Tag = 300,301,302
            {
                aStrDictKeyName = "Location";
            }
            let aArrTitle = dictForAllFields[aStrDictKeyName] as! [String];
            aCellObj.lblTitle.text = aArrTitle[indexPath.row];
            aCellObj.lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
            aCellObj.lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;
                
            aCellObj.txtFieldValue.font = ConstantObj.FONT_TEXTFIELD_TITLE;
            aCellObj.txtFieldValue.tag = (INT_TABLE_FIELD_TAG * indexPath.section) + indexPath.row;
            aCellObj.txtFieldValue.text = GetTextFieldVal(indexPath: indexPath);
            return aCellObj;
        }
    }
 
    func GetTextFieldVal(indexPath: IndexPath) -> String
    {
        var aStrValue = " ";//N/A";
        //print("dictForResponse:\(dictForResponse)");
        do {
                if(dictForResponse.keys.count > 0)
            {
                if(indexPath.section == 1)//Personal
                {
                    if(indexPath.row == 0)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal: /*try*/ dictForResponse["user_name"]!))
                        {
                            aStrValue = dictForResponse["user_name"]!;
                        }
                    }
                    else if(indexPath.row == 1)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["display_name"]!))
                        {
                            aStrValue = dictForResponse["display_name"]!;
                        }
                    }
                }
                else if(indexPath.section == 2)//Contact
                {
                    if(indexPath.row == 0)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["email"]!))
                        {
                            aStrValue = dictForResponse["email"]!;
                        }
                    }
                    else if(indexPath.row == 1)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["mobile_no"]!))
                        {
                            aStrValue = dictForResponse["mobile_no"]!;
                        }
                    }
                }
                else if(indexPath.section == 3)//Location
                {
                    if(indexPath.row == 0)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["area"]!))
                        {
                            aStrValue = dictForResponse["area"]!;
                        }
                    }
                    else if(indexPath.row == 1)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["city"]!))
                        {
                            aStrValue = dictForResponse["city"]!;
                        }
                    }
                    else if(indexPath.row == 2)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["country"]!))
                        {
                            aStrValue = dictForResponse["country"]!;
                        }
                    }
                }
                else//Other
                {
                    if(indexPath.row == 0)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["about_us"]!))
                        {
                            aStrValue = dictForResponse["about_us"]!;
                        }
                    }
                    else if(indexPath.row == 1)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["website_details"]!))
                        {
                            aStrValue = dictForResponse["website_details"]!;
                        }
                    }
                    else if(indexPath.row == 2)
                    {
                        if(CommonCodeObj.StringIsNotEmpty(aStrVal:  dictForResponse["application_details"]!))
                        {
                            aStrValue = dictForResponse["application_details"]!;
                        }
                    }
                }
                }
        }
        catch
        {
        }
        return aStrValue;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 0)
        {
            return 270;
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 2 || indexPath.row == 3)
            {
                return 70;
            }
            else
            {
                return 85;
            }
        }
        else if(indexPath.section == 5)
        {
            return 70;
        }
        else
        {
            return 85;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(section == 0 || section == 5)
        {
            return 0;
        }
        else
        {
            return CGFloat(INT_HEADER_HEIGHT);
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if(section == 0 || section == 5)
        {
            return nil;
        }
        else
        {
            let aLblFrame = CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: CGFloat(INT_HEADER_HEIGHT));
            let aLblHeaderTitle = UILabel(frame:aLblFrame);
            aLblHeaderTitle.font = ConstantObj.FONT_TBL_HEADER_TITLE;
            aLblHeaderTitle.text = (arrForHeaderTitle[section] as! String);
            aLblHeaderTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
            
            let aViewFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat(INT_HEADER_HEIGHT));
            let aViewHeaderObj = UIView(frame:aViewFrame);
            aViewHeaderObj.backgroundColor = UIColor.clear;
            aViewHeaderObj.addSubview(aLblHeaderTitle);
            
            return aViewHeaderObj;
        }
    }
    
    
  //MARK: - Webservice Request Call
    
    func CallWSToGetProfileData()
    {
        let aContrlObj = ProfileController();
        aContrlObj.delegate = self;
        let aModelObj = ProfileModel(profile_id: CommonCodeObj.GetCurrentUserID());
        aContrlObj.getUserProfileData(aModelObj: aModelObj);
    }

    func CallWSToUpdateUserProfileData()
    {
        let aContrlObj = ProfileController();
        aContrlObj.delegate = self;
        
        var aStrProfileImgName = "";
        if(imgForProfilePic.size.width != 0)
        {
             aStrProfileImgName = CommonCodeObj.CreateBase64ForImage(aImgObj: imgForProfilePic);
        }
        
        var aStrCoverImgName = "";
        if(imgForProfileCover.size.width != 0)
        {
            aStrCoverImgName = CommonCodeObj.CreateBase64ForImage(aImgObj: imgForProfileCover);
        }
        
        let aModelObj  = ProfileModel(profile_id:CommonCodeObj.GetCurrentUserID(),
        user_name: (dictForResponse["user_name"])!,
        display_name: (dictForResponse["display_name"])!,
        gender:String(intForGender),
        dob: strDOB,
        email: dictForResponse["email"]!,
        mobile_no: dictForResponse["mobile_no"]!,
        area: dictForResponse["area"]!,
        city: dictForResponse["city"]!,
        country: dictForResponse["country"]!,
        about_us: dictForResponse["about_us"]!,
        website_details: dictForResponse["website_details"]!,
        application_details: dictForResponse["application_details"]!,
        user_profile_img: aStrProfileImgName,
        user_cover_img: "N/A");//aStrCoverImgName
        aContrlObj.updateUserProfile(aModelObj: aModelObj);
    }
     
     
     //MARK: - Webservice Response
    
    func getUserProfileData_returnResp(aArrJsonResponse: [Any])
    {
        print("aArrJsonResponse:\(aArrJsonResponse)");

        if aArrJsonResponse.count > 0 //( > 0 OR == 1)
        {
            print("LOG =  Successfullly get user profile data...");

            //Save User Data in Plist file for future use
            dictForResponse = aArrJsonResponse[0] as! [String : String];
            print("dictForResponse 2:\(dictForResponse)");
            
            //Create updtaed plist file
            CommonCodeObj.CreatePlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST, aDictObj: dictForResponse);
            tblViewObj.reloadData();
        }
        else
        {
            print("LOG = Something went wrong..");
        }
    }
    
     func updateUserProfile_returnResp(aArrJsonResponse: [Any])
     {
         print("aArrJsonResponse:\(aArrJsonResponse)");
         let aDictTemp  = aArrJsonResponse[0] as? [String:String];
         let aStrStatus  = aDictTemp!["status"];
         
         if aStrStatus  == "Success"
         {
              DispatchQueue.main.async
              {
                    self.ShowAlertView(strTitle:"Success", strMsg:"Record Inserted Sucessfully ...", strDoneBtnTitle:"Ok", aIntTag:101);
                
                    //Check User Profile plist file is exixt or not
                    if (CommonCodeObj.CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName: ConstantObj.USER_PROFILE_PLIST))
                    {
                        //Remove old plist file first
                        CommonCodeObj.RemovePlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST);
                    }
                
                    //Create updtaed plist file - to create this file we need to get latest profile data from server
                    //CommonCodeObj.CreatePlistFile(aStrPlistName: ConstantObj.USER_PROFILE_PLIST, aDictObj: aDictTemp!);
              }
              print("LOG = Record Inserted Sucessfully ...");
         }
         else
         {
             print("LOG = Failed ...");
         }
       }
    
    
    //MARK: - UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
         var aStrValue = textField.text!;
        if(dictForResponse.keys.count > 0)
        {
            if(textField.tag == 100)//User Name
            {
                dictForResponse = ["user_name":aStrValue];
            }
            else if(textField.tag == 101)//Display Name
            {
                dictForResponse = ["display_name": aStrValue];
            }
            else if(textField.tag == 200)//Email
            {
                dictForResponse = ["email": aStrValue];
            }
            else if(textField.tag == 201)//Contact No.
            {
                dictForResponse = ["mobile_no": aStrValue];
            }
            else if(textField.tag == 300)//Area
            {
                dictForResponse = ["area": aStrValue];
            }
            else if(textField.tag == 301)//City
            {
                dictForResponse = ["city": aStrValue];
            }
            else if(textField.tag == 302)//Country
            {
                dictForResponse = ["country":aStrValue];
            }
            else if(textField.tag == 400)//About Us
            {
                dictForResponse = ["about_us":aStrValue];
            }
            else if(textField.tag == 401)//Website
            {
                dictForResponse = ["website_details":aStrValue];
            }
            else if(textField.tag == 402)//Application
            {
                dictForResponse = ["application_details":aStrValue];
            }
        }
    }
    
    
    //MARK: - AlertView Methods
    func ShowAlertView(strTitle: String, strMsg: String, strDoneBtnTitle: String, aIntTag:Int)
    {
        let alert = FCAlertView();
        alert.delegate = self;
        alert.tag = aIntTag;
        if(aIntTag == 101)//Send
        {
            alert.makeAlertTypeSuccess();
        }
        else
        {
            alert.makeAlertTypeWarning();
        }
        alert.showAlert(inView: self, withTitle:strTitle, withSubtitle:strMsg, withCustomImage: nil, withDoneButtonTitle: strDoneBtnTitle, andButtons:nil)
    }
    
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView)
    {
        if(alertView.tag == 101)//Send
        {
            [self.navigationController?.popViewController(animated: true)];
        }
        else//Error
        {
            
        }
    }
    
    
    //MARK: - Calender Methods

    @objc func ShowCalender()
    {
        view.addSubview(MDate)
        NSLayoutConstraint.activate([
        MDate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        MDate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        MDate.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        MDate.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])

        view.addSubview(Today)
        Today.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        Today.topAnchor.constraint(equalTo: MDate.bottomAnchor, constant: 20).isActive = true

        view.addSubview(Label)
        Label.topAnchor.constraint(equalTo: Today.bottomAnchor, constant: 30).isActive = true
        Label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func HideCalender()
    {
        MDate.removeFromSuperview();
        Label.removeFromSuperview();
        Today.removeFromSuperview();
    }
    
    lazy var MDate : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.delegate = self
        mdate.Color = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;//UIColor(red: 0/255, green: 178/255, blue: 113/255, alpha: 1)
        mdate.cornerRadius = 14
        mdate.translatesAutoresizingMaskIntoConstraints = false
        mdate.from = 1920
        mdate.to = 2050
        return mdate
    }()

    let Today : UIButton = {
        let but = UIButton(type:.system)
        but.setTitle("    Done    ", for: .normal)
        but.addTarget(self, action: #selector(done), for: .touchUpInside)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        
        but.setTitleColor(UIColor.green, for: .normal);
        but.backgroundColor = UIColor.white;
        but.titleLabel?.font = UIFont.systemFont(ofSize: 30);
        but.backgroundColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        but.layer.cornerRadius = 25;// but.frame.size.height / 2;
        but.setTitleColor(.white, for: .normal);
        
        return but
    }()

    let Label : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc func done()
    {
        HideCalender();
    }

    @objc func today()
    {
        //You can get current date using this function
        MDate.selectDate = Date()
    }

    func mdatePickerView(selectDate: Date)
    {
        print("selected date 1: \(selectDate)");
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: selectDate)
         strDOB = date;
        print("strDOB : \(strDOB)");
        tblViewObj.reloadData();
        //Label.text = date
    }
}
