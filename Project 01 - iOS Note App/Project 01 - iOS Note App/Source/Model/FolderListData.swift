//
//  FolderListData.swift
//  Project 01 - iOS Note App
//
//  Created by 김민희 on 2020/08/21.
//  Copyright © 2020 김민희. All rights reserved.
//

import Foundation
struct FolderListData {
    var folderName: String
    var folderCount: Int
    
    init(folderName: String, folderCount: Int) {
        self.folderName = folderName
        self.folderCount = folderCount
    }
}
