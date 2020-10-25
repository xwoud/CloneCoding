//
//  DetailListViewController.swift
//  Project 01 - iOS Note App
//
//  Created by 김민희 on 2020/09/01.
//  Copyright © 2020 김민희. All rights reserved.
//

import UIKit

class DetailListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memoCountLabel: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var titleName: String = ""
    
    override func viewDidLoad() {
        setView()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
extension DetailListViewController {
    func setView() {
        titleLabel.text = titleName
        searchBar.searchBarStyle = .minimal
    }
}
