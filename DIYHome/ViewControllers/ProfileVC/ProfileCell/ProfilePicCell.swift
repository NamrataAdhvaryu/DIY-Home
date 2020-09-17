//
//  ProfilePicCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 15/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class ProfilePicCell: UITableViewCell
{
    //MARK: - Outlets
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var imgViewProfileCover: UIImageView!
    
    
    //MARK: - Other Methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
