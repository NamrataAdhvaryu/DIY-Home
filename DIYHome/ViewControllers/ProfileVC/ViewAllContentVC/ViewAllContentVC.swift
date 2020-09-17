//
//  ViewAllContentVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 26/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ViewAllContentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, userPostdelegate
{
    
    //MARK: - Outlets
    
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var collectionViewObj: UICollectionView!
    var arrForFilteredPost = [Any]();
    var dictForPostedData = [String:Any]();
    
    
    //MARK: - View Controller
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetCustomUI();
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        CallWSToGetPostedData();
    }

    
    //MARK: - Other Methods
    
    func SetCustomUI()
    {
        //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.text = "User's All Posts";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        btnBack.CreateRoundButton(aCornerRadius:30);
     }
    
    
    //MARK: - Button Click Methods
    
     @IBAction func BtnBackClick(_ sender: Any)
     {
         self.navigationController?.popViewController(animated: true);
     }
    
    
    // MARK: - CollectionView Delegate Method
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrForFilteredPost.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let aCellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContentCell;

        dictForPostedData = arrForFilteredPost[indexPath.row] as! [String : Any];
        let aStrImgNameList = dictForPostedData["image_list"] as! String;
        let aStrImgName = CommonCodeObj.GetFirstSingleImgFromArray(aStrImgNames: aStrImgNameList);
        print("aStrImgName :\(aStrImgName)");
        aCellObj.imgViewContent.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrImgName));

        aCellObj.lblContentName.text = (dictForPostedData["title"] as! String);
        return aCellObj;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let aCollectionViewWidth = self.view.frame.size.width;
        return CGSize(width: aCollectionViewWidth/2 - 15, height: (aCollectionViewWidth/2 - 15) + 80);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5;
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

    
    //MARK: - Webservice Request Call
    func CallWSToGetPostedData()
    {
        let aContrlObj = PostController();
        aContrlObj.delegate = self;
        aContrlObj.getUserPostData();
    }


    //MARK: - Webservice Response
    func getUserPostData_returnResp(aArrJsonResponse: [Any])
    {
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

}
