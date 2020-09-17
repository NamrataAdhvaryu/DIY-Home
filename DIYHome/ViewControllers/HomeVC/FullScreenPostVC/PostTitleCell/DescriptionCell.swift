//
//  DescriptionCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/04/1942 Saka.
//  Copyright © 1942 YB. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell
{
    
    //MARK: - Outlets
    @IBOutlet weak var viewPostDiscription: UIView!
    @IBOutlet weak var txtViewDiscription: UITextView!
    
    
    //MARK: - Methods
     override func awakeFromNib()
     {
         super.awakeFromNib()
     }

     override func setSelected(_ selected: Bool, animated: Bool)
     {
         super.setSelected(selected, animated: animated)
     }
}
