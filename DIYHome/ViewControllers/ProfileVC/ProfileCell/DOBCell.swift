//
//  DOBCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 22/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit

class DOBCell: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnDOB: UIButton!
    
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
