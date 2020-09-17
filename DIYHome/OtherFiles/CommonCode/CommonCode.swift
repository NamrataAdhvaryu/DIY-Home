//
//  CommonCode.swift
//  DIYHome
//
//  Created by Namrata Akash on 16/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class CommonCode: NSObject
{

    //MARK: - App
    func GetCurrentUserID() -> Int
    {
        let dictForResponse = CommonCodeObj.ReadDataFromPlistFile(aStrPlistName: ConstantObj.USER_LOGIN_PLIST);
        print(dictForResponse);
        let aIntProfileId = Int(dictForResponse["id"]!);
        return aIntProfileId!;
    }
    
    func IsProfileIDAndCurrentUserIDAreSame(aIntProfileId:Int) -> Bool
    {
        var aBoolStatus = false;
        let aIntCurrentUserId = GetCurrentUserID();
        if(aIntCurrentUserId == aIntProfileId)
        {
            aBoolStatus = true;
        }
        return aBoolStatus;
    }
    
    func StringIsNotEmpty(aStrVal: String) -> Bool
    {
        var aBoolStatus = false;
        let myString = aStrVal;//String();
        
        //Check if 'string' is not nil and not empty
        //if myString == aStrVal, !myString.isEmpty
        if (!myString.isEmpty)
        {
            // string is not nil and not empty...
            aBoolStatus = true;
        }
        
        if(myString == "" && myString == " ")
        {
            aBoolStatus = false;
        }
        
        return aBoolStatus;
    }
   
    
    //MARK: - Navigation
    
    //Code for navigate current to next view controller
    func PushVC(aCurrentVCObj:UIViewController, aStrNextVCIdentifier:String)
    {
       let aStoryBoardObj =  aCurrentVCObj.storyboard?.instantiateViewController(withIdentifier:aStrNextVCIdentifier);
       aCurrentVCObj.navigationController?.pushViewController(aStoryBoardObj!, animated: true);
    }
    
    func PushVCWithoutAnimation(aCurrentVCObj:UIViewController, aStrNextVCIdentifier:String)
    {
           let aStoryBoardObj =  aCurrentVCObj.storyboard?.instantiateViewController(withIdentifier:aStrNextVCIdentifier);
           aCurrentVCObj.navigationController?.pushViewController(aStoryBoardObj!, animated: false);
    }
    
    
    //MARK: - Plist
    //Create Plist File and add data in plist file
    func CreatePlistFile(aStrPlistName:String, aDictObj:[String : String])
    {
          let aStrFinalPathObj = CreatePathForPlistFile(aStrPlistNameRef: aStrPlistName);
          WriteDataInPlistFile(aStrFinalPathObj: aStrFinalPathObj, aDictObj: aDictObj);
    }
    
    //Create path for plist file as per plist name
    func CreatePathForPlistFile(aStrPlistNameRef:String) -> String
    {
        let aStrPathObj = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let aStrFullPathObj = aStrPathObj[0];

        let aStrFinalPathObj = aStrFullPathObj.appending( "/" + aStrPlistNameRef + ".plist");//"/profile.plist"
        print(aStrFinalPathObj);
        
        return aStrFinalPathObj;
    }
    
    //Check Plist File Is exist or not
     func CheckPlistFileIsExistOrNot(aStrFinalPathObj:String) -> Bool
     {
         let aFileMangrObj = FileManager();
         if aFileMangrObj.fileExists(atPath: aStrFinalPathObj)
         {
             print("Plist file is already exists...")
             return true;
         }
         else
         {
             return false;
         }
     }
    
    
    //Add (write) data in created plist file
    func WriteDataInPlistFile(aStrFinalPathObj:String, aDictObj:[String : String])
    {
        if !CheckPlistFileIsExistOrNot(aStrFinalPathObj: aStrFinalPathObj)
        {
            let aDictFinal = NSDictionary(dictionary: aDictObj);
            aDictFinal.write(toFile: aStrFinalPathObj, atomically: true);
        }
    }
    
    //Get (read) data in created plist file
    func ReadDataFromPlistFile(aStrPlistName:String) -> [String : String]
    {
         let aStrFinalPathObj = CreatePathForPlistFile(aStrPlistNameRef: aStrPlistName);
        var aDictFinal = [String : String]();
        
        if CheckPlistFileIsExistOrNot(aStrFinalPathObj: aStrFinalPathObj)
        {
            aDictFinal = NSDictionary(contentsOfFile: aStrFinalPathObj) as! [String : String];
            print(aDictFinal);
        }

        return aDictFinal;
    }
    
    //Remove plist file
     func RemovePlistFile(aStrPlistName:String)// -> Bool
       {
           let aStrFinalPathObj = CreatePathForPlistFile(aStrPlistNameRef: aStrPlistName);
           let aFileMangrObj = FileManager();
           if aFileMangrObj.fileExists(atPath: aStrFinalPathObj)
           {
               print("Plist file is already exists...")
            
               do
               {
                   try aFileMangrObj.removeItem(atPath: aStrFinalPathObj);
                   print("Plist file deleted successfully...")
               }
               catch
               {

                   print("Plist file not deleted...")
               }
           }
       }
    
    
    //to Check Plist file is exist or not as per direct file name
    func CheckPlistFileIsExistOrNotAsPerFileName(aStrPlistName:String) -> Bool
    {
        let aStrFinalPathObj = CreatePathForPlistFile(aStrPlistNameRef: aStrPlistName);
        let aFileMangrObj = FileManager();
        if aFileMangrObj.fileExists(atPath: aStrFinalPathObj)
        {
            print("Plist file is already exists...")
            return true;
        }
        else
        {
            return false;
        }
    }
    
    //create Base 64 for uiimage
    func CreateBase64ForImage(aImgObj: UIImage) -> String
      {
          let aDataImg = aImgObj.jpegData(compressionQuality: 2.0);
          let aStringBase64 = aDataImg?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
          return aStringBase64!;
      }
    
    func DisplayImageFromServer(aStrBaseURL: String, aStrImgName: String) -> Data
    {
        let aStrFullPath = "\(aStrBaseURL)\(aStrImgName)";
        print("aStrFullPath:\(aStrFullPath)");
           let aURLObj = URL(string: aStrFullPath);
           do
           {
                let aDataObj = try! Data(contentsOf: aURLObj!);
                return aDataObj ;
           }
           catch
           {
               
           }
    }
    
    //MARK: - Project Code
    
    func GetFirstSingleImgFromArray(aStrImgNames: String) -> String
    {
        let aArrOfImgaes = aStrImgNames.components(separatedBy: ",");
        return aArrOfImgaes[0];
    }
    
    func GetImgArray(aStrImgNames: String) -> Array<Any>
    {
        let aArrOfImgaes = aStrImgNames.components(separatedBy: ",");
        return aArrOfImgaes;
    }
    
    //MARK: - Date
    
    //To get Current date and time
    func GetCurrentDateTime() -> String
    {
        let aDate = Date();
        let aDateFormatter = DateFormatter();
        aDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss";
        let aStrCurDate = aDateFormatter.string(from: aDate);
        print("GetCurrentDateTime: \(aStrCurDate)");//2020-07-08 10:55:46
        return aStrCurDate;
    }

    //Convert String to Date
    func ConvertStringToDate(aStrDate: String) -> Date
    {
        let aDateFormatter = DateFormatter();
        aDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss";
        let aDateObj = aDateFormatter.date(from: aStrDate);
        print("ConvertStringToDate: \(aDateObj!)");//2020-04-19 05:40:20 +0000
        return aDateObj!;
    }

    //CONVERT FROM NSDate to String
    func ConvertDateToString(aDateObj: NSDate) -> String
    {
        let aDateFormatter = DateFormatter();
        aDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss";
        let aStrDate: String = aDateFormatter.string(from: aDateObj as Date);
        print("ConvertDateToString: \(aStrDate)");
        return aStrDate;
    }
    
    func GetPrintedValueBaseOnDate(aStrStartDate: String, aStrEndDate: String) -> String
    {
        let aDateStart = ConvertStringToDate(aStrDate: aStrStartDate);
        let aDateEnd = ConvertStringToDate(aStrDate: aStrEndDate);
        
        var aStrFinalVal = "Today";
        let aCalendarObj = Calendar.current;
        let aComponentsObj = aCalendarObj.dateComponents([.calendar, .year, .month, .day, .hour, .minute, .second], from: aDateStart, to: aDateEnd);
       
        if(aComponentsObj.year! > 0)
        {
            //10 year(s) ago
            aStrFinalVal = String("\(aComponentsObj.year!) year(s) ago");
        }
        else if(aComponentsObj.month! > 0)
        {
            //2 month(s) ago
            aStrFinalVal = String("\(aComponentsObj.month!) month(s) ago");
        }
        else if(aComponentsObj.day! > 0)
        {
            aStrFinalVal = String("\(aComponentsObj.day!) day(s) ago");
        }
        else if(aComponentsObj.hour! > 0)
        {
          aStrFinalVal = String("\(aComponentsObj.hour!) hour(s) ago");
        }
        else if(aComponentsObj.minute! > 0)
        {
          aStrFinalVal = String("\(aComponentsObj.minute!) minute(s) ago");
        }
        else if(aComponentsObj.second! > 0)
        {
          aStrFinalVal = String("\(aComponentsObj.second!) second(s) ago");
        }
        return aStrFinalVal;
    }
}


