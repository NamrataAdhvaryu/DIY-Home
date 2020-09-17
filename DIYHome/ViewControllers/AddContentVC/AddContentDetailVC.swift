//
//  AddContentDetailVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 29/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FCAlertView

class AddContentDetailVC: UIViewController, userPostdelegate, FCAlertViewDelegate
{
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var imgViewBottomLine: UIImageView!

    var strSelectedImgName = String();
    var arrForSelectedImgs = [UIImage]();

    
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
        lblNavBarTitle.text = "Add Content";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        btnBack.CreateRoundButton(aCornerRadius:30);
        btnPost.CreateRoundButton(aCornerRadius:30);

        lblTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        lblDescription.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        lblTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;
        lblDescription.font = ConstantObj.FONT_TEXTFIELD_TITLE;

        txtFieldTitle.font = ConstantObj.FONT_TEXTFIELD_TITLE;
        txtViewDescription.font = ConstantObj.FONT_TEXTFIELD_TITLE;
        txtFieldTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        txtViewDescription.textColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE;
        imgViewBottomLine.backgroundColor = ConstantObj.COLOR_APP_THEME_PRIMARY;
    }

    
    //MARK: - Button Click Methods
    @IBAction func BtnBackClick(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true);
    }

    @IBAction func BtnPostClick(_ sender: Any)
    {
        CallWSToPostData();
    }

  
    //MARK: - Webservice Request Call
    
    
    func CallWSToPostData()
    {
        var ImgArray = [Any]();

        let aStrCurrentDate = CommonCodeObj.GetCurrentDateTime();//2020-07-08 14:55:46
        for i in 0..<arrForSelectedImgs.count//item in arrForSelectedImgs
        {
            //print("\(i)");
            let aStrImageName = CommonCodeObj.CreateBase64ForImage(aImgObj: arrForSelectedImgs[i]);
            let dic = ["title" : txtFieldTitle.text!,
            "post_description" : txtViewDescription.text!,
            "image_list" : aStrImageName,
            "video_list" : "N/A",
            "category" : "N/A",
            "date_time" : aStrCurrentDate,
            "posted_user_id" : CommonCodeObj.GetCurrentUserID()] as [String : Any];
            ImgArray.append(dic);
        }

        do
        {
            let jsondata = try JSONSerialization.data(withJSONObject: ImgArray, options: [])
            let postImgObj = PostController();
            postImgObj.delegate = self;

            let addPostImg = PostModel(data: jsondata);
            postImgObj.userPostNew(aModelObj: addPostImg);
        }
        catch
        {
        }
    }
    
         
    //MARK: - Webservice Response
    func userPost_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
        let aDictTemp  = aArrJsonResponse[0] as? [String:String];
        let aStrStatus  = aDictTemp!["status"];

        if aStrStatus  == "Success"
        {
            DispatchQueue.main.async
            {
                self.ShowAlertView(strTitle:"Success", strMsg:"Post Added Sucessfully ...", strDoneBtnTitle:"Ok", aIntTag:101);
            }
            print("LOG = Post Added Sucessfully ...");
        }
        else
        {
            print("LOG = Failed ...");
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
}
