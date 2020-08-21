//
//  FolderCell.swift
//  Project 01 - iOS Note App
//
//  Created by 김민희 on 2020/08/21.
//  Copyright © 2020 김민희. All rights reserved.
//

import UIKit

class FolderCell: UITableViewCell {
    static let identifier: String = "FolderCell"
    
    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setFolderListData(folderName: String, folderCount: Int) {
        self.folderNameLabel.text = folderName
        self.countLabel.text = String(folderCount)
    }

}
