//
//  LikeCommentCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/04/1942 Saka.
//  Copyright © 1942 YB. All rights reserved.
//

import UIKit
import FaveButton

class LikeCommentCell: UITableViewCell
{
    
    //MARK: - Outlets
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var btnLike: FaveButton!
    @IBOutlet weak var btnShare: FaveButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblShares: UILabel!
    
    
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
