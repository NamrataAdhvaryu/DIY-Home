//
//  ContactUsVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 25/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController
{
    
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    
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
        lblNavBarTitle.text = "Contact Us";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        btnBack.CreateRoundButton(aCornerRadius:30);
    }
    
    
    //MARK: - Button Click Methods
     @IBAction func BtnBackClick(_ sender: Any)
     {
         self.navigationController?.popViewController(animated: true);
     }
}
