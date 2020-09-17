//
//  CommonWSCall.swift
//  DIYHome
//
//  Created by Namrata Akash on 19/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class CommonWSCall: NSObject
{
    func WSCallForRequest(aURLRef:URL, completion: @escaping ([Any])->())
    {
          let aRequestObj = URLRequest(url: aURLRef);
          let aSessionObj = URLSession.shared;
          let aDataTaskObj  = aSessionObj.dataTask(with: aRequestObj) { (aDataRef, aResponseRef, err) in
              
              if(aDataRef != nil)
              {
                  let aStrResponseRef  = String(data: aDataRef!, encoding: String.Encoding.utf8);
                  print(aStrResponseRef);
                  
                  do
                  {
                        let aArrJsonResponse  = try JSONSerialization.jsonObject(with: aDataRef!, options: []) as! [Any];
                        DispatchQueue.main.async
                        {
                            completion(aArrJsonResponse);
                        }
                    
                  }
                  catch
                  {
                  }
              }
          }
          aDataTaskObj.resume();
    }
    
    
    func WSCallForPost(aURLRef:URL, aParamRef:String,completion: @escaping ([Any])->())
    {
        
        var aRequestObj = URLRequest(url: aURLRef);
        aRequestObj.addValue(String(aParamRef.count), forHTTPHeaderField: "Content-Length");
        aRequestObj.httpBody  = aParamRef.data(using: String.Encoding.utf8);
        aRequestObj.httpMethod = "POST";
        
        let aSessionObj = URLSession.shared;
        let aDataTaskObj  = aSessionObj.dataTask(with: aRequestObj)
        { (aDataRef, aResponseRef, err) in
         
        if(aDataRef != nil)
         {
            let aStrResponseRef  = String(data: aDataRef!, encoding: String.Encoding.utf8);
            print(aStrResponseRef);
            do
            {
                let aArrJsonResponse  = try JSONSerialization.jsonObject(with: aDataRef!, options: []) as! [Any];
                
                DispatchQueue.main.async
                {
                    completion(aArrJsonResponse);
                }
            }
            catch
            {
            }
         
            }
        }
        aDataTaskObj.resume();
    }
}
