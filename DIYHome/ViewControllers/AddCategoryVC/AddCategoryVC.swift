//
//  AddCategoryVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 18/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class AddCategoryVC: UIViewController
{
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!

    
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
        lblNavBarTitle.text = "Add Category";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
    }
}
