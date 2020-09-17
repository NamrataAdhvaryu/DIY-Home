//
//  ViewController.swift
//  DIYHome
//
//  Created by Namrata Akash on 08/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
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
    }
    
}
