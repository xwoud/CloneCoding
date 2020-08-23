//
//  MemoCell.swift
//  Project 01 - iOS Note App
//
//  Created by 김민희 on 2020/08/24.
//  Copyright © 2020 김민희. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {
    static let identifier: String = "MomoCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
