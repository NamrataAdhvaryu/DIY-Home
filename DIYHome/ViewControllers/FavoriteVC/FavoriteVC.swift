//
//  FavoriteVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 18/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import FaveButton

class FavoriteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, userPostdelegate, UISearchBarDelegate, FaveButtonDelegate
{

    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
    var arrForFilteredPost = [Any]();
    var dictForPostedData = [String:Any]();
    
    //Search
    @IBOutlet weak var searchBarObj: UISearchBar!
    var arrofSearchText = [Any]();
    var boolSearchIsOn :Bool = false;
    
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
        lblNavBarTitle.text = "Favorite";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
    }
    
    func HideShowSearchBar()
    {
        searchBarObj.isHidden = false;
        if(arrForFilteredPost.count == 0)
        {
            searchBarObj.isHidden = true;
        }
    }
    
    //MARK: - Btn click Methods
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool)
    {
        if(selected)
         {
            CallWSToUpdateFavoriteStatusForPost(aStrFavStatus: "1", aIntPostID:faveButton.tag);
         }
         else
         {
              CallWSToUpdateFavoriteStatusForPost(aStrFavStatus: "0", aIntPostID:faveButton.tag);
         }
    }

     // MARK: - CollectionView Delegate Method
              
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(boolSearchIsOn == true)
        {
            return arrofSearchText.count;
        }
        else
        {
            return arrForFilteredPost.count;
        }
    }
              
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let aCellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCell;
        if(boolSearchIsOn == true)
        {
            dictForPostedData = arrofSearchText[indexPath.row] as! [String : Any];
        }
        else
        {
            dictForPostedData = arrForFilteredPost[indexPath.row] as! [String : Any];
        }

        //Display Post Image
        let aStrImgNameList = dictForPostedData["image_list"] as! String;
        let aStrImgName = CommonCodeObj.GetFirstSingleImgFromArray(aStrImgNames: aStrImgNameList);
        aCellObj.imgViewPic.image = UIImage(data:CommonCodeObj.DisplayImageFromServer(aStrBaseURL: ConstantObj.BASE_URL, aStrImgName: aStrImgName));

        //Print Title Value
        aCellObj.lblContentTitle.text = (dictForPostedData["title"] as! String);

        //Print Date Value
        let aStrDate = dictForPostedData["date_time"] as! String;
        let aStrCurDate = CommonCodeObj.GetCurrentDateTime();
        let aStrPrintVal = CommonCodeObj.GetPrintedValueBaseOnDate(aStrStartDate: aStrDate, aStrEndDate: aStrCurDate);
        aCellObj.lblForDate?.text = aStrPrintVal ;

        //Favorite
        let aIntPostId = Int(dictForPostedData["post_id"] as! String)!
        aCellObj.btnFavorite?.tag = aIntPostId;
        let aStrLikeStatus = (dictForPostedData["favorite"] as! String);
        
        if(aStrLikeStatus == "1")
        {
            aCellObj.btnFavorite?.isSelected = true;
        }
        else
        {
            aCellObj.btnFavorite?.isSelected = false;
        }

        //Set View UI
        aCellObj.viewMoreControls.SetShadowEffectOnView(cornerRadius: 30, borderWidth: 0);
        aCellObj.viewTextContent.SetShadowEffectOnView(cornerRadius: 30, borderWidth: 0);
        aCellObj.viewMain.SetShadowEffectOnViewTemp(cornerRadius: 0, borderWidth: 2);

        return aCellObj;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 412, height: 250);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 15;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let aFullScreenPostVCObj =  self.storyboard?.instantiateViewController(withIdentifier:"FullScreenPostVCIdentifier") as! FullScreenPostVC;
        if(boolSearchIsOn == true)
        {
            aFullScreenPostVCObj.dictForPostData = arrofSearchText[indexPath.row] as! [String : Any];
        }
        else
        {
            aFullScreenPostVCObj.dictForPostData = arrForFilteredPost[indexPath.row] as! [String : Any];
        }
        self.navigationController?.pushViewController(aFullScreenPostVCObj, animated: true);
    }
    

    //MARK: - Webservice Request Call
    func CallWSToGetPostedData()
    {
        let aContrlObj = PostController();
        aContrlObj.delegate = self;
        aContrlObj.getUserPostData();
    }
    
    func CallWSToUpdateFavoriteStatusForPost(aStrFavStatus: String, aIntPostID: Int)
    {
        let aContrlObj = PostController();
        aContrlObj.delegate = self;
        let aModelObj = PostModel(favorite: aStrFavStatus, post_id: aIntPostID);
        aContrlObj.updateFavoriteStatusForPost(aModelObj: aModelObj);
    }
    
    //MARK: - Webservice Response
    func getUserPostData_returnResp(aArrJsonResponse: [Any])
    {
        print(aArrJsonResponse);
        if aArrJsonResponse.count > 0
        {
            print("LOG = Get post data...");

            DispatchQueue.main.async
            {
            }

            //NOTE: Here we need favorite post only
            let aStrFavStatus = "1";
            let aPredicateToFilterUser = NSPredicate(format: "favorite = '\(aStrFavStatus)'");
            arrForFilteredPost = (aArrJsonResponse as NSArray).filtered(using: aPredicateToFilterUser);
            print("filtered arrForFilteredPost: \(arrForFilteredPost)");
            collectionViewObj .reloadData();
            HideShowSearchBar();
        }
        else
        {
            print("LOG = No Post found..");
        }
    }


    func updateFavoriteStatusForPost_returnResp(aArrJsonResponse: [Any])
    {
        print("aArrJsonResponse:\(aArrJsonResponse)");
        let aDictTemp  = aArrJsonResponse[0] as? [String:String];
        let aStrStatus  = aDictTemp!["status"];

        if aStrStatus  == "Success"
        {
            print("LOG = Sucessfully updated Favorite status for post...");
        }
        else
        {
            print("LOG = Failed to update Favorite status for post...");
        }
    }
    
    
      //MARK: - SEARCH
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
      {
          if(searchText.isEmpty)//if(searchText.characters.count == 0)
          {
              boolSearchIsOn = false;
              self.collectionViewObj?.reloadData();
          }
          else
          {
              boolSearchIsOn = true;
              self.SearchText(aStrText: searchBar.text!);
          }
      }
       
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
      {
          searchBar.resignFirstResponder()
          boolSearchIsOn = false;
          self.SearchText(aStrText: searchBar.text!);
      }
          
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
      {
          searchBar.resignFirstResponder()
          boolSearchIsOn = false;
          searchBar.text = "";
          self.SearchText(aStrText: searchBar.text!);
      }
      
      func SearchText(aStrText: String)
      {
          let aPredicteObj = NSPredicate(format:"self.title contains[c] %@",aStrText);
          arrofSearchText = arrForFilteredPost.filter{aPredicteObj.evaluate(with:$0)}
          self.collectionViewObj?.reloadData();
      }     
}
