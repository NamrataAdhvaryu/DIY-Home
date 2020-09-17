//
//  GenderCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell
{
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
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
