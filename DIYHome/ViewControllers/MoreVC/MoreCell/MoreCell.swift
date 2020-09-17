//
//  MoreCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 24/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell
{
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewNext: UIImageView!
    
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
