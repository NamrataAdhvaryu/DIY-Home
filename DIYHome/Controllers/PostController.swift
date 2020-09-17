//
//  PostController.swift
//  DIYHome
//
//  Created by Namrata Akash on 30/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

@objc protocol userPostdelegate
{
    @objc optional func userPost_returnResp(aArrJsonResponse:[Any]);
    @objc optional func getUserPostData_returnResp(aArrJsonResponse:[Any]);
    @objc optional func updateFavoriteStatusForPost_returnResp(aArrJsonResponse:[Any]);
    @objc optional func updateLikeStatusForPost_returnResp(aArrJsonResponse:[Any]);
}


class PostController: NSObject
{
    var delegate :userPostdelegate?;
    
    func userPostNew(aModelObj :PostModel)
    {
       let aUrlObj  = URL(string: "http://localhost/DIYHome/userPost.php");
       var request = URLRequest(url: aUrlObj!)
       request.addValue(String(aModelObj.image_list!.count), forHTTPHeaderField: "Content-Length")
       request.httpBody = aModelObj.image_list;
       request.httpMethod = "POST"
       
       let session = URLSession.shared
       let dataTask = session.dataTask(with: request) { (data, resp, error) in
           
       let str = String(data: data!, encoding: String.Encoding.utf8)
       print(str!)
       
           do
           {
               let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
               DispatchQueue.main.async
               {
                   self.delegate?.userPost_returnResp!(aArrJsonResponse: json)
               }
           }
           catch
           {
               print("error")
           }
       
       }
       dataTask.resume()
    }
    
    func userPost(aModelObj :PostModel)
    {
        let aUrlObj  = URL(string: "http://localhost/DIYHome/userPost.php");
        let aStrBodyObj = "&title=\(aModelObj.title!)&image_list=\(aModelObj.image_list!)&video_list=\(aModelObj.video_list!)&category=\(aModelObj.category!)&post_description=\(aModelObj.post_description!)&date_time=\(aModelObj.date_time!)&posted_user_id=\(aModelObj.posted_user_id!)";
  
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion:
            { (result) -> () in
                   print("Delegate method called..");
               self.delegate?.userPost_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
    
    func getUserPostData()
    {
           let aUrlObj  = URL(string: "http://localhost/DIYHome/getPost.php?");
           print(aUrlObj!);
        
           if(aUrlObj != nil)
           {
               CommonWSCall().WSCallForRequest(aURLRef: aUrlObj!, completion: { (result) -> () in
                 print("Delegate method called..");
                  self.delegate?.getUserPostData_returnResp!(aArrJsonResponse: result);
                });
           }
           else
           {
               print("LOG = Something went wrong...");
           }
    }
    
    func updateFavoriteStatusForPost(aModelObj :PostModel)
       {
           let aUrlObj  = URL(string: "http://localhost/DIYHome/updateFavoritePostStatus.php");
           let aStrBodyObj = "&post_id=\(aModelObj.post_id!)&favorite=\(aModelObj.favorite!)";
           
           if(aUrlObj != nil)
           {
               CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                      print("Delegate method called..");
                  self.delegate?.updateFavoriteStatusForPost_returnResp!(aArrJsonResponse: result);
                });
           }
           else
           {
               print("LOG = Something went wrong...");
           }
       }
    
    
    func updateLikeStatusForPost(aModelObj :PostModel)
    {
        let aUrlObj  = URL(string: "http://localhost/DIYHome/updateLikePostStatus.php");
        let aStrBodyObj = "&post_id=\(aModelObj.post_id!)&likePost=\(aModelObj.likePost!)";
        //Optional("UPDATE tbl_AddPost SET likePost = \'1\' WHERE post_id = \'17\'[{\"status\":\"Fail\"}]")
        if(aUrlObj != nil)
        {
            CommonWSCall().WSCallForPost(aURLRef: aUrlObj!, aParamRef: aStrBodyObj, completion: { (result) -> () in
                   print("Delegate method called..");
               self.delegate?.updateLikeStatusForPost_returnResp!(aArrJsonResponse: result);
             });
        }
        else
        {
            print("LOG = Something went wrong...");
        }
    }
}
