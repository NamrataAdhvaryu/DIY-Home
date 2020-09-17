//
//  ImageVideoCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/04/1942 Saka.
//  Copyright © 1942 YB. All rights reserved.
//

import UIKit

class ImageVideoCell: UITableViewCell
{
    
    //MARK: - Outlets
    @IBOutlet weak var viewImageVideo: UIView!
    @IBOutlet weak var imgViewPost: UIImageView!
    
    
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
