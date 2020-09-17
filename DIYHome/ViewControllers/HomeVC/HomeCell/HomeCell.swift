//
//  HomeCell.swift
//  DIYHome
//
//  Created by Namrata Akash on 21/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import BEMCheckBox
import FaveButton

class HomeCell: UICollectionViewCell
{
    @IBOutlet weak var viewTextContent: UIView!
    @IBOutlet weak var lblContentTitle: UILabel!
    @IBOutlet weak var lblForDate: UILabel!
    @IBOutlet var btnFavorite: FaveButton?
    
    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewMoreControls: UIView!
}
