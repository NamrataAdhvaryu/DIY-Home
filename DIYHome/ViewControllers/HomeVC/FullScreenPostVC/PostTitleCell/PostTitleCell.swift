//
//  PostTitleCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/04/1942 Saka.
//  Copyright © 1942 YB. All rights reserved.
//

import UIKit

class PostTitleCell: UITableViewCell
{
    
    //MARK: - Outlets
    @IBOutlet weak var viewPostTitle: UIView!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var btnUserName: UIButton!
    @IBOutlet weak var imgViewPostTypeIcon: UIImageView!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblPostTitle: UILabel!
    
    
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
