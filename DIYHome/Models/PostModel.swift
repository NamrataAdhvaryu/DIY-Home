//
//  PostModel.swift
//  DIYHome
//
//  Created by Namrata Akash on 30/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class PostModel: NSObject
{
    var post_id :Int?;
    var title:String?;
    var post_description:String?;
    var video_list:String?;
    var category:String?;
    var date_time:String?;
    var posted_user_id:Int?;
    var favorite:String?;
    var likePost:String?;
    var image_list:Data?;
    
    
    init(title:String,post_description:String,image_list:Data,video_list:String,category:String,date_time:String,posted_user_id:Int)//,favorite:String,likePost:String)
    {
        
        self.title = title;
        self.post_description = post_description;
        self.image_list = image_list;
        self.video_list = video_list;
        self.category = category;
        self.date_time = date_time;
        self.posted_user_id = posted_user_id;
    }
    
    init(favorite:String,post_id:Int)
    {
        self.post_id = post_id;
        self.favorite = favorite;
    }
    
    init(likePost:String,post_id:Int)
    {
        self.post_id = post_id;
        self.likePost = likePost;
    }
    
    //New
    init(data: Data)
    {
        self.image_list = data;
    }

}