//MARK: - UITextField
extension UITextField
{
      func SetBottomBorderForTextField(aFloatBottomY: CGFloat)
      {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - aFloatBottomY, width: self.frame.width, height: 1.0)
            bottomLine.backgroundColor = ConstantObj.COLOR_APP_THEME_PRIMARY.cgColor;
            self.borderStyle = UITextField.BorderStyle.none
            self.layer.addSublayer(bottomLine)
      }
    
    func CreateRoundTextField()
    {
          self.layer.cornerRadius = 25;
          self.layer.borderWidth = 0;
    }

    func SetShadowEffectOnTextField()
    {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSize(width: 2,height: 2);
        self.backgroundColor = ConstantObj.COLOR_APP_THEME_SECONDARY;
    }
}


//MARK: - UIButton
extension UIButton
{ 
      func CreateRoundButton(aCornerRadius: CGFloat)
      {
            self.layer.cornerRadius = aCornerRadius;
            self.layer.borderWidth = 0;
            self.backgroundColor = ConstantObj.COLOR_APP_THEME_BUTTON_BG;
            self.tintColor = ConstantObj.COLOR_APP_THEME_BUTTON_TEXT;
            self.titleLabel?.textColor = ConstantObj.COLOR_APP_THEME_BUTTON_TEXT;
      }
    
    
    func CreateRoundSelectedButton(aCornerRadius: CGFloat)
    {
        self.layer.cornerRadius = aCornerRadius;
        self.layer.borderWidth = 3;
        self.layer.borderColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE.cgColor;
        self.backgroundColor = ConstantObj.COLOR_APP_THEME_BUTTON_BG;
        self.tintColor = ConstantObj.COLOR_APP_THEME_BUTTON_TEXT;
        self.titleLabel?.textColor = ConstantObj.COLOR_APP_THEME_BUTTON_TEXT;

        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSize(width: 2,height: 2);
    }
    
    func SetShadowEffectOnButton()
    {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSize(width: 2,height: 2);
    }
}


//MARK: - UIImageView
extension UIImageView
{
      func CreateRoundImageView(aFloatWidth: CGFloat)
      {
            self.layer.cornerRadius = aFloatWidth/2;
            self.layer.borderWidth = 0;
      }
    
     func SetShadowEffectOnImageView(cornerRadius: CGFloat, borderWidth: CGFloat)
       {
           self.layer.cornerRadius = cornerRadius;
           self.layer.borderWidth = borderWidth;
           self.layer.borderColor = UIColor.white.cgColor;
           self.layer.shadowRadius = 2;
           self.layer.shadowOpacity = 0.1;
           self.layer.shadowOffset = CGSize(width: 2,height: 2);
       }
}


//MARK: - UIView
extension UIView
{
    func SetShadowEffectOnView(cornerRadius: CGFloat, borderWidth: CGFloat)
    {
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSize(width: 2,height: 2);
    }
   func SetShadowEffectOnViewTemp(cornerRadius: CGFloat, borderWidth: CGFloat)
   {
       self.layer.cornerRadius = cornerRadius;
       self.layer.borderWidth = borderWidth;
       self.layer.borderColor = ConstantObj.COLOR_APP_THEME_TEXT_NORMAL_TITLE.cgColor;
       self.layer.shadowRadius = 2;
       self.layer.shadowOpacity = 0.1;
       self.layer.shadowOffset = CGSize(width: 2,height: 2);
   }
}


//MARK: - UIColor
//let color = UIColor(hexString: "#3f3f3f")
extension UIColor
{
    convenience init(hexString: String, alpha: CGFloat = 1.0)
    {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#"))
        {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

}

